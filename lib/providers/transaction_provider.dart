import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

// Database
import './database_provider.dart';

// Models
import '../models/transaction.dart';

class TransactionProvider {
  final _tableName = 'Transactions';

  Future<List<Transaction>> getTransactions() async {
    final database = await DatabaseProvider.instance.database;
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
    );
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  Future<Transaction> getTransaction(int id) async {
    final database = await DatabaseProvider.instance.database;
    List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'Id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first);
    }
    return null;
  }

  Future<int> addTransaction(Transaction transaction) async {
    final database = await DatabaseProvider.instance.database;
    return await database.insert(
      _tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    final database = await DatabaseProvider.instance.database;
    return await database.update(
      _tableName,
      transaction.toMap(),
      where: 'Id = ?',
      whereArgs: [transaction.id],
    ) > 0;
  }

  Future<bool> deleteTransaction(int id) async {
    final database = await DatabaseProvider.instance.database;
    return await database.delete(
      _tableName,
      where: 'Id = ?',
      whereArgs: [id],
    ) > 0;
  }
}