import 'package:d_input/d_input.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/screen/controller/search_photo_controller.dart';
import 'package:gap/gap.dart';
import 'package:photoidea_app/screen/pages/detail_photo_page.dart';

class SearchPhotoPage extends StatefulWidget {
  const SearchPhotoPage({super.key, required this.query});
  final String query;

  static const routename = '/searchPage';
  @override
  State<SearchPhotoPage> createState() => _SearchPhotoPageState();
}

class _SearchPhotoPageState extends State<SearchPhotoPage> {
  final queryController = TextEditingController();
  final searchPhotosController = Get.put(SearchPhotosController());
  final scrollController = ScrollController();

  final showUpButton = RxBool(false);

  void startSearch() {
    final query = queryController.text;
    if (query == '') return; 
    
    searchPhotosController.research(query);
    
  }

  void gotoUpPage() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
    showUpButton.value = false;
  }

  void gotoDetail(PhotoModel photo) {
    Navigator.pushNamed(
      context, DetailPhotoPage.routeName,
      arguments: photo.id);
  }

  @override
  void initState() {
    final widgetQuery = widget.query;
    if (widgetQuery != '') {
      queryController.text = widgetQuery;
      startSearch();
    }
    scrollController.addListener(() {
      bool reachMax =
          scrollController.offset == scrollController.position.maxScrollExtent;
      if (reachMax) {
        final query = queryController.text;
        if (query == '') return;
        searchPhotosController.fetchRequest(query);
      }

      bool passMaxHeight =
          scrollController.offset > MediaQuery.sizeOf(context).height;
      if (passMaxHeight) {
        showUpButton.value = passMaxHeight;
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    SearchPhotosController.delete();
    scrollController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildSearch(),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: buildUpwardButton(),
      body: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(0),
            children: [
              Gap(10),
              buildSearchPhoto(),
              buildLoadingOrFailed(),
              const Gap(20),
            ],
          ),
    );
  }

  Widget buildSearch() {
    return DInputMix(
      controller: queryController,
      hint: 'Search images...',
      boxColor: Colors.white,
      inputPadding: const EdgeInsets.all(4),
      prefixIcon: IconSpec(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
        boxSize: const Size(45, 45),
      ),
      suffixIcon: IconSpec(
        icon: Icons.search,
        onTap: startSearch,
        boxSize: const Size(45, 45),
      ),
    );
  }


  
  Widget buildSearchPhoto() {
    return Obx(() {
      final state = searchPhotosController.state;
      if (state.fetchStatus == FetchStatus.init) {
        return const SizedBox();
      }
      final list = state.list;

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
    return GestureDetector(
      onTap: () => gotoDetail(photo),
      child: ExtendedImage.network(
        photo.source?.medium ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildLoadingOrFailed() {
    return Obx(() {
      final state = searchPhotosController.state;
      if (state.fetchStatus == FetchStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state.fetchStatus == FetchStatus.failed) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(state.message),
          ),
        );
      }
      if (state.fetchStatus == FetchStatus.success && !state.hasMore) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text('No more photos'),
          ),
        );
      }
      ;
      return SizedBox(
        height: 5,
      );
    });
  }

  Widget buildUpwardButton() {
    return Obx(() {
      if (showUpButton.value) {
        return FloatingActionButton.small(
          heroTag: 'icon_scroll_upward',
          onPressed: gotoUpPage,
          child: const Icon(Icons.arrow_upward),
        );
      }
      return const SizedBox();
    });
  }

}
