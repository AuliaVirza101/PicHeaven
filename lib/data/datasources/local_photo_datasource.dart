import 'package:photoidea_app/core/di.dart';
import 'package:photoidea_app/data/datasources/db/database_helper.dart';
import 'package:photoidea_app/data/datasources/db/models/photo_model.dart';

class LocalPhotoDatasource {
  static Future<(bool, String, List<PhotoModel>?)> fetchAll() async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final list = await database.query('saved');
      final photos = list.map((e) => PhotoModel.fromJsonSaved(e)).toList();
      return (true, 'fetch Succes', photos);
    } catch (e) {
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, bool?)> checkIsSaved(int id) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final list = await database.query(
        'saved',
        where: 'id=?',
        whereArgs: [id],
      );
      return (true, 'Checked', list.isNotEmpty);
    } catch (e) {
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> savePhoto(PhotoModel photo) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final rowAffected = await database.insert('saved', photo.toJsonSaved(),);
      if (rowAffected != 0) {
        return (true, 'Image Saved');
      }
      return (false, 'Image not saved');
    } catch (e) {
      return (false, 'Something went wrong');
    }

  }

  static Future<(bool, String)> removePhoto(int id) async {
    try {
      final database = await sl<DatabaseHelper>().database;
      final rowAffected = await database.delete(
        'saved',
         where: 'id=?',
         whereArgs: [id]);
      if (rowAffected != 0) {
        return (true, 'Image Removed');
      }
      return (false, 'Failed to remove');
    } catch (e) {
      return (false, 'Something went wrong');
    }

  }

  
}
