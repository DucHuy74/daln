import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'services/auth/auth_service.dart';

// --- MOCK SERVICE (Dùng để test nếu chưa có file auth_service thật) ---
/*
class AuthService {
  Future<bool> login({required String username, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    return username.isNotEmpty && password.length >= 6;
  }
}
*/

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success = await _authService.login(
      username: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log in successful!'),
          backgroundColor: Color(0xFF61BD4F),
        ),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please check your credentials.'),
          backgroundColor: Color(0xFFEB5A46),
        ),
      );
    }
  }

  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log in with Google successful!'),
          backgroundColor: Color(0xFF61BD4F),
        ),
      );
    }
  }

  void _handleGithubLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log in with GitHub successful!'),
          backgroundColor: Color(0xFF61BD4F),
        ),
      );
    }
  }

  // --- UI RESPONSIVE ---
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = _isSmallScreen(context);

    return Scaffold(
      backgroundColor: isSmallScreen ? Colors.white : const Color(0xFFF9FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: isSmallScreen ? const EdgeInsets.all(24) : EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogoSection(),

              SizedBox(height: isSmallScreen ? 32 : 40),

              Container(
                width: isSmallScreen ? double.infinity : 400,

                padding: isSmallScreen
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(32),

                decoration: isSmallScreen
                    ? null
                    : BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                child: _buildLoginForm(),
              ),

              const SizedBox(height: 24),

              // 3. Sign Up Link & Footer
              _buildFooterSection(),
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
          'TaskFlow',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172B4D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Log in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF5E6C84),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            style: const TextStyle(fontSize: 15),
            decoration: _buildInputDecoration(
              labelText: 'Enter your email or username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email or username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(fontSize: 15),
            decoration: _buildInputDecoration(
              labelText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF5E6C84),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                      activeColor: const Color(0xFF0079BF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(color: Color(0xFF5E6C84), fontSize: 13),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Forgot password functionality'),
                    ),
                  );
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color(0xFF0079BF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0079BF),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF0079BF,
                ).withOpacity(0.6),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFDFE1E6))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: const Color(0xFF5E6C84).withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFDFE1E6))),
            ],
          ),
          const SizedBox(height: 24),

          _buildSocialButton(
            label: 'Continue with Google',
            icon: Icons.g_mobiledata,
            iconColor: const Color(0xFFDB4437),
            onTap: _handleGoogleLogin,
          ),
          const SizedBox(height: 12),
          _buildSocialButton(
            label: 'Continue with GitHub',
            icon: Icons.code,
            iconColor: const Color(0xFF24292E),
            onTap: _handleGithubLogin,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Color(0xFF5E6C84), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFFAFBFC),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFEB5A46)),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDFE1E6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF172B4D),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Color(0xFF5E6C84), fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: Color(0xFF0079BF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _buildFooterLink('Privacy Policy'),
            _buildFooterLink('Terms of Service'),
            _buildFooterLink('Help'),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5E6C84),
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
