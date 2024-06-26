import 'package:alumnet/features/auth/screens/on_boarding/on_boarding_screen.dart';
import 'package:alumnet/features/auth/screens/on_boarding/onboarding_page.dart';
import 'package:alumnet/features/auth/screens/splash_screen/splash_screen.dart';
import 'package:alumnet/features/auth/screens/welcome/welcome.dart';
import 'package:alumnet/home.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/repository/auth_repo/auth_repo.dart';
import 'package:alumnet/models/feed_post.dart';
import 'package:alumnet/screens/home/create_post_screen.dart';
import 'package:alumnet/screens/search_screen.dart';
import 'package:alumnet/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepo()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostList()),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
      ],
      child: SafeArea(
        child: GetMaterialApp(
          title: 'Alumnet',
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: SplashScreen(),
          routes: {
            
            PostCreationScreen.routename: (context) => PostCreationScreen()
          ,
            SearchPage.routename: (context) => SearchPage(),
          },
        ),
      ),
    );
  }
}
