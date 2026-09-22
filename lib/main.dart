import 'package:flutter/material.dart';

void main() {
  runApp(const CatDirectoryApp());
}

class CatDirectoryApp extends StatelessWidget {
  const CatDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NekoDex',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('NekoDex'))),
    );
  }
}
