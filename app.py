import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime, timezone
from bson import ObjectId
from flask_cors import CORS
import pymysql.cursors
import requests
import pymysql
import bcrypt

app = Flask(__name__)
CORS(app)

MONGO_HOST = os.getenv('MONGO_HOST', 'localhost')
MONGO_PORT = int(os.getenv('MONGO_PORT', '27017'))
MONGO_USER = os.getenv('MONGO_USER', 'prochatbot_app')
MONGO_PASSWORD = os.getenv('MONGO_PASSWORD', 'pass1')
MONGO_DB = os.getenv('MONGO_DB', 'prochatbot_conversations')

MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
MYSQL_USER = os.getenv('MYSQL_USER', 'prochatbot_user')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', 'pass1')
MYSQL_DB = os.getenv('MYSQL_DB', 'prochatbot')

OLLAMA_HOST = os.getenv('OLLAMA_HOST', 'http://localhost:11434')

def get_mongo_client():
    client = MongoClient(f'mongodb://prochatbot_app:pass1@{MONGO_HOST}:27017/prochatbot_conversations')
    return client['prochatbot_conversations']

def get_db_connection():
    return pymysql.connect(
        host=MYSQL_HOST,
        user='prochatbot_user',
        password='pass1',
        database='prochatbot',
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/api/chat', methods=['POST'])
def chat():
    data = request.get_json()
    user_id = data.get('user_id')
    conversation_id = data.get('conversation_id') 
    message = data.get('message')
    
    if not user_id or not message:
        return jsonify({'error': 'user_id and message required'}), 400
    
    try:
        db = get_mongo_client()
        
        # If conversation_id provided, check if it exists
        if conversation_id:
            existing_conv = db.conversations.find_one({'_id': ObjectId(conversation_id)})
            if not existing_conv:
                # Conversation doesn't exist anymore, create a new one
                print(f"WARNING: Conversation {conversation_id} not found, creating new one")
                conversation_id = None
        
        # Create new conversation if necessary
        if not conversation_id:
            conversation = {
                'user_id': user_id,
                'created_at': datetime.now(timezone.utc).isoformat(),
                'messages': []
            }
            result = db.conversations.insert_one(conversation)
            conversation_id = str(result.inserted_id)
            print(f"Created new conversation: {conversation_id}")
        
        user_msg = {
            'role': 'user',
            'content': message,
            'timestamp': datetime.now(timezone.utc).isoformat()
        }
        
        db.conversations.update_one(
            {'_id': ObjectId(conversation_id)},
            {'$push': {'messages': user_msg}}
        )
        
        # Track question in statistics
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute('SELECT school_id FROM user WHERE id = %s', (user_id,))
            result = cursor.fetchone()
            if result and result.get('school_id'):
                cursor.execute("""
                    INSERT INTO statistics (school_id, total_logins, total_questions, total_session_duration)
                    VALUES (%s, 0, 1, 0)
                    ON DUPLICATE KEY UPDATE total_questions = total_questions + 1
                """, (result['school_id'],))
                conn.commit()
            conn.close()
        except Exception as e:
            print(f"Error tracking question: {e}")
        
        conversation = db.conversations.find_one({'_id': ObjectId(conversation_id)})
        messages = conversation['messages']
        
        ai_messages = [
            {
                'role': 'system',
                'content': 'You are a helpful tutor for vocational students. ALWAYS reply in the SAME language the student uses - if they write in Dutch, reply in Dutch; if they write in English, reply in English; if they write in another language, reply in that language. Keep answers short and simple. Use short sentences and simple words. When explaining something, use numbered steps. If a question is unclear, kindly ask what the student means. At the end, give one short follow-up question suggestion.'
            }
        ]
        for msg in messages:
            ai_messages.append({
                'role': msg['role'],
                'content': msg['content']
            })
        print("DEBUG - Sending to AI:", ai_messages)        
        ai_response = requests.post(f'{OLLAMA_HOST}/api/chat', json={
            'model': 'qwen3:30b',
            'messages': ai_messages,
            'temperature': 0.5,
            'stream': False
        })
        
        ai_content = ai_response.json()['message']['content']
        
        ai_msg = {
            'role': 'assistant',
            'content': ai_content,
            'timestamp': datetime.now(timezone.utc).isoformat()
        }
        
        db.conversations.update_one(
            {'_id': ObjectId(conversation_id)},
            {'$push': {'messages': ai_msg}}
        )
        
        return jsonify({
            'conversation_id': conversation_id,
            'response': ai_content
        }), 200
        
    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password required'}), 400

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Get user by email
        cursor.execute('SELECT * FROM user WHERE email = %s', (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({'error': 'Invalid credentials'}), 401

        # Check password
        if bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            # Track login in statistics
            school_id = user.get('school_id')
            print(f"DEBUG - Login tracking: user_id={user['id']}, school_id={school_id}")
            
            if school_id:
                try:
                    cursor.execute("""
                        INSERT INTO statistics (school_id, total_logins, total_questions, total_session_duration)
                        VALUES (%s, 1, 0, 0)
                        ON DUPLICATE KEY UPDATE total_logins = total_logins + 1
                    """, (school_id,))
                    
                    # Create session record
                    cursor.execute("""
                        INSERT INTO user_sessions (user_id, school_id)
                        VALUES (%s, %s)
                    """, (user['id'], school_id))
                    
                    conn.commit()
                    print(f"DEBUG - Login tracked successfully for school_id={school_id}")
                except Exception as e:
                    print(f"ERROR tracking login: {e}")
            else:
                print(f"WARNING - User {user['id']} has no school_id")
            
            return jsonify({
                'id': user['id'],
                'email': user['email'],
                'firstname': user['firstname'],
                'lastname': user['lastname'],
                'middlename': user.get('middlename', ''),
                'role': user['role']
            }), 200
        else:
            return jsonify({'error': 'Invalid credentials'}), 401

    except Exception as e:
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500

    finally:
        if conn:
            conn.close()
@app.route('/api/classes/<int:class_id>/students', methods=['GET'])
def get_class_students(class_id):
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT student_id 
        FROM class_students
        WHERE class_id = %s
    """, (class_id,))

    rows = cur.fetchall()
    conn.close()

    return jsonify([r[0] for r in rows])

@app.route('/api/classes/<int:class_id>/students', methods=['PUT'])
def update_class_students(class_id):
    data = request.json
    students = data.get("students", [])

    conn = get_db_connection()
    cur = conn.cursor()

    # delete old entries
    cur.execute("DELETE FROM class_students WHERE class_id = %s", (class_id,))

    # save new data
    for s in students:
        cur.execute("""
            INSERT INTO class_students (class_id, student_id)
            VALUES (%s, %s)
        """, (class_id, s))

    conn.commit()
    conn.close()

    return jsonify({"status": "ok"})


@app.route('/api/change-password', methods=['POST'])
def change_password():
    data = request.get_json()
    email = data.get('email')
    old_password = data.get('old_password')
    new_password = data.get('new_password')

    if not email or not old_password or not new_password:
        return jsonify({'success': False, 'message': 'Missing fields'}), 400

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        
        cursor.execute('SELECT * FROM user WHERE email = %s', (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({'success': False, 'message': 'User not found'}), 404

        
        if not bcrypt.checkpw(old_password.encode('utf-8'),
                              user['password'].encode('utf-8')):
            return jsonify({'success': False, 'message': 'Old password is incorrect'}), 401

        
        new_hash = bcrypt.hashpw(new_password.encode('utf-8'),
                                 bcrypt.gensalt()).decode('utf-8')

        
        cursor.execute(
            'UPDATE user SET password = %s WHERE id = %s',
            (new_hash, user['id'])
        )
        conn.commit()

        return jsonify({'success': True}), 200

    except Exception as e:
        print('Error in change_password:', e)
        return jsonify({'success': False, 'message': 'Server error'}), 500

    finally:
        if conn:
            conn.close()
@app.route('/api/change-name', methods=['POST'])
def change_name():
    data = request.get_json()
    email = data.get('email')
    new_firstname = data.get('firstname')
    new_lastname = data.get('lastname')

    if not email or not new_firstname or not new_lastname:
        return jsonify({'success': False, 'message': 'Missing fields'}), 400

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Prüfen, ob der User existiert
        cursor.execute('SELECT * FROM user WHERE email = %s', (email,))
        user = cursor.fetchone()

        if not user:
            return jsonify({'success': False, 'message': 'User not found'}), 404

        # Namen updaten
        cursor.execute(
            'UPDATE user SET firstname = %s, lastname = %s WHERE id = %s',
            (new_firstname, new_lastname, user['id'])
        )
        conn.commit()

        return jsonify({'success': True}), 200

    except Exception as e:
        print('Error in /api/change-name:', e)
        return jsonify({'success': False, 'message': 'Server error'}), 500

    finally:
        if conn:
            conn.close()

# ==================== HELP REQUEST ENDPOINTS ====================

@app.route('/api/help-requests', methods=['POST'])
def create_help_request():
    """Create a new help request (for students)"""
    try:
        data = request.get_json()

        student_id = data.get('student_id')
        student_name = data.get('student_name')
        subject = data.get('subject')
        message = data.get('message')

        if not all([student_id, student_name, subject, message]):
            return jsonify({'error': 'Missing required fields'}), 400

        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            INSERT INTO help_requests 
            (student_id, student_name, subject, message, status, created_at)
            VALUES (%s, %s, %s, %s, 'pending', NOW())
        """, (student_id, student_name, subject, message))

        connection.commit()
        request_id = cursor.lastrowid
        cursor.close()
        connection.close()

        return jsonify({
            'success': True,
            'id': request_id,
            'message': 'Help request created successfully'
        }), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests', methods=['GET'])
def get_all_help_requests():
    """Get all help requests (for teachers/admin)"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            SELECT id, student_id, student_name, subject, message, 
                   status, teacher_id, teacher_response, 
                   created_at, responded_at
            FROM help_requests
            ORDER BY created_at DESC
        """)

        requests = cursor.fetchall()

  	# Convert datetime objects to ISO format strings
        for req in requests:
            if req.get('created_at'):
                req['created_at'] = req['created_at'].isoformat()
            if req.get('responded_at'):
                req['responded_at'] = req['responded_at'].isoformat()

        cursor.close()	
        connection.close()

        return jsonify(requests), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests/student/<int:student_id>', methods=['GET'])
def get_student_help_requests(student_id):
    """Get help requests for a specific student"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            SELECT id, student_id, student_name, subject, message, 
                   status, teacher_id, teacher_response, 
                   created_at, responded_at
            FROM help_requests
            WHERE student_id = %s
            ORDER BY created_at DESC
        """, (student_id,))

        requests = cursor.fetchall()

   	# Convert datetime objects to ISO format strings
        for req in requests:
            if req.get('created_at'):
                req['created_at'] = req['created_at'].isoformat()
            if req.get('responded_at'):
                req['responded_at'] = req['responded_at'].isoformat()

        cursor.close()
        connection.close()

        return jsonify(requests), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests/<int:request_id>', methods=['GET'])
