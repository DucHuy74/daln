import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/home/workspace_model.dart';
import '../../viewmodels/home/invite_to_project_view_model.dart';
import 'home_page.dart';

class InviteToProjectPage extends StatelessWidget {
  final String workspaceId;

  const InviteToProjectPage({Key? key, required this.workspaceId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InviteViewModel(),
      child: _InviteView(workspaceId: workspaceId),
    );
  }
}

class _InviteView extends StatefulWidget {
  final String workspaceId;

  const _InviteView({Key? key, required this.workspaceId}) : super(key: key);

  @override
  State<_InviteView> createState() => _InviteViewState();
}

class _InviteViewState extends State<_InviteView> {
  final _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isInputFocused = false;

  // Jira Colors
  static const primaryColor = Color(0xFF0052CC);
  static const textDark = Color(0xFF172B4D);
  static const textGrey = Color(0xFF5E6C84);
  static const borderGrey = Color(0xFFDFE1E6);
  static const errorColor = Color(0xFFDE350B);

  final List<Map<String, dynamic>> _roleDescriptions = [
    {
      'role': WorkspaceRole.ADMIN,
      'title': 'Administrator',
      'description': 'Admins can manage settings, users, and billing.',
    },
    {
      'role': WorkspaceRole.MEMBER,
      'title': 'Member',
      'description': 'Members can create and edit issues in the project.',
    },
    {
      'role': WorkspaceRole.VIEWER,
      'title': 'Viewer',
      'description': 'Viewers can only search and view issues.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _isInputFocused = _emailFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  String _getRoleDescription(WorkspaceRole selectedRole) {
    return _roleDescriptions.firstWhere(
      (e) => e['role'] == selectedRole,
      orElse: () => {'description': ''},
    )['description'];
  }

  // Hàm xử lý khi user nhấn submit text field
  void _onFieldSubmitted(String value, InviteViewModel viewModel) {
    if (value.trim().isNotEmpty) {
      viewModel.addMember(value.trim());
      // Chỉ clear text nếu không có lỗi validate
      if (viewModel.errorMessage == null ||
          !viewModel.errorMessage!.contains("Invalid")) {
        _emailController.clear();
      }
      _emailFocusNode.requestFocus(); // Giữ focus để nhập tiếp
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dùng context.watch để rebuild khi state thay đổi
    final viewModel = context.watch<InviteViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back to project setup',
          style: TextStyle(color: textGrey, fontSize: 15),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bring your team along',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Collaborate instantly with your team on projects.',
                    style: TextStyle(fontSize: 16, color: textGrey),
                  ),
                  const SizedBox(height: 32),

                  // --- INPUT EMAIL ---
                  const Text(
                    'Email addresses',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            viewModel.errorMessage != null &&
                                viewModel.errorMessage!.contains("Invalid")
                            ? errorColor
                            : (_isInputFocused ? primaryColor : borderGrey),
                        width: _isInputFocused ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viewModel.invitedMembers.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8, // Thêm khoảng cách dòng
                            children: viewModel.invitedMembers
                                .map(
                                  (email) => InputChip(
                                    avatar: CircleAvatar(
                                      backgroundColor: primaryColor.withOpacity(
                                        0.2,
                                      ),
                                      child: Text(
                                        email[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    label: Text(email),
                                    onDeleted: () =>
                                        viewModel.removeMember(email),
                                    backgroundColor: const Color(0xFFEBECF0),
                                    deleteIconColor: textGrey,
                                  ),
                                )
                                .toList(),
                          ),

                        TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'e.g., name@company.com',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onSubmitted: (val) =>
                              _onFieldSubmitted(val, viewModel),
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),

                  // Hiển thị lỗi ngay dưới ô input nếu có
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: errorColor, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 24),

                  const Text(
                    'Role',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderGrey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<WorkspaceRole>(
                        value: viewModel.selectedRole,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: textGrey,
                        ),
                        items: _roleDescriptions
                            .map(
                              (item) => DropdownMenuItem<WorkspaceRole>(
                                value: item['role'] as WorkspaceRole,
                                child: Text(
                                  item['title'] as String,
                                  style: const TextStyle(color: textDark),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: viewModel.setRole,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEEBFF).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getRoleDescription(viewModel.selectedRole),
                            style: const TextStyle(
                              color: Color(0xFF0049B0),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomePage(),
                            ),
                            (Route<dynamic> route) =>
                                false,
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: textGrey),
                        child: const Text('Skip for now'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                final currentText = _emailController.text;

                                bool success = await viewModel
                                    .submitInvitations(
                                      widget.workspaceId,
                                      currentInputEmail: currentText,
                                    );

                                if (!context.mounted) return;

                                if (success) {
                                  _emailController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Invites sent successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Invite and continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
