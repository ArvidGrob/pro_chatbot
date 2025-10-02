import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Form controllers for input fields
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables for UI control
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              // Header with back button and logo
              _buildHeader(),

              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Robot avatar
                      _buildRobotAvatar(),

                      const SizedBox(height: 16),

                      // App title
                      const Text(
                        'Luminara AI',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Sign up title
                      const Text(
                        'SIGN UP',
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

  // Build header with back button
  Widget _buildHeader() {
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

  // Build robot avatar similar to welcome page
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
              if (value.length < 6) {
                return 'Wachtwoord moet minimaal 6 tekens bevatten';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Confirm password field
          _buildInputField(
            controller: _confirmPasswordController,
            hintText: 'Herhaal Wachtwoord',
            fieldType: InputFieldType.confirmPassword,
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            onTogglePassword: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bevestig uw wachtwoord';
              }
              if (value != _passwordController.text) {
                return 'Wachtwoorden komen niet overeen';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Approval request button (as seen in design)
          _buildApprovalRequestButton(),

          const Spacer(),

          // Submit button
          _buildSubmitButton(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Build input field with different styles based on design stages
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required InputFieldType fieldType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    // Determine field style based on current step and field type
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

  // Build approval request button as shown in designs
  Widget _buildApprovalRequestButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {
          _showApprovalDialog();
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
            'Stuur een goedkeuringsverzoek naar uw docent!',
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

  // Build submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
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
                'Ga naar uw inlogpagina!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // Get field color based on design progression
  Color _getFieldColor(InputFieldType fieldType) {
    switch (fieldType) {
      case InputFieldType.studentId:
        return Colors.white.withOpacity(0.9);
      case InputFieldType.password:
        return Colors.white.withOpacity(0.9);
      case InputFieldType.confirmPassword:
        return Colors.white.withOpacity(0.9);
    }
  }

  // Get text color based on field state
  Color _getTextColor(InputFieldType fieldType) {
    return const Color(0xFF4F46E5);
  }

  // Handle sign up process
  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        _showSuccessDialog();
      }
    }
  }

  // Show approval request dialog
  void _showApprovalDialog() {
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
                Icons.send,
                color: Color(0xFF4F46E5),
                size: 28,
              ),
              SizedBox(width: 8),
              Text('Goedkeuringsverzoek'),
            ],
          ),
          content: const Text(
            'Uw verzoek is verzonden naar de docent voor goedkeuring.',
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

  // Show success dialog after registration
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
              Text('Registratie succesvol!'),
            ],
          ),
          content: const Text(
            'Uw account is succesvol aangemaakt. U kunt nu inloggen.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to welcome page
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
  confirmPassword,
}
