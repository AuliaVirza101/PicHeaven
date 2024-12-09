import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class DetailPhotoController extends GetxController {
  final _state = DetailPhotoControllerState().obs;
  DetailPhotoControllerState get state => _state.value;
  set state(DetailPhotoControllerState n) => _state.value = n;

  Future<PhotoModel?> fetchRequest(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message, data) = await RemotePhotoDatasources.fetchByid(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      data: data,
    );

    return data;
  }

  static delete() {
    Get.delete<DetailPhotoController>(force: true);
  }
}

class DetailPhotoControllerState {
  final FetchStatus fetchStatus;
  final String message;
  final PhotoModel? data;

  DetailPhotoControllerState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.data,
  });

  DetailPhotoControllerState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    PhotoModel? data,
  }) {
    return DetailPhotoControllerState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
