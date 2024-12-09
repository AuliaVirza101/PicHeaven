import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class SearchPhotosController extends GetxController {
  final _state = SearchPhotostate().obs;
  SearchPhotostate get state => _state.value;
  set state(SearchPhotostate n) => _state.value = n;

  void research(String query) {
    state = SearchPhotostate();
    fetchRequest(query);
  }

  Future<void> fetchRequest(String query) async {
    if (!state.hasMore) return;

    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
      currentPage: state.currentPage,
    );

    final (success, message, newlist) =
        await RemotePhotoDatasources.search(
          query,
          state.currentPage,
          20,
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
      list: [...state.list, ...newlist!],
      hasMore: newlist.isNotEmpty,
    );
  }

  static delete() {
    Get.delete<SearchPhotosController>(force: true);
  }
}

class SearchPhotostate {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;
  final int currentPage;
  final bool hasMore; //apakah masih ada lagi datanya

  SearchPhotostate({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list = const [],
    this.currentPage = 0,
    this.hasMore = true,
  });

  SearchPhotostate copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return SearchPhotostate(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
