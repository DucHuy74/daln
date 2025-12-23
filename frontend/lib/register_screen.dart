import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Đảm bảo bạn đã cài package này

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Page & Form Controllers
  final _pageController = PageController();

  // Data Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Logic Responsive: Dưới 800px coi là màn hình nhỏ (Mobile/Tablet dọc)
  bool _isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  // --- LOGIC NAVIGATION (NEXT/BACK) ---
  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _handleRegister();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // --- VALIDATION LOGIC ---
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Tên
        if (_firstNameController.text.isEmpty)
          return _showError('Please enter your first name');
        if (_lastNameController.text.isEmpty)
          return _showError('Please enter your last name');
        return true;
      case 1: // Ngày sinh
        if (_dobController.text.isEmpty)
          return _showError('Please select your date of birth');
        return true;
      case 2: // Username & Email
        if (_usernameController.text.isEmpty)
          return _showError('Please enter a username');
        if (_usernameController.text.length < 3)
          return _showError('Username must be at least 3 characters');
        if (_emailController.text.isEmpty)
          return _showError('Please enter your email');
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text))
          return _showError('Please enter a valid email');
        return true;
      case 3: // Password
        if (_passwordController.text.isEmpty)
          return _showError('Please enter a password');
        if (_passwordController.text.length < 6)
          return _showError('Password must be at least 6 characters');
        return true;
      default:
        return true;
    }
  }

  bool _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEB5A46), // Màu đỏ Trello
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }

  // --- LOGIC BACK-END (HTTP REQUEST) ---
  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);

    final body = {
      "username": _usernameController.text.trim(),
      "password": _passwordController.text,
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "dob": _dobController.text,
    };

    try {
      // Gọi API thực tế
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['API_KEY'] ?? '',
        },
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Color(0xFF61BD4F), // Màu xanh Trello
          ),
        );
        Navigator.pop(context); // Quay về trang Login
      } else {
        if (!mounted) return;
        _showError('Registration failed: ${response.body}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Connection error: $e');
    }
  }

  // --- UI SECTION ---
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = _isSmallScreen(context);

    return Scaffold(
      // Mobile: Nền trắng | Desktop: Nền xám
      backgroundColor: isSmallScreen ? Colors.white : const Color(0xFFF9FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: isSmallScreen ? const EdgeInsets.all(24) : EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              _buildLogoSection(),

              SizedBox(height: isSmallScreen ? 32 : 40),

              // Form Container (Responsive)
              Container(
                // Mobile: Full width | Desktop: Cố định 500px
                width: isSmallScreen ? double.infinity : 500,
                // Mobile: Padding 0 (đã có padding ngoài) | Desktop: Padding 32
                padding: isSmallScreen
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(32),

                decoration: isSmallScreen
                    ? null // Mobile: Không khung viền
                    : BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Thanh tiến trình
                    _buildProgressIndicator(),
                    const SizedBox(height: 32),

                    // Wizard Pages (Chiều cao cố định để không bị nhảy layout)
                    SizedBox(
                      height: 300,
                      child: PageView(
                        controller: _pageController,
                        physics:
                            const NeverScrollableScrollPhysics(), // Chặn vuốt tay
                        children: [
                          _buildStep1(), // Tên
                          _buildStep2(), // Ngày sinh
                          _buildStep3(), // User/Email
                          _buildStep4(), // Pass
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Navigation Buttons
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFDFE1E6),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF172B4D),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: _currentStep == 0 ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0079BF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _currentStep == 3 ? 'Register' : 'Next',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Footer Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Color(0xFF5E6C84), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFF0079BF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0079BF), Color(0xFF0067A3)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0079BF).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.dashboard_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172B4D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${_currentStep + 1} of 4',
          style: const TextStyle(fontSize: 16, color: Color(0xFF5E6C84)),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index <= _currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF0079BF)
                  : const Color(0xFFDFE1E6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  // --- STEPS WIDGETS ---

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s your name?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your first and last name',
          style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _firstNameController,
          autofocus: true,
          decoration: _buildInputDecoration('First name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: _buildInputDecoration('Last name'),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'When were you born?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your date of birth',
          style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          decoration: _buildInputDecoration(
            'Date of birth',
            suffixIcon: Icons.calendar_today,
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF0079BF),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              _dobController.text = pickedDate.toIso8601String().split('T')[0];
            }
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create your account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose a username and enter your email',
          style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _usernameController,
          decoration: _buildInputDecoration('Username'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration('Email'),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create a password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose a strong password (minimum 6 characters)',
          style: TextStyle(fontSize: 14, color: Color(0xFF5E6C84)),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _buildInputDecoration(
            'Password',
            isPassword: true,
            onTogglePassword: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 16),
        if (_passwordController.text.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _getPasswordStrengthColor(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getPasswordStrengthText(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getPasswordStrengthColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(
    String label, {
    IconData? suffixIcon,
    bool isPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF5E6C84), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFBFC),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF5E6C84),
                size: 20,
              ),
              onPressed: onTogglePassword,
            )
          : (suffixIcon != null
                ? Icon(suffixIcon, color: const Color(0xFF5E6C84), size: 20)
                : null),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFDFE1E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFDFE1E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF0079BF), width: 2),
      ),
    );
  }

  Color _getPasswordStrengthColor() {
    final length = _passwordController.text.length;
    if (length < 6) return const Color(0xFFEB5A46);
    if (length < 10) return const Color(0xFFF2D600);
    return const Color(0xFF61BD4F);
  }

  String _getPasswordStrengthText() {
    final length = _passwordController.text.length;
    if (length < 6) return 'Weak';
    if (length < 10) return 'Medium';
    return 'Strong';
  }
}
