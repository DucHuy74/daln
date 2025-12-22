import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final body = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "email": _emailController.text,
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "dob": _dobController.text,
      };

      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['API_KEY']!,
        },
        body: jsonEncode(body),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9C27B0), Color(0xFFAB47BC), Color(0xFFBA68C8)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildIllustration(true),
          const SizedBox(height: 32),
          _buildRegisterForm(true),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: _buildRegisterForm(false),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE1BEE7), Color(0xFFCE93D8)],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: _buildIllustration(false),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool isMobile) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Register',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: Color(0xFF718096)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Username
          const Text(
            'Username',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter your username',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter username';
              if (value.length < 3)
                return 'Username must be at least 3 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password
          const Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF9C27B0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF718096),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter password';
              if (value.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Email
          const Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                return 'Please enter valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // First Name
          const Text(
            'First Name',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              hintText: 'Enter your first name',
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please enter first name'
                : null,
          ),
          const SizedBox(height: 20),

          // Last Name
          const Text(
            'Last Name',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              hintText: 'Enter your last name',
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please enter last name'
                : null,
          ),
          const SizedBox(height: 20),

          // Date of Birth
          const Text(
            'Date of Birth',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dobController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Select date of birth',
              prefixIcon: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _dobController.text = pickedDate.toIso8601String().split(
                  'T',
                )[0];
              }
            },
            validator: (value) => (value == null || value.isEmpty)
                ? 'Please select date of birth'
                : null,
          ),
          const SizedBox(height: 24),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isMobile) const SizedBox(height: 60),
          Container(
            width: isMobile ? 250 : 400,
            height: isMobile ? 200 : 350,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Desk
                Positioned(
                  bottom: 80,
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Computer Monitor
                Positioned(
                  top: isMobile ? 30 : 60,
                  left: isMobile ? 60 : 100,
                  child: Container(
                    width: isMobile ? 130 : 200,
                    height: isMobile ? 90 : 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF9C27B0),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.laptop_mac,
                        size: isMobile ? 40 : 60,
                        color: const Color(0xFF9C27B0),
                      ),
                    ),
                  ),
                ),

                // Person Sitting
                Positioned(
                  bottom: 20,
                  left: isMobile ? 20 : 40,
                  child: Container(
                    width: isMobile ? 60 : 100,
                    height: isMobile ? 80 : 130,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7B1FA2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),

                // Books
                Positioned(
                  bottom: 88,
                  right: isMobile ? 40 : 80,
                  child: Row(
                    children: [
                      _buildBook(Colors.green, isMobile),
                      const SizedBox(width: 4),
                      _buildBook(Colors.blue, isMobile),
                      const SizedBox(width: 4),
                      _buildBook(Colors.orange, isMobile),
                    ],
                  ),
                ),

                // Coffee Cup
                Positioned(
                  bottom: 90,
                  left: isMobile ? 160 : 260,
                  child: Container(
                    width: isMobile ? 20 : 30,
                    height: isMobile ? 25 : 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Notification Icons
                Positioned(
                  top: isMobile ? 20 : 30,
                  right: isMobile ? 20 : 40,
                  child: Column(
                    children: [
                      _buildNotificationIcon(
                        Colors.red,
                        Icons.favorite,
                        isMobile,
                      ),
                      SizedBox(height: isMobile ? 6 : 10),
                      _buildNotificationIcon(
                        Colors.orange,
                        Icons.notifications,
                        isMobile,
                      ),
                      SizedBox(height: isMobile ? 6 : 10),
                      _buildNotificationIcon(
                        Colors.green,
                        Icons.check_circle,
                        isMobile,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) const SizedBox(height: 40),
          if (!isMobile)
            const Text(
              'Tạo tài khoản mới!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7B1FA2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBook(Color color, bool isMobile) {
    return Container(
      width: isMobile ? 12 : 20,
      height: isMobile ? 40 : 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildNotificationIcon(Color color, IconData icon, bool isMobile) {
    return Container(
      width: isMobile ? 24 : 36,
      height: isMobile ? 24 : 36,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: isMobile ? 14 : 20),
    );
  }
}
