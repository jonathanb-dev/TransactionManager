import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../../../models/transactions.dart';
import '../../../models/transaction.dart';

// Widgets
import './transaction_item.dart';

enum DisplayMode {
  All,
  Gains,
  Losses
}

class TransactionList extends StatelessWidget {
  final DisplayMode displayMode;

  TransactionList(this.displayMode);

  List<Transaction> _getTransactionsByDisplayMode(Transactions transactionsModel) {
    switch(displayMode) {
      case DisplayMode.All:
        return transactionsModel.transactions;
      case DisplayMode.Gains:
        return transactionsModel.gains;
      case DisplayMode.Losses:
        return transactionsModel.losses;
      default:
        return transactionsModel.transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Transactions transactionsModel = Provider.of<Transactions>(
      context,
    );
    final List<Transaction> transactions = _getTransactionsByDisplayMode(transactionsModel);

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions added yet!',
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) => TransactionItem(transactions[index]),
      itemCount: transactions.length,
    );
  }
}