import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import 'signup_screen.dart';

class welcome_screen extends StatefulWidget {
  const welcome_screen({super.key});

  @override
  State<welcome_screen> createState() => _welcome_screen_state();
}

class _welcome_screen_state extends State<welcome_screen> {
  bool _agreed_to_terms = false;
  bool _agreed_to_privacy = false;

  bool get _can_proceed => _agreed_to_terms && _agreed_to_privacy;

  void _handle_start() {
    if (_can_proceed) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const signup_screen(),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            // タイトル
            const Text(
              'ねりまの子へようこそ！',
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
            const SizedBox(height: 32),

            // アプリ説明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: app_colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: app_colors.primary.withOpacity(0.3)),
              ),
              child: Text(
                '練馬区の子育て世代のためのコミュニティアプリです。\n'
                '子どもたちがのびのびと成長するのを楽しく見守れるように、'
                '新しく親になる方が不安にならないように、'
                '地域の皆さんと情報交換や助け合いをしましょう。',
                style: app_text_styles.body1.copyWith(
                  color: app_colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 機能紹介
            Column(
              children: [
                _build_feature_item(
                  Icons.people,
                  '地域の生きた子育て情報の交換',
                  app_colors.secondary,
                ),
                const SizedBox(height: 12),
                _build_feature_item(
                  Icons.favorite,
                  '子育ての悩みや喜びの共有',
                  Colors.pink,
                ),
                const SizedBox(height: 12),
                _build_feature_item(
                  Icons.card_giftcard,
                  '不用品の譲渡・助け合い',
                  app_colors.accent,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 同意チェックボックス
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _agreed_to_terms,
                    onChanged: (value) {
                      setState(() {
                        _agreed_to_terms = value ?? false;
                      });
                    },
                    title: const Text(
                      '利用規約に同意する',
                      style: TextStyle(fontSize: 14),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: app_colors.primary,
                  ),
                  CheckboxListTile(
                    value: _agreed_to_privacy,
                    onChanged: (value) {
                      setState(() {
                        _agreed_to_privacy = value ?? false;
                      });
                    },
                    title: const Text(
                      'プライバシーポリシーに同意する',
                      style: TextStyle(fontSize: 14),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: app_colors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 開始ボタン
            custom_button(
              text: '始める',
              on_pressed: _can_proceed ? _handle_start : null,
            ),
            const SizedBox(height: 16),

            // 安全性の説明
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield,
                  size: 16,
                  color: app_colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '安心・安全なコミュニティを目指しています',
                  style: app_text_styles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _build_feature_item(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: app_text_styles.body2,
            ),
          ),
        ],
      ),
    );
  }
}
