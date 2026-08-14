import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/constant/app_color_resources.dart';
import 'package:mind_insight/src/core/constant/app_dimensions.dart';
import 'package:mind_insight/src/core/constant/app_text_styles.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

/// Profile screen combining card-header (avatar + badge + stats),
/// subscription banner, and clean menu list.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                _buildTopBar(context),
                const SizedBox(height: 20),
                // Profile card (avatar + name + stats)
                _buildProfileCard(context, provider),
                const SizedBox(height: 16),
                // Subscription banner
                _buildSubscriptionBanner(context),
                const SizedBox(height: 28),
                // Menu items
                _buildMenuList(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Bar — "Profile" title + notification bell
  // ---------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: textOverLarge.copyWith(
            color: ColorResources.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorResources.card,
            border: Border.all(color: ColorResources.border),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: ColorResources.ink,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Card — Avatar ring + Name + Badge + Stats
  // ---------------------------------------------------------------------------

  Widget _buildProfileCard(BuildContext context, ProfileProvider provider) {
    final profile = provider.profile;
    final displayName = profile?.nickname ?? 'Traveler';
    final userNo = profile?.userNo ?? '';
    final avatarColor = ColorResources.getColorFromInitial(displayName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: ColorResources.card,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        border: Border.all(color: ColorResources.border),
        boxShadow: [
          BoxShadow(
            color: ColorResources.ink.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with ring
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorResources.primary.withValues(alpha: 0.6),
                  ColorResources.primary,
                  ColorResources.teal.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColor,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: profile?.avatar != null && profile!.avatar!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        profile.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, s) =>
                            _buildAvatarInitial(displayName),
                      ),
                    )
                  : _buildAvatarInitial(displayName),
            ),
          ),
          const SizedBox(height: 14),

          // Name + Premium badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textExtraLarge.copyWith(color: ColorResources.ink),
                ),
              ),
              const SizedBox(width: 8),
              // Premium badge (placeholder — toggled by subscription state)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorResources.ink,
                  borderRadius: BorderRadius.circular(
                    Dimensions.radiusCircular,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: ColorResources.gold,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Free',
                      style: textBoldSmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // User ID
          if (userNo.isNotEmpty)
            Text(
              '@$userNo',
              style: textSmall.copyWith(color: ColorResources.muted),
            ),
          const SizedBox(height: 18),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: ColorResources.surface,
              borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Readings', '—'),
                _buildStatDivider(),
                _buildStat('Streak', '0'),
                _buildStatDivider(),
                _buildStat('Days', '0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: textBoldLarge.copyWith(
            color: ColorResources.ink,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: textSmall.copyWith(color: ColorResources.muted)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 28, color: ColorResources.border);
  }

  Widget _buildAvatarInitial(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Subscription Banner
  // ---------------------------------------------------------------------------

  Widget _buildSubscriptionBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to subscription screen
        // context.push(RouteUri.subscription);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorResources.primary,
              ColorResources.primary.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: ColorResources.primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: textBold.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Unlock unlimited readings & insights',
                    style: textSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radiusCircular),
              ),
              child: Text(
                'Go Pro',
                style: textBoldSmall.copyWith(color: ColorResources.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Menu List — simple, clean rows with icon + title + chevron
  // ---------------------------------------------------------------------------

  Widget _buildMenuList(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Edit Profile',
        onTap: () => context.push(RouteUri.editProfile),
      ),
      _MenuItem(
        icon: Icons.history_rounded,
        title: 'Chat History',
        onTap: () => context.push(RouteUri.chatHistory),
      ),
      _MenuItem(
        icon: Icons.workspace_premium_outlined,
        title: 'Subscription',
        onTap: () {
          // TODO: Navigate to subscription screen
        },
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () => context.push(RouteUri.settings),
      ),
      _MenuItem(
        icon: Icons.help_outline_rounded,
        title: 'Help & Support',
        onTap: () => _showAboutSheet(context),
      ),
    ];

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return _buildMenuRow(item, showDivider: !isLast);
      }),
    );
  }

  Widget _buildMenuRow(_MenuItem item, {required bool showDivider}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
              child: Row(
                children: [
                  Icon(item.icon, color: ColorResources.ink, size: 22),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: textMedium.copyWith(color: ColorResources.ink),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ColorResources.muted.withValues(alpha: 0.5),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: ColorResources.border.withValues(alpha: 0.5),
            indent: 42,
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
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
}
