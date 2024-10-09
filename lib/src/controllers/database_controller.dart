import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  static final Future<Database> _database = Future(() async {
    return openDatabase(
      join(await getDatabasesPath(), 'holidays.db'),
      version: 1,
      onCreate: (db, version) async {
        return db.execute(
            'CREATE TABLE holidays(id TEXT PRIMARY KEY, name TEXT NOT NULL, start TEXT NOT NULL, end TEXT, zone TEXT, public INT)');
      },
    );
  });

  static Future<Database> get database => _database;
}
