import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'screens/main_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

 Future main() async {
  await dotenv.load(fileName: 'credentials.env');
  runApp(ChangeNotifierProvider(
      create: (context) => CityNotifier(),
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
          colorSchemeSeed: Color.fromRGBO(135, 206, 235, 0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xdd68e0fe)
        ),
        scaffoldBackgroundColor: Color(0xffc2f2fe)
      ),
    );
  }
}

