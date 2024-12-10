import 'package:fd_log/fd_log.dart';
import 'package:get_it/get_it.dart';
import 'package:photoidea_app/data/datasources/db/database_helper.dart';
//sl = servicelocater
//di = dependency injection

GetIt sl = GetIt.instance;

initInjection() {
  FDLog fdLog = FDLog(
    bodyColorCode: 49,
    titleColorCode: 50,
    maxCharPerRow: 70,
    maxRow: 5,
    prefix: 'Ok',
  );
  sl.registerLazySingleton(() => fdLog);
  sl.registerLazySingleton(() => DatabaseHelper());
}
