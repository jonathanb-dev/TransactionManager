import 'package:flutter/foundation.dart';

// Providers
import '../providers/transaction_provider.dart';

// Models
import './transaction.dart';

class Transactions extends ChangeNotifier {
  List<Transaction> _transactions = []; // Initial state

  Transactions();

  List<Transaction> get transactions {
    List<Transaction> transactions = [..._transactions];
    transactions.sort((a,b) => b.dateAndTime.compareTo(a.dateAndTime));
    return transactions;
  }

  List<Transaction> get gains {
    return _transactions.where((transaction) => transaction.amount > 0.0).toList();
  }

  List<Transaction> get losses {
    return _transactions.where((transaction) => transaction.amount < 0.0).toList();
  }

  double get totalGain {
    double total = 0.0;
    gains.forEach((transaction) => total += transaction.amount);
    return total;
  }

  double get totalLoss {
    double total = 0.0;
    losses.forEach((transaction) => total += transaction.amount);
    return total;
  }

  Future<void> fetchAndSetTransactions() async {
    _transactions = await TransactionProvider().getTransactions();
  }

  Transaction getTransactionById(int id) {
    return _transactions.firstWhere((transaction) => transaction.id == id);
  }

  void addTransaction(Transaction transaction) {
    TransactionProvider().addTransaction(transaction).then((transactionId) {
      transaction.id = transactionId;
      _transactions.add(transaction);
      notifyListeners();
    }).catchError((error) => print(error));
  }

  void updateTransaction(Transaction transaction) {
    TransactionProvider().updateTransaction(transaction).then((success) {
      int index = _transactions.lastIndexWhere((transaction) => transaction.id == transaction.id);
      _transactions[index] = transaction;
      notifyListeners();
    }).catchError((error) => print(error));
  }

  void deleteTransaction(int id) {
    TransactionProvider().deleteTransaction(id).then((success) {
      _transactions.removeWhere((transaction) => transaction.id == id);
      notifyListeners();
    }).catchError((error) => print(error));
  }
}