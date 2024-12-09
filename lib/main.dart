import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photoidea_app/core/di.dart';
import 'package:photoidea_app/screen/pages/dashboard_pages.dart';
import 'package:photoidea_app/screen/pages/detail_photo_page.dart';
import 'package:photoidea_app/screen/pages/search_photo_page.dart';

void main() {
  initInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routes: {
        '/': (context) => const DashboardPage(),
        SearchPhotoPage.routename: (context) {
          final query = ModalRoute.of(context)?.settings.arguments as String;
          return SearchPhotoPage(query: query);
        },
        DetailPhotoPage.routeName: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as int;
          return DetailPhotoPage(id: id);
        }
      },
    );
  }
}
