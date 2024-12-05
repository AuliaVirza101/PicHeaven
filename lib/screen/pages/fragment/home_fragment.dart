import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:photoidea_app/common/app_constants.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  final queryController = TextEditingController();

  //manual karena tidak ada api untuk categories biar cantik saja :')
  final categories = [
    'happy',
    'people',
    'trip',
    'sea',
    'friends',
    'sky',
    'business',
    'nature'
  ];

  void gotoSearch() {}

  void initState() {
    RemotePhotoDatasources.fetchCurrated(1, 10);
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        buildHeader(),
      ],
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        Image.asset(
          AppConstants.homeHeaderImage,
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.6,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
        ),
        Positioned.fill(
          child: ColoredBox(color: Colors.black38),
        ),
        Positioned(
          left: 30,
          right: 30,
          top: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Something Cool',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Explore your imagination \nget your image',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              buildSearch(),
            ],
          ),
        )
      ],
    );
  }

  Widget buildSearch() {
    return DInputMix(
      controller: queryController,
      hint: 'Search image here...',
      inputOnFieldSubmitted: (value) => gotoSearch,
      hintStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.white54,
      ),
      inputStyle:
          const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
      boxColor: Colors.transparent,
      boxBorder: Border.all(
        color: Colors.white70,
      ),
      suffixIcon: IconSpec(
        icon: Icons.search,
        color: Colors.white70,
        onTap: gotoSearch,
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 16),
        itemBuilder: (context, index) {
          final item = categories[index];
          return Padding(
            padding: EdgeInsets.only(right: 16),
            child: ActionChip(
                onPressed: () {},
                label: Text(item),
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                      color: Colors.grey.shade400,
                    ))),
          );
        },
      ),
    );
  }
}
