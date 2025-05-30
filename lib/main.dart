import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/posts_provider.dart';
import 'providers/questions_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/hakken_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const my_app());
}

class my_app extends StatelessWidget {
  const my_app({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => auth_provider()),
        ChangeNotifierProvider(create: (_) => posts_provider()),
        ChangeNotifierProvider(create: (_) => questions_provider()),
      ],
      child: MaterialApp(
        title: 'ねりまの子',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: app_colors.primary,
          fontFamily: 'NotoSansJP',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
        ),
        home: Consumer<auth_provider>(
          builder: (context, auth_provider_instance, _) {
            if (auth_provider_instance.is_loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (auth_provider_instance.user != null) {
              return const hakken_screen();
            }
            
            return const login_screen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
