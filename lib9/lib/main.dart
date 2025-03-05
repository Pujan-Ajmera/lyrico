import 'package:flutter/material.dart';
import 'package:lyrico_main/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Color themeColor = await getSavedThemeColor();
  runApp(MyApp(themeColor: themeColor));
}

Future<Color> getSavedThemeColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int colorValue = prefs.getInt('themeColor') ?? Colors.lightGreen.value;
  return Color(colorValue);
}

class MyApp extends StatelessWidget {
  final Color themeColor;
  const MyApp({super.key, required this.themeColor});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
