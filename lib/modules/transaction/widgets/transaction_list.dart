import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../../../models/transactions.dart';
import '../../../models/transaction.dart';

// Widgets
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final DisplayMode displayMode;
  final String searchQuery;

  TransactionList(this.displayMode, {
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final Transactions transactionsModel = Provider.of<Transactions>(
      context,
    );
    List<Transaction> transactions = transactionsModel.getFilteredTransactionsByDisplayMode(
      displayMode,
      searchQuery: searchQuery,
    );
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