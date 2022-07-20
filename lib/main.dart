import 'package:flutter/material.dart';

import 'package:zenesus/screens/login.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenesus',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      darkTheme:ThemeData.dark(),
      home: const MyLoginPage(),
    );
  }
}


