import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'profile_optional_screen.dart';

class profile_required_screen extends StatefulWidget {
  const profile_required_screen({super.key});

  @override
  State<profile_required_screen> createState() => _profile_required_screen_state();
}

class _profile_required_screen_state extends State<profile_required_screen> {
  final _form_key = GlobalKey<FormState>();
  final _nickname_controller = TextEditingController();
  final _postal_code_controller = TextEditingController();
  String _has_children = '';
  List<String> _children_ages = [];
  DateTime? _due_date;

  @override
  void dispose() {
    _nickname_controller.dispose();
    _postal_code_controller.dispose();
    super.dispose();
  }

  bool get _is_valid_nickname => _nickname_controller.text.length >= 2 && _nickname_controller.text.length <= 15;
  bool get _is_valid_postal_code {
    final postal_code = _postal_code_controller.text;
    return postal_code.length == 7 && 
           RegExp(r'^[0-9]{7}$').hasMatch(postal_code) &&
           (postal_code.startsWith('176') || 
            postal_code.startsWith('177') || 
            postal_code.startsWith('178') || 
            postal_code.startsWith('179'));
  }
  bool get _has_valid_children_info {
    return _has_children == 'no-children' ||
           _has_children == 'ended' ||
           (_has_children == 'has-children' && _children_ages.isNotEmpty);
  }
  bool get _can_proceed => _is_valid_nickname && _is_valid_postal_code && _has_children.isNotEmpty && _has_valid_children_info;

  void _handle_children_age_change(String age, bool checked) {
    setState(() {
      if (checked) {
        _children_ages.add(age);
      } else {
        _children_ages.remove(age);
      }
    });
  }

  Future<void> _handle_next() async {
    if (!_form_key.currentState!.validate() || !_can_proceed) return;

    final auth_provider_instance = context.read<auth_provider>();
    if (auth_provider_instance.user == null) return;

    final user_profile = user_model(
      uid: auth_provider_instance.user!.uid,
      nickname: _nickname_controller.text.trim(),
      postal_code: _postal_code_controller.text,
      has_children: _has_children == 'has-children',
      is_aspiring_parent: _has_children == 'no-children',
      is_community_contributor: _has_children == 'ended',
      child_age_ranges: _children_ages,
      due_date: _due_date,
      self_introduction: null,
      profile_image_url: null,
      interests: [],
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => profile_optional_screen(user_profile: user_profile),
      ),
    );
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
                      color: app_colors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: app_colors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '1/2',
                  style: app_text_styles.body2,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _form_key,
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
                            'プロフィールを設定しましょう',
                            style: app_text_styles.heading2,
                            textAlign: TextAlign.center,
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

                    // ニックネーム
                    custom_text_field(
                      controller: _nickname_controller,
                      label: 'ニックネーム *',
                      hint_text: '例：ねりまママ',
                      prefix_icon: Icons.person,
                      max_length: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ニックネームを入力してください';
                        }
                        if (value.length < 2) {
                          return '2文字以上入力してください';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2〜15文字（ひらがな、カタカナ、漢字、半角英数字）',
                      style: app_text_styles.caption,
                    ),
                    if (_nickname_controller.text.isNotEmpty && !_is_valid_nickname) ...[
                      const SizedBox(height: 4),
                      Text(
                        '2文字以上15文字以下で入力してください',
                        style: app_text_styles.caption.copyWith(color: app_colors.error),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '公序良俗に反するニックネームはご遠慮ください',
                      style: app_text_styles.caption.copyWith(color: app_colors.accent),
                    ),
                    const SizedBox(height: 24),

                    // 郵便番号
                    custom_text_field(
                      controller: _postal_code_controller,
                      label: '練馬区の郵便番号 *',
                      hint_text: '1760001',
                      prefix_icon: Icons.location_on,
                      keyboard_type: TextInputType.number,
                      max_length: 7,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '郵便番号を入力してください';
                        }
                        if (!_is_valid_postal_code) {
                          return '練馬区の郵便番号を入力してください';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '半角数字7桁（例：1760001）',
                      style: app_text_styles.caption,
                    ),
                    if (_postal_code_controller.text.length == 7 && !_is_valid_postal_code) ...[
                      const SizedBox(height: 4),
                      Text(
                        '練馬区の郵便番号を入力してください（176-179で始まる番号）',
                        style: app_text_styles.caption.copyWith(color: app_colors.error),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'これを練馬区在住の簡易確認とさせていただきます',
                      style: app_text_styles.caption.copyWith(color: app_colors.secondary),
                    ),
                    const SizedBox(height: 24),

                    // お子さんの有無
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.child_care, size: 16, color: app_colors.text_primary),
                            const SizedBox(width: 8),
                            const Text(
                              'お子さんの有無 *',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: app_colors.text_primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            RadioListTile<String>(
                              value: 'has-children',
                              groupValue: _has_children,
                              onChanged: (value) {
                                setState(() {
                                  _has_children = value ?? '';
                                  if (value != 'has-children') {
                                    _children_ages.clear();
                                  }
                                });
                              },
                              title: const Text('子どもがいます', style: TextStyle(fontSize: 14)),
                              activeColor: app_colors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              value: 'no-children',
                              groupValue: _has_children,
                              onChanged: (value) {
                                setState(() {
                                  _has_children = value ?? '';
                                  _children_ages.clear();
                                });
                              },
                              title: const Text('子どもが欲しいと考えています', style: TextStyle(fontSize: 14)),
                              activeColor: app_colors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                            RadioListTile<String>(
                              value: 'ended',
                              groupValue: _has_children,
                              onChanged: (value) {
                                setState(() {
                                  _has_children = value ?? '';
                                  _children_ages.clear();
                                });
                              },
                              title: const Text('子育ては終えましたが、地域に貢献したい', style: TextStyle(fontSize: 14)),
                              activeColor: app_colors.primary,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // 子どもの年齢層（条件付き表示）
                    if (_has_children == 'has-children') ...[
                      const SizedBox(height: 24),
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
                              'お子さんの年齢層 *',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: app_colors.text_primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '（複数選択可）',
                              style: app_text_styles.caption,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: app_constants.child_age_ranges.map((age) {
                                final is_selected = _children_ages.contains(age);
                                return FilterChip(
                                  label: Text(
                                    age,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: is_selected ? Colors.white : app_colors.text_primary,
                                    ),
                                  ),
                                  selected: is_selected,
                                  onSelected: (selected) => _handle_children_age_change(age, selected),
                                  selectedColor: app_colors.primary,
                                  checkmarkColor: Colors.white,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 出産予定日（条件付き表示）
                    if (_has_children == 'no-children') ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: app_colors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: app_colors.secondary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '出産予定日（任意）',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: app_colors.text_primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _due_date ?? DateTime.now().add(const Duration(days: 180)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() {
                                    _due_date = date;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      _due_date != null 
                                          ? '${_due_date!.year}年${_due_date!.month}月${_due_date!.day}日'
                                          : '出産予定日を選択',
                                      style: TextStyle(
                                        color: _due_date != null ? app_colors.text_primary : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // 次へボタン
                    custom_button(
                      text: '次へ',
                      on_pressed: _can_proceed ? _handle_next : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
