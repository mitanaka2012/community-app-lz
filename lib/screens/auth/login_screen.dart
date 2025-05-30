import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'welcome_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screen_state();
}

class _login_screen_state extends State<login_screen> {
  final _form_key = GlobalKey<FormState>();
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  bool _obscure_password = true;

  @override
  void dispose() {
    _email_controller.dispose();
    _password_controller.dispose();
    super.dispose();
  }

  Future<void> _sign_in_with_email() async {
    if (!_form_key.currentState!.validate()) return;

    final auth_provider_instance = context.read<auth_provider>();
    final success = await auth_provider_instance.sign_in_with_email_and_password(
      _email_controller.text.trim(),
      _password_controller.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth_provider_instance.error ?? 'ログインに失敗しました'),
          backgroundColor: app_colors.error,
        ),
      );
    }
  }

  Future<void> _sign_in_with_google() async {
    final auth_provider_instance = context.read<auth_provider>();
    final success = await auth_provider_instance.sign_in_with_google();

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth_provider_instance.error ?? 'Googleサインインに失敗しました'),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: app_colors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
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
        centerTitle: true,
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
                  const SizedBox(height: 40),
                  
                  // タイトル
                  const Text(
                    'ログイン',
                    style: app_text_styles.heading1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 64,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 140),
                    decoration: BoxDecoration(
                      color: app_colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '練馬区の子育てコミュニティへようこそ',
                    style: app_text_styles.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Googleサインイン
                  custom_button(
                    text: 'Googleアカウントでログイン',
                    on_pressed: auth_provider_instance.is_loading ? null : _sign_in_with_google,
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
                    label: 'メールアドレス',
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
                    label: 'パスワード',
                    hint_text: 'パスワードを入力',
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

                  // パスワードを忘れた方
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // パスワードリセット画面へ
                      },
                      child: const Text(
                        'パスワードを忘れた方',
                        style: TextStyle(color: app_colors.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ログインボタン
                  custom_button(
                    text: 'ログイン',
                    on_pressed: auth_provider_instance.is_loading ? null : _sign_in_with_email,
                    is_loading: auth_provider_instance.is_loading,
                  ),
                  const SizedBox(height: 24),

                  // 新規登録リンク
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'アカウントをお持ちでない方は',
                          style: app_text_styles.body2,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const welcome_screen(),
                              ),
                            );
                          },
                          child: const Text(
                            '新規登録',
                            style: TextStyle(
                              color: app_colors.secondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // アプリ説明
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: app_colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: app_colors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ねりまの子について',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: app_colors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '練馬区の子育て世代のためのコミュニティアプリです。地域の生きた子育て情報の交換、悩みや喜びの共有、不用品の譲渡など、安心して子育てができる環境を一緒に作りましょう。',
                          style: app_text_styles.body2.copyWith(
                            color: app_colors.primary,
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
