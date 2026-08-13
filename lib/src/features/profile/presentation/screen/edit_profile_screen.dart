import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/helper/toast_helper.dart';
import 'package:mind_insight/src/features/profile/business/param/profile_update_param.dart';
import 'package:mind_insight/src/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

/// Edit Profile screen — allows updating nickname and gender.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nicknameController;
  int _selectedGender = 0; // 0 = not set, 1 = male, 2 = female

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nicknameController = TextEditingController(text: profile?.nickname ?? '');
    _selectedGender = profile?.gender ?? 0;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: ColorResources.ink,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: textBoldLarge.copyWith(color: ColorResources.ink),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar section
                _buildAvatarSection(provider),
                const SizedBox(height: 36),

                // Nickname field
                _buildSectionLabel('Nickname'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nicknameController,
                  hint: 'Enter your nickname',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 28),

                // Gender selection
                _buildSectionLabel('Gender'),
                const SizedBox(height: 12),
                _buildGenderSelector(),
                const SizedBox(height: 40),

                // Save button
                _buildSaveButton(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Avatar Section
  // ---------------------------------------------------------------------------

  Widget _buildAvatarSection(ProfileProvider provider) {
    final profile = provider.profile;
    final displayName = profile?.nickname ?? 'Traveler';
    final avatarColor = ColorResources.getColorFromInitial(displayName);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [avatarColor.withValues(alpha: 0.8), avatarColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: avatarColor.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: profile?.avatar != null && profile!.avatar!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          profile.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, s) => _buildInitial(displayName),
                        ),
                      )
                    : _buildInitial(displayName),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ColorResources.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Tap to change photo',
            style: textSmall.copyWith(color: ColorResources.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Form Elements
  // ---------------------------------------------------------------------------

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: textBoldSmall.copyWith(
        color: ColorResources.muted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.card,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        border: Border.all(color: ColorResources.border),
      ),
      child: TextField(
        controller: controller,
        style: textMedium.copyWith(color: ColorResources.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: textRegular.copyWith(
            color: ColorResources.muted.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(icon, color: ColorResources.muted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _buildGenderChip(
          label: 'Male',
          icon: Icons.male_rounded,
          value: 1,
          color: const Color(0xFF5B8DEF),
        ),
        const SizedBox(width: 12),
        _buildGenderChip(
          label: 'Female',
          icon: Icons.female_rounded,
          value: 2,
          color: ColorResources.pink,
        ),
        const SizedBox(width: 12),
        _buildGenderChip(
          label: 'Other',
          icon: Icons.diversity_1_rounded,
          value: 0,
          color: ColorResources.primary,
        ),
      ],
    );
  }

  Widget _buildGenderChip({
    required String label,
    required IconData icon,
    required int value,
    required Color color,
  }) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.1)
                : ColorResources.card,
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            border: Border.all(
              color: isSelected ? color : ColorResources.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? color : ColorResources.muted,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: (isSelected ? textBoldSmall : textSmall).copyWith(
                  color: isSelected ? color : ColorResources.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Save Button
  // ---------------------------------------------------------------------------

  Widget _buildSaveButton(ProfileProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: provider.isUpdating ? null : _onSave,
        style: FilledButton.styleFrom(
          backgroundColor: ColorResources.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          ),
          disabledBackgroundColor: ColorResources.primary.withValues(
            alpha: 0.5,
          ),
        ),
        child: provider.isUpdating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save Changes',
                style: textBold.copyWith(color: Colors.white, fontSize: 15),
              ),
      ),
    );
  }

  Future<void> _onSave() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      ToastHelper.showErrorToast('Nickname cannot be empty');
      return;
    }

    final param = ProfileUpdateParam(
      nickname: nickname,
      gender: _selectedGender,
    );

    final success = await context.read<ProfileProvider>().updateProfile(param);
    if (!mounted) return;

    if (success) {
      ToastHelper.showSuccessToast('Profile updated');
      Navigator.of(context).pop();
    } else {
      final error = context.read<ProfileProvider>().errorMessage;
      ToastHelper.showErrorToast(error ?? 'Update failed');
    }
  }
}
