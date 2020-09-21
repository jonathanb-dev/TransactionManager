import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Helpers
import '../../../helpers/route_helper.dart';

// Models
import '../../../models/transactions.dart';

// Delegates
import '../delegates/search_transactions_delegate.dart';

// Widgets
import '../widgets/transaction_list.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  Future _transactionsFuture;

  Future<void> _getTransactionsFuture() {
    return Provider.of<Transactions>(
      context,
      listen: false,
    ).fetchAndSetTransactions();
  }

  @override
  void initState() {
    _transactionsFuture = _getTransactionsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.list,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_upward,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_downward,
                ),
              ),
            ],
          ),
          title: Text(
            'Transactions',
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchTransactionsDelegate(),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.error != null) {
              return Center(
                child: Text(
                  'An error occured while fetching transactions',
                ),
              );
            }
            else {
              return TabBarView(
                children: [
                  TransactionList(
                    DisplayMode.All,
                  ),
                  TransactionList(
                    DisplayMode.Gains,
                  ),
                  TransactionList(
                    DisplayMode.Losses,
                  ),
                ],
              );
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(RouteHelper.EDIT_TRANSACTION);
          },
        ),
      ),
    );
  }
}