import 'package:get/get.dart';
import 'package:photoidea_app/common/enums.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';
import 'package:photoidea_app/data/datasources/local_photo_datasource.dart';

class SavedController extends GetxController {
  final _state = SavedControllerState().obs;
  SavedControllerState get state => _state.value;
  set state(SavedControllerState n) => _state.value = n;

  Future<void> fetchRequest() async {
    state = state.copyWith(
      fetchStatus: FetchStatus.loading,
    );

    final (success, message, list) = await LocalPhotoDatasource.fetchAll();

    state = state.copyWith(
      fetchStatus: success ? FetchStatus.success : FetchStatus.failed,
      message: message,
      list: list,
    );
  }

  static delete() {
    Get.delete<SavedController>(force: true);
  }
}

class SavedControllerState {
  final FetchStatus fetchStatus;
  final String message;
  final List<PhotoModel>? list;

  SavedControllerState({
    this.fetchStatus = FetchStatus.init,
    this.message = '',
    this.list,
  });

  SavedControllerState copyWith({
    FetchStatus? fetchStatus,
    String? message,
    List<PhotoModel>? list,
  }) {
    return SavedControllerState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      message: message ?? this.message,
      list: list ?? this.list,
    );
  }
}