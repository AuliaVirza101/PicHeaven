import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/screen/controller/detail_photo_controller.dart';

class DetailPhotoPage extends StatefulWidget {
  const DetailPhotoPage({super.key, required this.id});
  final int id;

  static const routeName = '/photo/detail';

  @override
  State<DetailPhotoPage> createState() => _DetailPhotoPageState();
}

class _DetailPhotoPageState extends State<DetailPhotoPage> {
  final detailPhotoController = Get.put(DetailPhotoController());

  void openUrl(String url) {}

  void fetchDetail() {
    detailPhotoController.fetchRequest(widget.id);
  }

  @override
  void initState() {
    fetchDetail();
    super.initState();
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
                        buildSavedButton(),
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
                photo.photographer ?? '', photo.photographerUrl ?? '')
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
                      backgroundColor: WidgetStatePropertyAll(Colors.black45)
                    ),
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

  Widget buildSavedButton() {
    return IconButton(
        onPressed: () {},
        color: Colors.white,
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black38)),
        icon: const Icon(Icons.bookmark_border));
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
}
