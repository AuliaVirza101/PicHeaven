import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;
  Future<Database> get database async {
    _database ?? await _initDB();
    return _database!;
  }

  Future _initDB() async {
    openDatabase(
      join(await getDatabasesPath(), 'photo_idea.db'),
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE saved (
          id INTEGER PRIMARY KEY,
          src TEXT
        );
        ''');
      },
      version: 1,
    );
  }
}
