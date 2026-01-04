import 'package:flutter/material.dart';
import '../../components/auth/auth_button.dart';
import 'invite_to_project.dart';

class CreateProjectPage extends StatefulWidget {
  // THÊM: Nhận template từ màn hình trước
  final Map<String, dynamic> selectedTemplate;

  const CreateProjectPage({
    Key? key,
    required this.selectedTemplate, // Bắt buộc phải truyền vào
  }) : super(key: key);

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _nameController = TextEditingController();
  String _selectedManagement = 'Team-managed';
  String _selectedAccess = 'Open';
  // Không cần biến _selectedTemplate nữa vì đã lấy từ widget.selectedTemplate

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF172B4D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to project templates',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF5E6C84),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 80,
            vertical: 40,
          ),
          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildForm(),
        const SizedBox(height: 40),
        SizedBox(height: 500, child: _buildPreview()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildForm()),
        const SizedBox(width: 60),
        Expanded(flex: 6, child: SizedBox(height: 600, child: _buildPreview())),
      ],
    );
  }

  Widget _buildForm() {
    // Lấy thông tin template từ widget
    final template = widget.selectedTemplate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create project',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 32),

        // Name Field
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF172B4D),
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(text: 'Name '),
              TextSpan(
                text: '*',
                style: TextStyle(color: Color(0xFFDE350B)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          onChanged: (val) {
            // Rebuild để cập nhật preview tên dự án real-time
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Try a team name, project goal, milestone...',
            hintStyle: const TextStyle(color: Color(0xFF5E6C84)),
            filled: true,
            fillColor: const Color(0xFFFAFBFC),
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
              borderSide: const BorderSide(color: Color(0xFF0052CC), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // How your space is managed
        const Text(
          'How your space is managed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedManagement,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFBFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFDFE1E6)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF5E6C84)),
          items: ['Team-managed', 'Company-managed'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  const Icon(
                    Icons.groups_outlined,
                    size: 18,
                    color: Color(0xFF5E6C84),
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) =>
              setState(() => _selectedManagement = newValue!),
        ),
        const SizedBox(height: 24),

        // Access
        const Text(
          'Access',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedAccess,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFBFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFDFE1E6)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items: ['Open', 'Private', 'Limited'].map((String value) {
            IconData icon;
            if (value == 'Open') {
              icon = Icons.lock_open;
            } else if (value == 'Private') {
              icon = Icons.lock_outline;
            } else {
              icon = Icons.people_outline;
            }
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: const Color(0xFF5E6C84)),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) =>
              setState(() => _selectedAccess = newValue!),
        ),
        const SizedBox(height: 24),

        // Template Info Section (Dynamic Data)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Template',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
            TextButton(
              onPressed: () {
                // Logic quay lại chọn template khác
                Navigator.pop(context);
              },
              child: const Text(
                'Change template',
                style: TextStyle(color: Color(0xFF0052CC), fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Selected Template Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFC),
            border: Border.all(color: const Color(0xFFDFE1E6)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [template['color1'], template['color2']],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(template['icon'], color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template['description'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5E6C84),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Action Buttons
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF5E6C84),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AuthButton(
              label: 'Next',
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a project name'),
                      backgroundColor: Color(0xFFDE350B),
                    ),
                  );
                  return;
                }
                // Navigate to invite page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InviteToProjectPage(
                      projectName: _nameController.text,
                      selectedTemplate: widget.selectedTemplate,
                      selectedManagement: _selectedManagement,
                      selectedAccess: _selectedAccess,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreview() {
    final template = widget.selectedTemplate;
    // Hiển thị tên dự án đang nhập, nếu trống thì hiện "Untitled space"
    final projectName = _nameController.text.trim().isEmpty
        ? 'Untitled space'
        : _nameController.text;

    return Stack(
      children: [
        // Blue circle decoration (Màu nhạt theo template)
        Positioned(
          top: -100,
          right: -200,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              color: template['color1'].withOpacity(0.1), // Dynamic color
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Board preview card
        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: template['color1'], // Dynamic color
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        template['icon'], // Dynamic icon
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      projectName, // Dynamic name
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons mock
                Row(
                  children: [
                    _buildMockButton(),
                    const SizedBox(width: 8),
                    _buildMockButton(),
                    const SizedBox(width: 8),
                    _buildMockButton(),
                    const SizedBox(width: 8),
                    _buildMockButton(),
                  ],
                ),
                const SizedBox(height: 20),

                // Kanban columns preview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildKanbanColumn([1, 2], template['color1']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKanbanColumn([3, 4], template['color1']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKanbanColumn([5], template['color1']),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Footer
                Text(
                  '$_selectedManagement space',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5E6C84),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMockButton() {
    return Container(
      width: 60,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFEBECF0),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildKanbanColumn(List<int> cards, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header cột có màu theo template
          Container(
            width: double.infinity,
            height: 6,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          ...cards.map(
            (num) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildKanbanCard('KEY-$num'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(String key) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFEBECF0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFDFE1E6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
