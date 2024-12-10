import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/local_photo_datasource.dart';

class SavePhotoController extends GetxController {
  final _state = SavePhotoControllerState().obs;
  SavePhotoControllerState get state => _state.value;
  set state(SavePhotoControllerState n) => _state.value = n;

  Future<SavePhotoControllerState> save(PhotoModel photo) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDatasource.savePhoto(photo);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }

  Future<SavePhotoControllerState> remove(int id) async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message) = await LocalPhotoDatasource.removePhoto(id);

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
    );

    return state;
  }


  static delete() {
    Get.delete<SavePhotoController>(force: true);
  }
}

class SavePhotoControllerState {
  final FetchStatus fetchStatus;
  final String message;

  SavePhotoControllerState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
  });

  SavePhotoControllerState copyWith({
    FetchStatus? fetchStatus,
    String? message,
  }) {
    return SavePhotoControllerState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
    );
  }
}