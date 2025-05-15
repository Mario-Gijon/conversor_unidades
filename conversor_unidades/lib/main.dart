import 'package:flutter/material.dart';
import 'package:conversor_unidades/screens/home_screen.dart';
import 'package:conversor_unidades/config/theme.dart';

void main() {
  runApp(const ConversorApp());
}

class ConversorApp extends StatefulWidget {
  const ConversorApp({Key? key}) : super(key: key);

  @override
  _ConversorAppState createState() => _ConversorAppState();
}

class _ConversorAppState extends State<ConversorApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Unidades',
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: HomeScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}
