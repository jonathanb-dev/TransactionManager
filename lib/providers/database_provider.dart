import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseProvider {
  static final _databaseName = 'TransactionManager.db';
  static final _databaseVersion = 1;

  static final DatabaseProvider instance = DatabaseProvider._();
  static Database _database;

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
      documentsDirectory.path,
      _databaseName,
    );
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    _updateDatabase(database, _databaseVersion);
    print('Database created');
  }

  Future<void> _onUpgrade(Database database, int oldVersion, int newVersion) async {
    _updateDatabase(database, _databaseVersion);
    print('Database upgraded');
  }

  Future<void> _updateDatabase(Database database, int currentVersion) async {
    if (currentVersion == 1) {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS Transactions (
          Id INTEGER PRIMARY KEY,
          Name TEXT NOT NULL,
          Description TEXT NULL,
          Amount DOUBLE NOT NULL,
          DateAndTime TEXT NOT NULL
        )'''
      );
    }
  }
}