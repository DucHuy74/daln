import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _isMobile(context) ? _buildDrawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(context),
                _buildCompaniesSection(context),
                _buildFeaturesSection(context),
                _buildTestimonialsSection(context),
                _buildCTASection(context),
                _buildFooter(context),
              ],
            ),
          ),
          _buildNavBar(context),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.dashboard, color: Color(0xFF3B82F6)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'TaskFlow',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Tính năng'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Giá cả'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Đánh giá'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Đăng nhập'),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Dùng thử miễn phí',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final isMobile = _isMobile(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled ? Colors.white : Colors.transparent,
        boxShadow: _isScrolled
            ? [const BoxShadow(color: Colors.black12, blurRadius: 10)]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: 12,
          ),
          child: Row(
            children: [
              if (isMobile)
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dashboard, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                'TaskFlow',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (!isMobile) ...[
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Tính năng')),
                TextButton(onPressed: () {}, child: const Text('Giá cả')),
                TextButton(onPressed: () {}, child: const Text('Đăng nhập')),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Dùng thử miễn phí',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEFF6FF), Colors.white, Color(0xFFFAF5FF)],
        ),
      ),
      padding: EdgeInsets.only(
        top: isMobile ? 80 : 120,
        bottom: isMobile ? 40 : 80,
        left: isMobile ? 16 : 20,
        right: isMobile ? 16 : 20,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCEEFE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, size: 16, color: Color(0xFF1D4ED8)),
                const SizedBox(width: 8),
                Text(
                  'Tăng năng suất lên 40% với AI',
                  style: TextStyle(
                    color: const Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 24 : 40),
          Column(
            children: [
              Text(
                'Ghi lại, sắp xếp và',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 32 : 56,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                  height: 1.1,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF9333EA),
                    Color(0xFFEC4899),
                  ],
                ).createShader(bounds),
                child: Text(
                  'hoàn thành mọi việc',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            'Công cụ quản lý công việc mạnh mẽ giúp bạn và đội ngũ làm việc hiệu quả hơn. Miễn phí mãi mãi cho cá nhân.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 40),
          if (isMobile)
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email của bạn',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Bắt đầu ngay',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email của bạn',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Bắt đầu ngay',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Text(
            'Không cần thẻ tín dụng • Miễn phí mãi mãi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: isMobile ? 40 : 60),
          if (!isMobile) _buildDashboardPreview(context),
        ],
      ),
    );
  }

  Widget _buildDashboardPreview(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildColumn('Việc cần làm', Colors.blue, 3),
          const SizedBox(width: 16),
          _buildColumn('Đang làm', Colors.orange, 2),
          const SizedBox(width: 16),
          _buildColumn('Hoàn thành', Colors.green, 4),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, Color color, int cardCount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(cardCount, (index) => _buildCard(color)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Color borderColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Task',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue.shade200,
                child: const Text('A', style: TextStyle(fontSize: 8)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.calendar_today, size: 10, color: Color(0xFF9CA3AF)),
              SizedBox(width: 4),
              Text(
                'Hôm nay',
                style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompaniesSection(BuildContext context) {
    final companies = ['Visa', 'Coinbase', 'Zoom', 'Fender', 'Hyatt', 'Deere'];
    final isMobile = _isMobile(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 48,
        horizontal: 16,
      ),
      child: Column(
        children: [
          Text(
            'ĐƯỢC TIN DÙNG BỞI 2 TRIỆU ĐỘI NGŨ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 32),
          Wrap(
            spacing: isMobile ? 20 : 40,
            runSpacing: isMobile ? 16 : 20,
            alignment: WrapAlignment.center,
            children: companies
                .map(
                  (company) => Text(
                    company,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.dashboard,
        'title': 'Bảng trực quan',
        'desc': 'Tổ chức công việc linh hoạt với bảng và thẻ',
      },
      {
        'icon': Icons.people,
        'title': 'Cộng tác nhóm',
        'desc': 'Làm việc hiệu quả với chia sẻ và theo dõi',
      },
      {
        'icon': Icons.bolt,
        'title': 'Tự động hóa',
        'desc': 'Tiết kiệm thời gian không cần code',
      },
      {
        'icon': Icons.calendar_month,
        'title': 'Lập kế hoạch',
        'desc': 'Quản lý thời gian một cách hiệu quả',
      },
    ];

    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 80),
      child: Column(
        children: [
          Text(
            'Mọi thứ bạn cần để thành công',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 48,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Công cụ mạnh mẽ cho làm việc thông minh',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: isMobile ? 32 : 64),
          if (isMobile)
            Column(
              children: features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildFeatureCard(
                        feature['icon'] as IconData,
                        feature['title'] as String,
                        feature['desc'] as String,
                        true,
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Wrap(
              spacing: 32,
              runSpacing: 32,
              alignment: WrapAlignment.center,
              children: features
                  .map(
                    (feature) => SizedBox(
                      width: isTablet ? 300 : 280,
                      child: _buildFeatureCard(
                        feature['icon'] as IconData,
                        feature['title'] as String,
                        feature['desc'] as String,
                        false,
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 56 : 64,
            height: isMobile ? 56 : 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: isMobile ? 28 : 32),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
        ),
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 80),
      child: Column(
        children: [
          Text(
            'Khách hàng nói gì',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 32 : 64),
          if (isMobile)
            Column(
              children: [
                _buildTestimonialCard(
                  'TaskFlow đã thay đổi cách chúng tôi làm việc. Mọi thứ rõ ràng và có tổ chức.',
                  'Hoàng Minh Quân',
                  'CEO, Tech Startup',
                  true,
                ),
                const SizedBox(height: 16),
                _buildTestimonialCard(
                  'Công cụ tuyệt vời. Đội ngũ tăng năng suất 40%.',
                  'Hoàng Lê Đức Huy',
                  'Project Manager',
                  true,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTestimonialCard(
                    'TaskFlow đã thay đổi hoàn toàn cách chúng tôi làm việc. Mọi thứ giờ đây đều rõ ràng và có tổ chức.',
                    'Hoàng Minh Quân',
                    'CEO, Tech Startup',
                    false,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildTestimonialCard(
                    'Công cụ tuyệt vời cho quản lý dự án. Đội ngũ của chúng tôi đã tăng năng suất 40%.',
                    'Hoàng Lê Đức Huy',
                    'Project Manager',
                    false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(
    String quote,
    String author,
    String position,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: Colors.amber,
                size: isMobile ? 16 : 20,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            '"$quote"',
            style: TextStyle(
              fontSize: isMobile ? 15 : 18,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            author,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            position,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 32 : 80),
      child: Column(
        children: [
          Text(
            'Sẵn sàng bắt đầu chưa?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Tham gia hàng triệu người dùng',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 32 : 48,
                  vertical: isMobile ? 16 : 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dùng thử miễn phí ngay',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Không cần thẻ tín dụng • Hủy bất cứ lúc nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      color: const Color(0xFF111827),
      padding: EdgeInsets.all(isMobile ? 24 : 48),
      child: Column(
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'TaskFlow',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Công cụ quản lý công việc thông minh',
                  style: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 32),
                ...['Sản phẩm', 'Công ty', 'Tài nguyên']
                    .map(
                      (section) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            section,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(
                            4,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Link ${i + 1}',
                                style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.dashboard,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'TaskFlow',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Công cụ quản lý công việc thông minh',
                        style: TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                ...['Sản phẩm', 'Công ty', 'Tài nguyên'].map(
                  (section) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          4,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Link ${i + 1}',
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: isMobile ? 32 : 48),
          const Divider(color: Color(0xFF374151)),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            '© 2025 TaskFlow. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
