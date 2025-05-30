import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'registration_complete_screen.dart';

class profile_optional_screen extends StatefulWidget {
  final user_model user_profile;

  const profile_optional_screen({
    super.key,
    required this.user_profile,
  });

  @override
  State<profile_optional_screen> createState() => _profile_optional_screen_state();
}

class _profile_optional_screen_state extends State<profile_optional_screen> {
  final _introduction_controller = TextEditingController();
  List<String> _selected_interests = [];
  File? _profile_image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _introduction_controller.dispose();
    super.dispose();
  }

  void _toggle_interest(String interest) {
    setState(() {
      if (_selected_interests.contains(interest)) {
        _selected_interests.remove(interest);
      } else {
        _selected_interests.add(interest);
      }
    });
  }

  Future<void> _pick_image() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profile_image = File(image.path);
      });
    }
  }

  Future<void> _complete_registration() async {
    final auth_provider_instance = context.read<auth_provider>();

    // TODO: 画像をFirebase Storageにアップロード
    String? profile_image_url;
    if (_profile_image != null) {
      // profile_image_url = await upload_image(_profile_image!);
    }

    final updated_profile = widget.user_profile.copy_with(
      self_introduction: _introduction_controller.text.trim().isEmpty 
          ? null 
          : _introduction_controller.text.trim(),
      profile_image_url: profile_image_url,
      interests: _selected_interests,
      updated_at: DateTime.now(),
    );

    final success = await auth_provider_instance.create_user_profile(updated_profile);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const registration_complete_screen(),
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

  Future<void> _skip() async {
    final auth_provider_instance = context.read<auth_provider>();

    final success = await auth_provider_instance.create_user_profile(widget.user_profile);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const registration_complete_screen(),
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
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // プログレスインジケーター
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: app_colors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '2/2',
                  style: app_text_styles.body2,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // タイトル
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: app_colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: app_colors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'プロフィールを充実させましょう',
                          style: app_text_styles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '（任意）',
                          style: app_text_styles.body2,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: app_colors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // プロフィール画像
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.camera_alt, size: 16, color: app_colors.text_primary),
                          const SizedBox(width: 8),
                          const Text(
                            'プロフィール画像',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: app_colors.text_primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
                            ),
                            child: _profile_image != null
                                ? ClipOval(
                                    child: Image.file(
                                      _profile_image!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                custom_button(
                                  text: '画像を選択',
                                  on_pressed: _pick_image,
                                  background_color: Colors.white,
                                  text_color: app_colors.text_primary,
                                  border_color: Colors.grey[300],
                                  height: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '個人が特定できない、お子さんの顔が映っていない画像を推奨',
                                  style: app_text_styles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 自己紹介文
                  custom_text_field(
                    controller: _introduction_controller,
                    label: '自己紹介文',
                    hint_text: '例：練馬区在住の○○です。最近引っ越してきました！○歳児のママです。公園情報交換したいです♪',
                    prefix_icon: Icons.person,
                    max_lines: 4,
                    max_length: 200,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '200文字程度まで',
                    style: app_text_styles.caption,
                  ),
                  const SizedBox(height: 24),

                  // 興味・関心
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.tag, size: 16, color: app_colors.text_primary),
                          const SizedBox(width: 8),
                          const Text(
                            '興味・関心',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: app_colors.text_primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '（複数選択可）',
                            style: app_text_styles.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: app_constants.interests.map((interest) {
                          final is_selected = _selected_interests.contains(interest);
                          return FilterChip(
                            label: Text(
                              interest,
                              style: TextStyle(
                                fontSize: 12,
                                color: is_selected ? Colors.white : app_colors.text_primary,
                              ),
                            ),
                            selected: is_selected,
                            onSelected: (_) => _toggle_interest(interest),
                            selectedColor: app_colors.primary,
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                      if (_selected_interests.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '選択中：${_selected_interests.length}個',
                          style: app_text_styles.caption,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 完了ボタン
                  Consumer<auth_provider>(
                    builder: (context, auth_provider_instance, _) {
                      return custom_button(
                        text: '登録を完了する',
                        on_pressed: _complete_registration,
                        is_loading: auth_provider_instance.is_loading,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // スキップボタン
                  Consumer<auth_provider>(
                    builder: (context, auth_provider_instance, _) {
                      return custom_button(
                        text: 'スキップする',
                        on_pressed: auth_provider_instance.is_loading ? null : _skip,
                        background_color: Colors.white,
                        text_color: app_colors.text_primary,
                        border_color: Colors.grey[300],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 注意書き
                  Text(
                    '後からプロフィールページで変更できます',
                    style: app_text_styles.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
