import 'package:d_input/d_input.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/common/app_constants.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';
import 'package:photoidea_app/screen/controller/currated_photos_controller.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  final queryController = TextEditingController();
  final curratedPhotosController = Get.put(CurratedPhotosController());
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
    curratedPhotosController.fetchRequest();
    super.initState();
  }

  void dispose() {
    CurratedPhotosController.delete();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildHeader(),
          buildCategories(),
          buildCurrated(),
        ],
      ),
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
      height: 80,
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

  Widget buildCurrated() {
    return Obx(() {
      final state = curratedPhotosController.state;
      if (state.fetchStatus == FetchStatus.init) {
        return const SizedBox();
      }
      final list = state.list ?? [];

      return GridView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1,
        ),
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final item = list[index];
          return buildPhotoItem(item);
        },
      );
    });
  }

  Widget buildPhotoItem(PhotoModel photo) {
    return ExtendedImage.network(
      photo.source?.medium ?? '',
      fit: BoxFit.cover,
    );
  }
}
