import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/remote_photo_datasources.dart';

class CurratedPhotosController extends GetxController {
  final _state = CurratedPhotosControllerState().obs;
  CurratedPhotosControllerState get state => _state.value;
  set state(CurratedPhotosControllerState n) => _state.value = n;

  Future<void> fetchRequest() async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message, list) = await RemotePhotoDatasources.fetchCurrated(
      1,
      10
    );

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      list: list,
    );
  }

  static delete() {
    Get.delete<CurratedPhotosController>(force: true);
  }
}

class CurratedPhotosControllerState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel>? list;

  CurratedPhotosControllerState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list,
  });

  CurratedPhotosControllerState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
  }) {
    return CurratedPhotosControllerState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}