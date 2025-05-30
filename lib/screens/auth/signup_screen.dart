import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'profile_required_screen.dart';

class signup_screen extends StatefulWidget {
  const signup_screen({super.key});

  @override
  State<signup_screen> createState() => _signup_screen_state();
}

class _signup_screen_state extends State<signup_screen> {
  final _form_key = GlobalKey<FormState>();
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  final _confirm_password_controller = TextEditingController();
  bool _obscure_password = true;

  @override
  void dispose() {
    _email_controller.dispose();
    _password_controller.dispose();
    _confirm_password_controller.dispose();
    super.dispose();
  }

  bool get _is_valid_email => _email_controller.text.contains('@') && _email_controller.text.contains('.');
  bool get _is_valid_password => _password_controller.text.length >= 8;
  bool get _passwords_match => _password_controller.text == _confirm_password_controller.text && _confirm_password_controller.text.isNotEmpty;
  bool get _can_submit => _is_valid_email && _is_valid_password && _passwords_match;

  Future<void> _handle_signup() async {
    if (!_form_key.currentState!.validate() || !_can_submit) return;

    final auth_provider_instance = context.read<auth_provider>();
    final success = await auth_provider_instance.sign_up_with_email_and_password(
      _email_controller.text.trim(),
      _password_controller.text,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const profile_required_screen(),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth_provider_instance.error ?? '登録に失敗しました'),
          backgroundColor: app_colors.error,
        ),
      );
    }
  }

  Future<void> _sign_up_with_google() async {
    final auth_provider_instance = context.read<auth_provider>();
    final success = await auth_provider_instance.sign_in_with_google();

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const profile_required_screen(),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth_provider_instance.error ?? 'Googleサインアップに失敗しました'),
          backgroundColor: app_colors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: app_colors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ねりまの子',
              style: TextStyle(
                color: app_colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Consumer<auth_provider>(
        builder: (context, auth_provider_instance, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form_key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // タイトル
                  const Text(
                    'アカウントを作成',
                    style: app_text_styles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 150),
                    decoration: BoxDecoration(
                      color: app_colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Googleサインアップ
                  custom_button(
                    text: 'Googleアカウントで登録（推奨）',
                    on_pressed: auth_provider_instance.is_loading ? null : _sign_up_with_google,
                    background_color: Colors.white,
                    text_color: Colors.black87,
                    border_color: Colors.grey[300],
                    icon: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/google_logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 区切り線
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'または',
                          style: app_text_styles.body2,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // メールアドレス
                  custom_text_field(
                    controller: _email_controller,
                    label: 'メールアドレス *',
                    hint_text: 'example@email.com',
                    keyboard_type: TextInputType.emailAddress,
                    prefix_icon: Icons.mail_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'メールアドレスを入力してください';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return '正しいメールアドレスを入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // パスワード
                  custom_text_field(
                    controller: _password_controller,
                    label: 'パスワード *',
                    hint_text: '8文字以上',
                    obscure_text: _obscure_password,
                    prefix_icon: Icons.lock_outline,
                    suffix_icon: IconButton(
                      icon: Icon(
                        _obscure_password ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure_password = !_obscure_password;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードを入力してください';
                      }
                      if (value.length < 8) {
                        return 'パスワードは8文字以上で入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '8文字以上、半角英数字記号の組み合わせを推奨',
                    style: app_text_styles.caption,
                  ),
                  const SizedBox(height: 16),

                  // パスワード確認
                  custom_text_field(
                    controller: _confirm_password_controller,
                    label: 'パスワード（再入力） *',
                    hint_text: 'パスワードを再入力',
                    obscure_text: _obscure_password,
                    prefix_icon: Icons.lock_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードを再入力してください';
                      }
                      if (value != _password_controller.text) {
                        return 'パスワードが一致しません';
                      }
                      return null;
                    },
                  ),
                  if (_confirm_password_controller.text.isNotEmpty && !_passwords_match) ...[
                    const SizedBox(height: 8),
                    Text(
                      'パスワードが一致しません',
                      style: app_text_styles.caption.copyWith(color: app_colors.error),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // 登録ボタン
                  custom_button(
                    text: '登録する',
                    on_pressed: _can_submit ? _handle_signup : null,
                    is_loading: auth_provider_instance.is_loading,
                  ),
                  const SizedBox(height: 24),

                  // ログインリンク
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'すでにアカウントをお持ちの方は',
                          style: app_text_styles.body2,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'ログイン',
                            style: TextStyle(
                              color: app_colors.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
