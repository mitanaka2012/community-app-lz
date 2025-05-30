import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../home/hakken_screen.dart';

class registration_complete_screen extends StatelessWidget {
  const registration_complete_screen({super.key});

  void _go_to_home(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const hakken_screen(),
      ),
      (route) => false,
    );
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 完了アイコン
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: app_colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 48,
                color: app_colors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // タイトル
            const Text(
              '登録完了！',
              style: app_text_styles.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                color: app_colors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // ウェルカムメッセージ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: app_colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: app_colors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'ねりまの子へようこそ！',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: app_colors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '早速コミュニティに参加してみましょう。',
                    style: app_text_styles.body2.copyWith(
                      color: app_colors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 機能紹介
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'これから楽しめる機能',
                  style: app_text_styles.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _build_feature_item(
                  Icons.people,
                  'はっけん',
                  '地域の生きた子育て情報を発見',
                  app_colors.secondary,
                ),
                const SizedBox(height: 12),
                _build_feature_item(
                  Icons.help_outline,
                  'しつもん',
                  '子育ての疑問を気軽に相談',
                  app_colors.accent,
                ),
                const SizedBox(height: 12),
                _build_feature_item(
                  Icons.card_giftcard,
                  'ゆずりあい',
                  '不用品の譲渡で助け合い',
                  Colors.pink,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // コツの説明
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.yellow.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 16,
                    color: Colors.yellow[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'はじめてのコツ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'まずは「はっけん」で他の方の投稿を見てみましょう。気になる投稿には「いいね」や「ありがとう」で反応してみてくださいね。',
                          style: app_text_styles.caption.copyWith(
                            color: Colors.yellow[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ホームボタン
            custom_button(
              text: 'ホーム画面へ',
              on_pressed: () => _go_to_home(context),
              height: 56,
            ),
            const SizedBox(height: 16),

            // 安全性の説明
            Text(
              '安心・安全なコミュニティを一緒に作っていきましょう',
              style: app_text_styles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _build_feature_item(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: app_colors.text_primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: app_text_styles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
