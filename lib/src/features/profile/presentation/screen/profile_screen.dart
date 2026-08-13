import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

/// Main Profile / "Me" screen with modern card-based layout.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Column(
              children: [
                _buildProfileHeader(context, provider),
                const SizedBox(height: 32),
                _buildMenuSection(
                  context,
                  title: 'Account',
                  items: [
                    _MenuItem(
                      icon: Icons.edit_outlined,
                      iconColor: ColorResources.primary,
                      title: 'Edit Profile',
                      subtitle: 'Update your name and avatar',
                      onTap: () => context.push(RouteUri.editProfile),
                    ),
                    _MenuItem(
                      icon: Icons.history_rounded,
                      iconColor: ColorResources.teal,
                      title: 'Chat History',
                      subtitle: 'View previous conversations',
                      onTap: () => context.push(RouteUri.chatHistory),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildMenuSection(
                  context,
                  title: 'Preferences',
                  items: [
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      iconColor: ColorResources.amber,
                      title: 'Settings',
                      subtitle: 'Theme, language, and more',
                      onTap: () => context.push(RouteUri.settings),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      iconColor: ColorResources.pink,
                      title: 'About',
                      subtitle: 'Version and credits',
                      onTap: () => _showAboutSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Header — Avatar + Name + ID
  // ---------------------------------------------------------------------------

  Widget _buildProfileHeader(BuildContext context, ProfileProvider provider) {
    final profile = provider.profile;
    final displayName = profile?.nickname ?? 'Traveler';
    final userNo = profile?.userNo ?? '';
    final avatarColor = ColorResources.getColorFromInitial(displayName);

    return Column(
      children: [
        // Avatar
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [avatarColor.withValues(alpha: 0.8), avatarColor],
            ),
            boxShadow: [
              BoxShadow(
                color: avatarColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: profile?.avatar != null && profile!.avatar!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    profile.avatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => _buildAvatarInitial(displayName),
                  ),
                )
              : _buildAvatarInitial(displayName),
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          displayName,
          style: textOverLarge.copyWith(color: ColorResources.ink),
        ),
        const SizedBox(height: 4),
        // User ID
        if (userNo.isNotEmpty)
          Text(
            'ID: $userNo',
            style: textSmall.copyWith(color: ColorResources.muted),
          ),
        const SizedBox(height: 16),
        // Edit button chip
        GestureDetector(
          onTap: () => context.push(RouteUri.editProfile),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ColorResources.primarySoft,
              borderRadius: BorderRadius.circular(Dimensions.radiusCircular),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 14, color: ColorResources.primary),
                const SizedBox(width: 6),
                Text(
                  'Edit Profile',
                  style: textBoldSmall.copyWith(color: ColorResources.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarInitial(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Menu Section
  // ---------------------------------------------------------------------------

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: textBoldSmall.copyWith(
              color: ColorResources.muted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorResources.card,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(color: ColorResources.border),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return _buildMenuTile(context, item, showDivider: !isLast);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    _MenuItem item, {
    required bool showDivider,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item.onTap,
            borderRadius: showDivider
                ? null
                : const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: textMedium.copyWith(color: ColorResources.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: textSmall.copyWith(
                            color: ColorResources.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chevron
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ColorResources.muted.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Divider(
              height: 1,
              color: ColorResources.border.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // About Bottom Sheet
  // ---------------------------------------------------------------------------

  void _showAboutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
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
            const SizedBox(height: 24),
            Icon(Icons.auto_awesome, size: 40, color: ColorResources.primary),
            const SizedBox(height: 12),
            Text(
              'Mind Insight',
              style: textExtraLarge.copyWith(color: ColorResources.ink),
            ),
            const SizedBox(height: 6),
            Text(
              'Version 1.0.0',
              style: textSmall.copyWith(color: ColorResources.muted),
            ),
            const SizedBox(height: 16),
            Text(
              'Your personal tarot companion for daily insights and self-reflection.',
              textAlign: TextAlign.center,
              style: textRegular.copyWith(color: ColorResources.muted),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Menu item model
// =============================================================================

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
