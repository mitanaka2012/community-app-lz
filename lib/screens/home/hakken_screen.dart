import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/posts_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/post/post_card.dart';
import '../post/hakken_post_screen.dart';
import 'shitsumon_screen.dart';
import 'messages_screen.dart';
import 'mypage_screen.dart';

class hakken_screen extends StatefulWidget {
  const hakken_screen({super.key});

  @override
  State<hakken_screen> createState() => _hakken_screen_state();
}

class _hakken_screen_state extends State<hakken_screen> {
  int _current_index = 0;
  
  final List<Widget> _screens = [
    const hakken_tab(),
    const shitsumon_screen(),
    const messages_screen(),
    const mypage_screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _current_index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _current_index,
        onTap: (index) {
          setState(() {
            _current_index = index;
          });
        },
        selectedItemColor: app_colors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'はっけん',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'しつもん',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'メッセージ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
        ],
      ),
    );
  }
}

class hakken_tab extends StatefulWidget {
  const hakken_tab({super.key});

  @override
  State<hakken_tab> createState() => _hakken_tab_state();
}

class _hakken_tab_state extends State<hakken_tab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<posts_provider>().load_posts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      appBar: AppBar(
        title: Row(
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
              'はっけん',
              style: TextStyle(
                color: app_colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 検索機能
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // フィルター機能
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Consumer<posts_provider>(
        builder: (context, posts_provider_instance, _) {
          return Column(
            children: [
              // カテゴリフィルター
              Container(
                height: 60,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: ['すべて', ...app_constants.categories].length,
                  itemBuilder: (context, index) {
                    final categories = ['すべて', ...app_constants.categories];
                    final category = categories[index];
                    final is_selected = posts_provider_instance.selected_category == category;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: is_selected,
                        onSelected: (_) {
                          posts_provider_instance.set_selected_category(category);
                        },
                        selectedColor: app_colors.primary.withOpacity(0.2),
                        checkmarkColor: app_colors.primary,
                      ),
                    );
                  },
                ),
              ),
              
              // 投稿リスト
              Expanded(
                child: posts_provider_instance.is_loading
                    ? const Center(child: CircularProgressIndicator())
                    : posts_provider_instance.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(posts_provider_instance.error!),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => posts_provider_instance.load_posts(),
                                  child: const Text('再試行'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => posts_provider_instance.load_posts(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: posts_provider_instance.filtered_posts.length,
                              itemBuilder: (context, index) {
                                final post = posts_provider_instance.filtered_posts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: post_card(post: post),
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const hakken_post_screen(),
            ),
          );
        },
        backgroundColor: app_colors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
