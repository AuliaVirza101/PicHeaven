import 'package:fd_log/fd_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/core/di.dart';
import 'package:photoidea_app/screen/pages/fragment/home_fragment.dart';
import 'package:photoidea_app/screen/pages/fragment/saved_fragment.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final indexFragment = RxInt(0);
  final menuBottomNavbar = [Icons.home, Icons.bookmark];

  @override
  void initState() {
    sl<FDLog>().title('title', 'body');
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: indexFragment.value,
          children:  [
            HomeFragment(),
            SavedFragment(),
          ],
        );
      }),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: buildButtomNav(),
    );
  }

  Widget buildButtomNav() {
    final primaryColor = Theme.of(context).primaryColor;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3), blurRadius: 5, color: Colors.black26)
            ]),
        child: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(menuBottomNavbar.length, (index) {
              final isActive = indexFragment == index;
              return RawMaterialButton(
                onPressed: () {
                  indexFragment.value = index;
                },
                elevation: isActive ? 8 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints.tightFor(
                  height: 54,
                  width: 54,
                ),
                fillColor: isActive ? primaryColor : Colors.white,
                child: Icon(
                  menuBottomNavbar[index],
                  color:
                      isActive ? Colors.white : primaryColor.withOpacity(0.5),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
