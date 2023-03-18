import 'package:flutter/material.dart';
import 'package:flutter_binar_sqflite/page/cat_list_screen.dart';
import 'cat.dart';
import 'cat_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CatListScreen(),
    );
  }
}
