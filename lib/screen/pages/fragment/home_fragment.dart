import 'package:flutter/material.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  
  void initState() {
    RemotePhotoDatasources.fetchCurrated(1, 10);
    super.initState();
  }

  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home'),
    );
  }
}
