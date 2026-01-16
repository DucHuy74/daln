import 'package:flutter/material.dart';
import '../../services/home/invite_to_project_service.dart';
import '../../models/home/workspace_model.dart';

class InviteViewModel extends ChangeNotifier {
  final InvitationService _service = InvitationService();

  final List<String> _invitedMembers = [];
  WorkspaceRole _selectedRole = WorkspaceRole.MEMBER;
  bool _isLoading = false;
  String? _errorMessage;

  List<String> get invitedMembers => _invitedMembers;
  WorkspaceRole get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void addMember(String email) {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return;

    if (!_isValidEmail(cleanEmail)) {
      _errorMessage = "Invalid email format: $cleanEmail";
      notifyListeners();
      return;
    }

    if (!_invitedMembers.any((e) => e.toLowerCase() == cleanEmail.toLowerCase())) {
      _invitedMembers.add(cleanEmail);
      _errorMessage = null;
      notifyListeners();
    } else {
      _errorMessage = "Email already added";
      notifyListeners();
    }
  }

  void removeMember(String email) {
    _invitedMembers.remove(email);
    notifyListeners();
  }

  void setRole(WorkspaceRole? role) {
    if (role != null) {
      _selectedRole = role;
      notifyListeners();
    }
  }

  Future<bool> submitInvitations(String workspaceId, {String? currentInputEmail}) async {
    if (currentInputEmail != null && currentInputEmail.trim().isNotEmpty) {
      addMember(currentInputEmail.trim());
      if (_errorMessage != null && _errorMessage!.contains("Invalid")) {
        return false;
      }
    }

    if (_invitedMembers.isEmpty) {
      _errorMessage = "Please add at least one valid email";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.sendInvites(
        workspaceId, 
        _invitedMembers, 
        _selectedRole
      );

      if (success) {
        _invitedMembers.clear();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Some invitations failed. Please try again.";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}