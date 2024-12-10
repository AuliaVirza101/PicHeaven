import 'package:d_info/d_info.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/screen/controller/detail_photo_controller.dart';
import 'package:photoidea_app/screen/controller/is_saved_controller.dart';
import 'package:photoidea_app/screen/controller/related_photo_controller.dart';
import 'package:photoidea_app/screen/controller/save_photo_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPhotoPage extends StatefulWidget {
  const DetailPhotoPage({super.key, required this.id});
  final int id;

  static const routeName = '/photo/detail';

  @override
  State<DetailPhotoPage> createState() => _DetailPhotoPageState();
}

class _DetailPhotoPageState extends State<DetailPhotoPage> {
  final detailPhotoController = Get.put(DetailPhotoController());
  final relatedPhotosController = Get.put(RelatedPhotosController());
  final isSavedController = Get.put(IsSavedController());
  final savePhotoController = Get.put(SavePhotoController());

  void openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      DInfo.toastError('could not launch URL');
    }
  }

  void fetchDetail() {
    detailPhotoController.fetchRequest(widget.id).then((photo) {
      if (photo == null) return;
      fetchRelated(photo.alt ?? '');
    });
  }

  void fetchRelated(String query) {
    relatedPhotosController.fetchRequest(query);
  }

  void checkIsSaved() {
    isSavedController.executeRequest(widget.id);
  }

  void saveOrUnsave(bool isSaved, PhotoModel photo) async {
    SavePhotoControllerState state = isSaved
     ? await savePhotoController.remove(widget.id)
     : await savePhotoController.save(photo);

    if (state.fetchStatus == FetchStatus.failed) {
      DInfo.toastError(state.message);
      return;
    }
    if (state.fetchStatus == FetchStatus.success) {
      checkIsSaved();
      DInfo.toastError(state.message);
      return;
    }
  }

  @override
  void initState() {
    fetchDetail();
    checkIsSaved();
    super.initState();
  }

  @override
  void dispose() {
    DetailPhotoController.delete();
    RelatedPhotosController.delete();
    IsSavedController.delete();
    SavePhotoController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final state = detailPhotoController.state;

        if (state.fetchStatus == FetchStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.fetchStatus == FetchStatus.failed) {
          return const Center(child: CircularProgressIndicator());
        }
        final photo = state.data!;

        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  buildImage(photo.source?.large2X ?? ''),
                  Positioned(
                    top: 60,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        buildBackButton(),
                        const Spacer(),
                        buildPreview(photo.source?.original ?? ''),
                        buildSavedButton(photo),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 16,
                      bottom: 16,
                      child: buildOpenOnPexels(photo.url ?? ''))
                ],
              ),
            ),
            const Gap(20),
            buildDescription(photo.alt ?? ''),
            buildPhotographer(
                photo.photographer ?? '', photo.photographerUrl ?? ''),
            const Gap(10),
            buildRelated(),
          ],
        );
      }),
    );
  }

  Widget buildImage(String imageUrl) {
    return ExtendedImage.network(
      imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget buildBackButton() {
    return BackButton(
        color: Colors.white,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Colors.black38,
          ),
        ));
  }

  Widget buildPreview(String imageUrl) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Stack(
                    children: [
                      Positioned.fill(
                          child: InteractiveViewer(
                              child: ExtendedImage.network(imageUrl))),
                      const Align(
                        alignment: Alignment.topCenter,
                        child: CloseButton(
                          color: Colors.white,
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.black45)),
                        ),
                      ),
                    ],
                  ));
        },
        color: Colors.white,
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black38)),
        icon: const Icon(Icons.visibility));
  }

  Widget buildSavedButton(PhotoModel photo) {
    return Obx(() {
      final isSaved = isSavedController.state.status;
      return IconButton(
          onPressed: () => saveOrUnsave(isSaved,photo),
          color: Colors.white,
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black38)),
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border));
    });
  }

  Widget buildOpenOnPexels(String url) {
    return GestureDetector(
      onTap: () => openUrl(url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black38,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: const Text(
          'Open on Pexels',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        description == '' ? 'no description' : description,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildPhotographer(String name, String url) {
    return ListTile(
      leading: Icon(Icons.account_circle, color: Colors.grey, size: 48),
      horizontalTitleGap: 10,
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: GestureDetector(
        onTap: () => openUrl(url),
        child: const Text(
          'See Profile on Pexels',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            decoration: TextDecoration.underline,
            decorationThickness: 0.5,
          ),
        ),
      ),
    );
  }

  Widget buildRelated() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'More like this',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Gap(12),
        Obx(() {
          final state = relatedPhotosController.state;
          if (state.fetchStatus == FetchStatus.init) {
            return const SizedBox();
          }
          if (state.fetchStatus == FetchStatus.loading) {
            return Center(child: Text(state.message));
          }
          if (state.fetchStatus == FetchStatus.failed) {
            return Center(child: Text('No related images'));
          }
          final list = state.list;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(right: 16),
              itemBuilder: (context, index) {
                final photo = list[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 16 : 8),
                  child: buildRelatedItem(photo),
                );
              },
            ),
          );
        })
      ],
    );
  }

  Widget buildRelatedItem(PhotoModel photo) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExtendedImage.network(
          photo.source?.medium ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
