import 'package:flutter/material.dart';
import 'package:photoidea_app/screen/pages/fragment/dashboard_pages.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const DashboardPage()
      },
    );
  }
}
