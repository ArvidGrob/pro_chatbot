import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form controllers for input fields
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables for UI control
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9C7BE8), // Light purple
              Color(0xFF6B5CE7), // Darker purple
              Color(0xFF4F46E5), // Blue purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button (only visible on certain states)
              _buildHeader(),

              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Robot avatar (visible in design E)
                      if (_shouldShowAvatar()) _buildRobotAvatar(),

                      if (_shouldShowAvatar()) const SizedBox(height: 16),

                      // App title (visible in design E)
                      if (_shouldShowAvatar())
                        const Text(
                          'Luminara AI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                      if (_shouldShowAvatar()) const SizedBox(height: 20),

                      // Login title
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46E5),
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Form fields
                      Expanded(
                        child: _buildForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build header with back button (visible in design E)
  Widget _buildHeader() {
    if (!_shouldShowAvatar()) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Build robot avatar (similar to sign up page)
  Widget _buildRobotAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.smart_toy_outlined,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  // Build main form with all input fields
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Student ID field
          _buildInputField(
            controller: _studentIdController,
            hintText: 'Student ID',
            fieldType: InputFieldType.studentId,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Student ID is verplicht';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password field
          _buildInputField(
            controller: _passwordController,
            hintText: 'Wachtwoord',
            fieldType: InputFieldType.password,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wachtwoord is verplicht';
              }
              return null;
            },
          ),

          // Error message (if login fails)
          if (_hasError)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Het juiste account help u hier aan!',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          const SizedBox(height: 30),

          // Login button
          _buildLoginButton(),

          const SizedBox(height: 20),

          // Forgot password button
          _buildForgotPasswordButton(),

          const SizedBox(height: 20),

          // Sign up link
          _buildSignUpLink(),

          const Spacer(),
        ],
      ),
    );
  }

  // Build input field with different styles based on design states
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required InputFieldType fieldType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    // Determine field style based on current state
    Color fieldColor = _getFieldColor(fieldType);
    Color textColor = _getTextColor(fieldType);

    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: textColor.withOpacity(0.7),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  // Build login button with different styles based on state
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // Build forgot password button
  Widget _buildForgotPasswordButton() {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          _showForgotPasswordDialog();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Text(
            'Wachtwoord vergeten?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Build sign up link
  Widget _buildSignUpLink() {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          _navigateToSignUp();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Nog geen account? Meld je hier aan!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Determine if avatar should be shown (design E style)
  bool _shouldShowAvatar() {
    return true; // Can be modified based on specific design state
  }

  // Get field color based on design progression and state
  Color _getFieldColor(InputFieldType fieldType) {
    if (_hasError && fieldType == InputFieldType.password) {
      return Colors.red.shade100.withOpacity(0.8);
    }
    return Colors.white.withOpacity(0.9);
  }

  // Get text color based on field state
  Color _getTextColor(InputFieldType fieldType) {
    if (_hasError && fieldType == InputFieldType.password) {
      return Colors.red.shade700;
    }
    return const Color(0xFF4F46E5);
  }

  // Handle login process
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Simulate login validation (for demo purposes)
      if (_studentIdController.text.toLowerCase() == 'demo' &&
          _passwordController.text == 'password') {
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  // Navigate to sign up page
  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  // Show forgot password dialog
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Color(0xFF4F46E5),
                size: 28,
              ),
              SizedBox(width: 8),
              Text('Wachtwoord vergeten?'),
            ],
          ),
          content: const Text(
            'Neem contact op met uw docent om uw wachtwoord te resetten.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog after successful login
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 8),
              Text('Login succesvol!'),
            ],
          ),
          content: const Text(
            'Welkom bij Luminara AI! U bent succesvol ingelogd.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to welcome page
                // Here you would typically navigate to the main app
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Enum to define different input field types for styling
enum InputFieldType {
  studentId,
  password,
}
