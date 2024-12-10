import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/screen/controller/saved_controller.dart';
import 'package:photoidea_app/screen/pages/detail_photo_page.dart';

class SavedFragment extends StatefulWidget {
  const SavedFragment({super.key});

  @override
  State<SavedFragment> createState() => _SavedFragmentState();
}

class _SavedFragmentState extends State<SavedFragment> {
  final savedController = Get.put(SavedController());

  void gotoDetail(PhotoModel photo) {
    Navigator.pushNamed(
      context, DetailPhotoPage.routeName,
      arguments: photo.id);
  }


  @override
  void initState() {
    savedController.fetchRequest();
    super.initState();
  }

  @override
  void dispose() {
    SavedController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(MediaQuery.paddingOf(context).top + 10),
        buildTitle(),
        const Gap(20),
        Expanded(
          child: buildGridPhotos(),
        ),
      ],
    );
  }

  Widget buildGridPhotos() {
    return Obx(() {
      final state = savedController.state;
      if (state.fetchStatus == FetchStatus.init) {
        return SizedBox();
      }
      if (state.fetchStatus == FetchStatus.loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state.fetchStatus == FetchStatus.failed) {
        return Center(
          child: Text(state.message),
        );
      }
      List<PhotoModel> list = state.list ?? [];
      if (list.isEmpty) {
        return const Center(
          child: Text('You havent saved any image'),
        );
      }
      return GridView.builder(
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = list[index];
            return buildPhotoItem(item);
          });
    });
  }

  Widget buildPhotoItem(PhotoModel photo) {
    return GestureDetector(
      onTap: () => gotoDetail,
      child: ExtendedImage.network(
        photo.source?.medium ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bookmark',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Your Saved Image',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.black38,
            ),
          )
        ],
      ),
    );
  }
}
