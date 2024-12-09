import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class RelatedPhotosController extends GetxController {
  final _state = RelatedPhotostate().obs;
  RelatedPhotostate get state => _state.value;
  set state(RelatedPhotostate n) => _state.value = n;

  void research(String query) {
    state = RelatedPhotostate();
    fetchRequest(query);
  }

  Future<void> fetchRequest(String query) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message, newlist) =
        await RemotePhotoDatasources.search(
          query,
          1,
          8,
    );
    if (!success) {
      state = state.copyWith(
        fetchStatus: FetchStatus.failed,
        message: message,
      );
      return;
    }

    state = state.copyWith(
      fetchStatus: FetchStatus.success,
      message: message,
      list: newlist,
      
    );
  }

  static delete() {
    Get.delete<RelatedPhotosController>(force: true);
  }
}

class RelatedPhotostate {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;
  final int currentPage;
  final bool hasMore; //apakah masih ada lagi datanya

  RelatedPhotostate({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
    this.currentPage = 1,
    this.hasMore = true,
  });

  RelatedPhotostate copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return RelatedPhotostate(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