def get_help_request(request_id):
    """Get a single help request by ID"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            SELECT id, student_id, student_name, subject, message, 
                   status, teacher_id, teacher_response, 
                   created_at, responded_at
            FROM help_requests
            WHERE id = %s
        """, (request_id,))

        request_data = cursor.fetchone()

  	# Convert datetime objects to ISO format strings
        for req in requests:
            if req.get('created_at'):
                req['created_at'] = req['created_at'].isoformat()
            if req.get('responded_at'):
                req['responded_at'] = req['responded_at'].isoformat()

        cursor.close()
        connection.close()

        if request_data:
            return jsonify(request_data), 200
        else:
            return jsonify({'error': 'Request not found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests/<int:request_id>/respond', methods=['PUT'])
def respond_to_help_request(request_id):
    """Teacher responds to a help request"""
    try:
        data = request.get_json()

        teacher_id = data.get('teacher_id')
        teacher_response = data.get('teacher_response')

        if not all([teacher_id, teacher_response]):
            return jsonify({'error': 'Missing required fields'}), 400

        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            UPDATE help_requests
            SET teacher_id = %s,
                teacher_response = %s,
                status = 'responded',
                responded_at = NOW()
            WHERE id = %s
        """, (teacher_id, teacher_response, request_id))

        connection.commit()

        if cursor.rowcount == 0:
            cursor.close()
            connection.close()
            return jsonify({'error': 'Request not found'}), 404

        cursor.close()
        connection.close()

        return jsonify({
            'success': True,
            'message': 'Response sent successfully'
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests/<int:request_id>/resolve', methods=['PUT'])
def resolve_help_request(request_id):
    """Mark a help request as resolved"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            UPDATE help_requests
            SET status = 'resolved'
            WHERE id = %s
        """, (request_id,))

        connection.commit()

        if cursor.rowcount == 0:
            cursor.close()
            connection.close()
            return jsonify({'error': 'Request not found'}), 404

        cursor.close()
        connection.close()

        return jsonify({
            'success': True,
            'message': 'Request marked as resolved'
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
# ==================== END HELP REQUEST ENDPOINTS ====================

# ====================  USER FETCHING AND GETTERS AND UPDATE ====================
@app.route('/api/users', methods=['POST'])
def create_user():
    data = request.get_json()
    firstname = data.get('firstname')
    middlename = data.get('middlename')  # optional
    lastname = data.get('lastname')
    email = data.get('email')
    password = data.get('password')
    role = data.get('role', 'student')  # default student
    school_id = data.get('schoolId')  # <-- new

    if not all([firstname, lastname, email, password]):
        return jsonify({'error': 'Missing fields'}), 400

    # Hash password
    hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO user (firstname, middlename, lastname, email, password, role, school_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (firstname, middlename, lastname, email, hashed_pw, role, school_id))  # pass school_id

        conn.commit()
        user_id = cursor.lastrowid
        cursor.close()
        conn.close()

        return jsonify({'success': True, 'id': user_id}), 201

    except pymysql.err.IntegrityError as e:
        return jsonify({'error': 'Email already exists'}), 409

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/users', methods=['GET'])
def get_users():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        # Get only students
        cursor.execute("SELECT id, firstname, middlename, lastname, email, role FROM user WHERE role = %s", ('student',))
        users = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify(users), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/users/teachers', methods=['GET'])
def get_teachers_and_admins():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        # Fetch only teachers and admins
        cursor.execute(
            "SELECT id, firstname, middlename, lastname, email, role "
            "FROM user "
            "WHERE role IN (%s, %s)",
            ('teacher', 'admin')
        )
        users = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify(users), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500    

@app.route('/api/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json()
    
    firstname = data.get('firstname')
    middlename = data.get('middlename')
    lastname = data.get('lastname')
    email = data.get('email')
    old_password = data.get('old_password')
    new_password = data.get('password')  # frontend sends 'password' for new one

    if not all([firstname, lastname, email]):
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)

        # Fetch current password from DB
        cursor.execute("SELECT password FROM user WHERE id = %s", (user_id,))
        user = cursor.fetchone()
        if not user:
            return jsonify({'error': 'User not found'}), 404

        # If password change requested, verify old password
        if new_password:
            if not old_password or not bcrypt.checkpw(old_password.encode('utf-8'), user['password'].encode('utf-8')):
                return jsonify({'error': 'Old password incorrect'}), 400
            new_hashed_pw = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        else:
            new_hashed_pw = user['password']  # keep old password

        # Update user
        cursor.execute("""
            UPDATE user
            SET firstname=%s, middlename=%s, lastname=%s, email=%s, password=%s
            WHERE id=%s
        """, (firstname, middlename, lastname, email, new_hashed_pw, user_id))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'message': 'User updated successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    try:
        connection = get_db_connection()
        with connection.cursor() as cursor:
            # Check if user exists
            cursor.execute("SELECT role, firstname, lastname FROM user WHERE id = %s", (user_id,))
            user = cursor.fetchone()
            if not user:
                return jsonify({'error': 'User not found'}), 404

            # ADD later ==  Admin then can remove teacher or admin if teacher only students can be removed

            # Delete the user (teacher, admin, or student)
            cursor.execute("DELETE FROM user WHERE id = %s", (user_id,))
            connection.commit()

        return jsonify({'message': f"{user['role'].capitalize()} {user['firstname']} {user['lastname']} deleted successfully"}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        connection.close()
# ==================== END USER FETCHING AND GETTERS ====================
# ==================== SCHOOL FETCHING AND UPDATE ====================
@app.route('/api/users/<int:user_id>/school', methods=['GET'])
def get_user_school(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    cursor.execute("""
        SELECT s.id, s.name, s.zip_code, s.street_name, s.house_number, s.town
        FROM user u
        JOIN school s ON u.school_id = s.id
        WHERE u.id = %s
    """, (user_id,))
    school = cursor.fetchone()
    conn.close()

    if school:
        return jsonify(school), 200
    else:
        return jsonify({'error': 'School not found'}), 404

@app.route('/api/schools/<int:school_id>', methods=['PUT'])
def update_school(school_id):
    data = request.get_json()
    name = data.get('name')
    zip_code = data.get('zip_code')
    street_name = data.get('street_name')
    house_number = data.get('house_number')
    town = data.get('town')

    if not all([name, zip_code, street_name, house_number, town]):
        return jsonify({'error': 'Missing fields'}), 400

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE school
            SET name=%s, zip_code=%s, street_name=%s, house_number=%s, town=%s
            WHERE id=%s
        """, (name, zip_code, street_name, house_number, town, school_id))
        conn.commit()
        conn.close()
        return jsonify({'message': 'School updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== END SCHOOL FETCHING AND UPDATE ====================
# ==================== GET AND FETCH AND DELETE CLASS ====================
@app.route('/api/classes', methods=['GET'])
def get_classes():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT id, name FROM classes ORDER BY name")
    rows = cursor.fetchall()

    cursor.close()
    conn.close()
    return jsonify(rows), 200

@app.route('/api/classes', methods=['POST'])
def create_class():
    data = request.get_json()
    name = data.get('name')
    students = data.get('students', [])  # <-- list of student IDs

    if not name:
        return jsonify({'error': 'Class name required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Create class
        cursor.execute("INSERT INTO classes (name) VALUES (%s)", (name,))
        conn.commit()
        class_id = cursor.lastrowid

        # Assign students to this class
        if students:
            student_ids = [s['id'] for s in students]  # extract IDs
            format_strings = ','.join(['%s'] * len(student_ids))
            cursor.execute(
                f"UPDATE user SET class_id = %s WHERE id IN ({format_strings})",
                [class_id] + student_ids
            )
            conn.commit()

        # Fetch the newly created class
        cursor.execute("SELECT id, name FROM classes WHERE id = %s", (class_id,))
        row = cursor.fetchone()

        cursor.close()
        conn.close()
        return jsonify(row), 201

    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({'error': str(e)}), 500

@app.route('/api/classes/<int:class_id>', methods=['PUT'])
def rename_class(class_id):
    data = request.get_json()
    new_name = data.get('name')

    if not new_name:
        return jsonify({'error': 'New name required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "UPDATE classes SET name = %s WHERE id = %s",
        (new_name, class_id)
    )
    conn.commit()

    if cursor.rowcount == 0:
        cursor.close()
        conn.close()
        return jsonify({'error': 'Class not found'}), 404

    cursor.execute(
        "SELECT id, name FROM classes WHERE id = %s",
        (class_id,)
    )
    row = cursor.fetchone()

    cursor.close()
    conn.close()
    return jsonify(row), 200

@app.route('/api/classes/<int:class_id>', methods=['DELETE'])
def delete_class(class_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM classes WHERE id = %s", (class_id,))
    conn.commit()
    deleted = cursor.rowcount

    cursor.close()
    conn.close()

    if deleted == 0:
        return jsonify({'error': 'Class not found'}), 404

    return jsonify({'success': True}), 200
# ==================== END GET AND FETCH AND DELETE CLASS ====================
# ==================== CONVERSATION ENDPOINTS ====================

@app.route('/api/help-requests/<int:request_id>/messages', methods=['GET'])
def get_conversation_messages(request_id):
    """Get all messages for a help request conversation"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        cursor.execute("""
            SELECT id, help_request_id, sender, sender_id, sender_name, 
                   message, created_at
            FROM help_request_messages
            WHERE help_request_id = %s
            ORDER BY created_at ASC
        """, (request_id,))
        
        messages = cursor.fetchall()
        
        # Convert datetime to ISO format
        for msg in messages:
            if msg.get('created_at'):
                msg['created_at'] = msg['created_at'].isoformat()
        
        cursor.close()
        connection.close()
        
        return jsonify(messages), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/help-requests/<int:request_id>/messages', methods=['POST'])
def add_conversation_message(request_id):
    """Add a new message to the conversation"""
    try:
        data = request.get_json()
        
        sender = data.get('sender')  # 'student' or 'teacher'
        sender_id = data.get('sender_id')
        sender_name = data.get('sender_name')
        message = data.get('message')
        
        if not all([sender, sender_id, sender_name, message]):
            return jsonify({'error': 'Missing required fields'}), 400
        
        if sender not in ['student', 'teacher']:
            return jsonify({'error': 'Invalid sender type'}), 400
        
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # Insert the message
        cursor.execute("""
            INSERT INTO help_request_messages 
            (help_request_id, sender, sender_id, sender_name, message, created_at)
            VALUES (%s, %s, %s, %s, %s, NOW())
        """, (request_id, sender, sender_id, sender_name, message))
        
        message_id = cursor.lastrowid
        
        # Update help_request status based on who sends the message
        if sender == 'teacher':
            cursor.execute("""
                UPDATE help_requests
                SET status = 'responded', 
                    teacher_id = %s,
                    responded_at = NOW()
                WHERE id = %s
            """, (sender_id, request_id))
        elif sender == 'student':
            # When student replies, set status back to pending
            cursor.execute("""
                UPDATE help_requests
                SET status = 'pending'
                WHERE id = %s
            """, (request_id,))

        connection.commit()
        cursor.close()
        connection.close()
        
        return jsonify({
            'success': True,
            'message_id': message_id
        }), 201
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==================== END CONVERSATION ENDPOINTS ====================

# ==================== CHAT CONVERSATION ENDPOINTS ====================

@app.route('/api/conversations/user/<int:user_id>', methods=['GET'])
def get_user_conversations(user_id):
    """Get all conversations for a specific user"""
    try:
        db = get_mongo_client()
        
        conversations = list(db.conversations.find(
            {'user_id': user_id},
            {'_id': 1, 'user_id': 1, 'title': 1, 'created_at': 1, 'updated_at': 1, 'messages': 1}
        ).sort('created_at', -1))
        
        # Convert ObjectId to string
        for conv in conversations:
            conv['_id'] = str(conv['_id'])
            
            # Generate title if not exists
            if 'title' not in conv or not conv['title']:
                if conv.get('messages') and len(conv['messages']) > 0:
                    first_user_msg = next(
                        (msg for msg in conv['messages'] if msg.get('role') == 'user'),
                        None
                    )
                    if first_user_msg:
                        content = first_user_msg.get('content', 'Nieuwe conversatie')
                        conv['title'] = content[:50] + ('...' if len(content) > 50 else '')
                    else:
                        conv['title'] = 'Nieuwe conversatie'
                else:
                    conv['title'] = 'Nieuwe conversatie'
        
        return jsonify(conversations), 200
        
    except Exception as e:
        print(f"ERROR in get_user_conversations: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500


@app.route('/api/conversations/<conversation_id>', methods=['GET'])
def get_conversation(conversation_id):
    """Get a specific conversation by ID"""
    try:
        db = get_mongo_client()
        
        conversation = db.conversations.find_one({'_id': ObjectId(conversation_id)})
        
        if not conversation:
            return jsonify({'error': 'Conversation not found'}), 404
        
        conversation['_id'] = str(conversation['_id'])
        
        # Generate title if not exists
        if 'title' not in conversation or not conversation['title']:
            if conversation.get('messages') and len(conversation['messages']) > 0:
                first_user_msg = next(
                    (msg for msg in conversation['messages'] if msg.get('role') == 'user'),
                    None
                )
                if first_user_msg:
                    content = first_user_msg.get('content', 'Nieuwe conversatie')
                    conversation['title'] = content[:50] + ('...' if len(content) > 50 else '')
                else:
                    conversation['title'] = 'Nieuwe conversatie'
            else:
                conversation['title'] = 'Nieuwe conversatie'
        
        return jsonify(conversation), 200
        
    except Exception as e:
        print(f"ERROR in get_conversation: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500


@app.route('/api/conversations/<conversation_id>', methods=['DELETE'])
def delete_conversation(conversation_id):
    """Delete a specific conversation"""
    try:
        db = get_mongo_client()
        
        result = db.conversations.delete_one({'_id': ObjectId(conversation_id)})
        
        if result.deleted_count == 0:
            return jsonify({'error': 'Conversation not found'}), 404
        
        return jsonify({'success': True, 'message': 'Conversation deleted'}), 200
        
    except Exception as e:
        print(f"ERROR in delete_conversation: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500


@app.route('/api/conversations/<conversation_id>/title', methods=['PUT'])
def update_conversation_title(conversation_id):
    """Update conversation title"""
    try:
        data = request.get_json()
        new_title = data.get('title')
        
        if not new_title:
            return jsonify({'error': 'Title required'}), 400
        
        db = get_mongo_client()
        
        result = db.conversations.update_one(
            {'_id': ObjectId(conversation_id)},
            {
                '$set': {
                    'title': new_title,
                    'updated_at': datetime.now(timezone.utc).isoformat()
                }
            }
        )
        
        if result.matched_count == 0:
            return jsonify({'error': 'Conversation not found'}), 404
        
        return jsonify({'success': True, 'message': 'Title updated'}), 200
        
    except Exception as e:
        print(f"ERROR in update_conversation_title: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500

# ==================== END CHAT CONVERSATION ENDPOINTS ====================

# ==================== STATISTICS ENDPOINTS ====================

@app.route('/api/statistics/<int:school_id>', methods=['GET'])
def get_statistics(school_id):
    """Get statistics for a specific school"""
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Get statistics
        cursor.execute("""
            SELECT 
                total_logins,
                total_questions,
                total_session_duration,
                last_updated
            FROM statistics
            WHERE school_id = %s
        """, (school_id,))
        
        stats = cursor.fetchone()
        
        if not stats:
            # Initialize statistics for this school if not exists
            cursor.execute("""
                INSERT INTO statistics (school_id, total_logins, total_questions, total_session_duration)
                VALUES (%s, 0, 0, 0)
            """, (school_id,))
            conn.commit()
            
            return jsonify({
                'total_logins': 0,
                'total_questions': 0,
                'total_session_duration': 0
            }), 200
        
        return jsonify({
            'total_logins': stats['total_logins'],
            'total_questions': stats['total_questions'],
            'total_session_duration': stats['total_session_duration']
        }), 200
        
    except Exception as e:
        print(f"ERROR in get_statistics: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({'error': 'Server error'}), 500
    finally:
        if conn:
            conn.close()

# ==================== END STATISTICS ENDPOINTS ====================

if __name__ == '__main__':
    # Make sure you run with caddy if using port 5050
    app.run(host='0.0.0.0', port=5050, debug=True)
