import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_color_resources.dart';
import '../../../../core/constant/app_dimensions.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../provider/auth_provider.dart';

/// Login screen with username/password form, social login placeholders,
/// forgot password, and register links.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: ColorResources.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ----- Logo / App branding -----
                _buildHeader(),
                kGap48,
                // ----- Login form -----
                _buildForm(auth),
                kGap16,
                // ----- Forgot password -----
                _buildForgotPassword(),
                kGap24,
                // ----- Login button -----
                _buildLoginButton(auth),
                kGap32,
                // ----- Divider with "or" -----
                _buildDivider(),
                kGap24,
                // ----- Social login placeholders -----
                _buildSocialLogins(),
                kGap40,
                // ----- Register link -----
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      children: [
        // App icon placeholder — replace with actual logo asset
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: ColorResources.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          ),
          child: const Icon(
            Icons.self_improvement_rounded,
            size: 40,
            color: ColorResources.primary,
          ),
        ),
        kGap16,
        Text(
          'MindInsight',
          style: textOverLarge.copyWith(color: ColorResources.ink),
        ),
        kGap6,
        Text(
          '探索内心，洞察自我',
          style: textRegular.copyWith(color: ColorResources.muted),
        ),
      ],
    );
  }

  Widget _buildForm(AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username field
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              label: '用户名',
              hint: '请输入用户名',
              prefixIcon: Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '请输入用户名';
              }
              return null;
            },
          ),
          kGap16,
          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: _inputDecoration(
              label: '密码',
              hint: '请输入密码',
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: ColorResources.muted,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入密码';
              }
              return null;
            },
          ),
          // Error message
          if (auth.errorMessage != null) ...[
            kGap12,
            Text(
              auth.errorMessage!,
              style: textSmall.copyWith(color: ColorResources.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to forgot password screen
        },
        child: Text(
          '忘记密码？',
          style: textSmall.copyWith(color: ColorResources.primary),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResources.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ColorResources.primary.withValues(
            alpha: 0.5,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          ),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text('登录', style: textBoldLarge.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: ColorResources.border)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeMedium,
          ),
          child: Text(
            '其他登录方式',
            style: textSmall.copyWith(color: ColorResources.muted),
          ),
        ),
        const Expanded(child: Divider(color: ColorResources.border)),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // WeChat login placeholder
        _SocialButton(
          icon: Icons.chat_rounded,
          label: '微信',
          color: const Color(0xFF07C160),
          onTap: () {
            // TODO: Implement WeChat login
          },
        ),
        const SizedBox(width: 40),
        // Phone login placeholder
        _SocialButton(
          icon: Icons.phone_android_rounded,
          label: '手机号',
          color: ColorResources.teal,
          onTap: () {
            // TODO: Implement phone login
          },
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '还没有账号？',
          style: textRegular.copyWith(color: ColorResources.muted),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to register screen
          },
          child: Text(
            '立即注册',
            style: textMedium.copyWith(color: ColorResources.primary),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: textRegular.copyWith(color: ColorResources.muted),
      hintStyle: textRegular.copyWith(
        color: ColorResources.muted.withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(prefixIcon, color: ColorResources.muted, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: ColorResources.card,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeMedium,
        vertical: Dimensions.paddingSizeDefault,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        borderSide: const BorderSide(color: ColorResources.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        borderSide: const BorderSide(color: ColorResources.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        borderSide: const BorderSide(color: ColorResources.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        borderSide: const BorderSide(color: ColorResources.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        borderSide: const BorderSide(color: ColorResources.error, width: 1.5),
      ),
    );
  }
}

// =============================================================================
// Private widgets
// =============================================================================

/// Circular social login button with icon + label.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          kGap6,
          Text(label, style: textSmall.copyWith(color: ColorResources.muted)),
        ],
      ),
    );
  }
}
