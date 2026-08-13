import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/helper/toast_helper.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

/// Settings screen — theme, notifications, account actions, logout.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

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
          'Settings',
          style: textBoldLarge.copyWith(color: ColorResources.ink),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General section
            _buildSectionHeader('General'),
            const SizedBox(height: 10),
            _buildCard([
              _buildToggleTile(
                icon: Icons.notifications_outlined,
                iconColor: ColorResources.amber,
                title: 'Notifications',
                subtitle: 'Daily reading reminders',
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.language_rounded,
                iconColor: ColorResources.teal,
                title: 'Language',
                trailing: 'English',
                onTap: () => _showLanguageSheet(context),
              ),
            ]),
            const SizedBox(height: 24),

            // Data & Privacy section
            _buildSectionHeader('Data & Privacy'),
            const SizedBox(height: 10),
            _buildCard([
              _buildNavTile(
                icon: Icons.delete_outline_rounded,
                iconColor: ColorResources.error,
                title: 'Clear Chat History',
                onTap: () => _confirmClearHistory(context),
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.shield_outlined,
                iconColor: ColorResources.primary,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavTile(
                icon: Icons.description_outlined,
                iconColor: ColorResources.muted,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),

            // Account section
            _buildSectionHeader('Account'),
            const SizedBox(height: 10),
            _buildCard([
              _buildNavTile(
                icon: Icons.logout_rounded,
                iconColor: ColorResources.error,
                title: 'Log Out',
                titleColor: ColorResources.error,
                onTap: () => _confirmLogout(context),
              ),
            ]),
            const SizedBox(height: 32),

            // App version
            Center(
              child: Text(
                'Mind Insight v1.0.0',
                style: textSmall.copyWith(
                  color: ColorResources.muted.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: textBoldSmall.copyWith(
          color: ColorResources.muted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card Container
  // ---------------------------------------------------------------------------

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.card,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        border: Border.all(color: ColorResources.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        height: 1,
        color: ColorResources.border.withValues(alpha: 0.6),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tile Variants
  // ---------------------------------------------------------------------------

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _buildIconBox(icon, iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: textMedium.copyWith(
                    color: titleColor ?? ColorResources.ink,
                  ),
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    trailing,
                    style: textSmall.copyWith(color: ColorResources.muted),
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                color: ColorResources.muted.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildIconBox(icon, iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textMedium.copyWith(color: ColorResources.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textSmall.copyWith(color: ColorResources.muted),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ColorResources.primary.withValues(alpha: 0.4),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ColorResources.primary;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // ---------------------------------------------------------------------------
  // Dialogs & Sheets
  // ---------------------------------------------------------------------------

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorResources.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Language',
              style: textBoldLarge.copyWith(color: ColorResources.ink),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption('English', isSelected: true),
            const SizedBox(height: 8),
            _buildLanguageOption('中文', isSelected: false),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, {required bool isSelected}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? ColorResources.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        border: Border.all(
          color: isSelected ? ColorResources.primary : ColorResources.border,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textMedium.copyWith(
              color: isSelected ? ColorResources.primary : ColorResources.ink,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(
              Icons.check_circle_rounded,
              color: ColorResources.primary,
              size: 20,
            ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        title: Text('Clear Chat History', style: textBoldLarge),
        content: Text(
          'This will permanently delete all your conversation history. This action cannot be undone.',
          style: textRegular.copyWith(color: ColorResources.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: textMedium.copyWith(color: ColorResources.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ToastHelper.showSuccessToast('Chat history cleared');
            },
            child: Text(
              'Clear',
              style: textBold.copyWith(color: ColorResources.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        ),
        title: Text('Log Out', style: textBoldLarge),
        content: Text(
          'Are you sure you want to log out?',
          style: textRegular.copyWith(color: ColorResources.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: textMedium.copyWith(color: ColorResources.muted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (!context.mounted) return;
              context.go(RouteUri.login);
            },
            child: Text(
              'Log Out',
              style: textBold.copyWith(color: ColorResources.error),
            ),
          ),
        ],
      ),
    );
  }
}
