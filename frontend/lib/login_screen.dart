import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

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
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Chuyển sang màn hình chính
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thất bại'),
          backgroundColor: Colors.red,
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
          content: Text('Đăng nhập với Google thành công!'),
          backgroundColor: Colors.green,
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
          content: Text('Đăng nhập với GitHub thành công!'),
          backgroundColor: Colors.green,
        ),
      );
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
          _buildLoginForm(true),
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
            child: _buildLoginForm(false),
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

  Widget _buildLoginForm(bool isMobile) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Đăng Nhập',
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
                "Chưa có tài khoản? ",
                style: TextStyle(color: Color(0xFF718096)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Email/Username
          const Text(
            'Username/Email',
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
                Icons.person_outline,
                color: Color(0xFF9C27B0),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF9C27B0),
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email hoặc tên đăng nhập';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mật khẩu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quên mật khẩu')),
                  );
                },
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu của bạn',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF9C27B0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF718096),
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF9C27B0),
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Remember Me
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() => _rememberMe = value ?? false);
                  },
                  activeColor: const Color(0xFF9C27B0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Ghi nhớ đăng nhập',
                style: TextStyle(color: Color(0xFF4A5568), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
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
                      'ĐĂNG NHẬP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: const [
              Expanded(child: Divider(color: Color(0xFFE2E8F0))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'hoặc đăng nhập với',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 14),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFE2E8F0))),
            ],
          ),
          const SizedBox(height: 24),

          // Social Login Buttons
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                  color: const Color(0xFFDB4437),
                  onTap: _handleGoogleLogin,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton(
                  icon: Icons.code,
                  label: 'GitHub',
                  color: const Color(0xFF333333),
                  onTap: _handleGithubLogin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: _isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w600,
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
              'Chào mừng đến với TaskFlow',
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
