import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class CurratedPhotosController extends GetxController {
  final _state = CurratedPhotoState().obs;
  CurratedPhotoState get state => _state.value;
  set state(CurratedPhotoState n) => _state.value = n;

  Future<void> fetchRequest() async {
    if (!state.hasMore) return;

    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
      currentPage: state.currentPage,
    );

    final (success, message, newlist) = await RemotePhotoDatasources.fetchCurrated(
      state.currentPage,
      10,
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
      list:[...state.list,...newlist!] ,
      hasMore: newlist.isNotEmpty,
    );
    
  }

  static delete() {
    Get.delete<CurratedPhotosController>(force: true);
  }
}

class CurratedPhotoState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel> list;
  final int currentPage;
  final bool hasMore; //apakah masih ada lagi datanya

  CurratedPhotoState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list =const [],
    this.currentPage = 0,
    this.hasMore = true,
  });

  CurratedPhotoState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
    int? currentPage,
    bool? hasMore,
  }) {
    return CurratedPhotoState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
