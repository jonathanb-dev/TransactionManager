import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../../../models/transactions.dart';
import '../../../models/transaction.dart';

// Widgets
import '../widgets/transaction_list.dart';

class SearchTransactionsDelegate extends SearchDelegate<Transaction> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        close(
          context,
          null,
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var transactionsModel = Provider.of<Transactions>(
      context,
      listen: false,
    );
    if (transactionsModel.getFilteredTransactions(
      searchQuery: query,
    ).isEmpty) {
      return Center(
        child: Text(
          'No results found',
        ),
      );
    }
    return TransactionList(
      DisplayMode.All,
      searchQuery: query,
    );
  }
}