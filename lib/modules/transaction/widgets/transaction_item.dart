import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Helpers
import '../../../helpers/route_helper.dart';

// Models
import '../../../models/transactions.dart';
import '../../../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  TransactionItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    final Transactions transactionsModel = Provider.of<Transactions>(
      context,
      listen: false,
    );

    return GestureDetector(
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: ValueKey(transaction.id),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100.0,
                  child: Column(
                    children: [
                      Icon(
                        transaction.amount > 0.0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: transaction.amount > 0.0 ? Colors.green : Colors.red,
                        size: 30.0,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${transaction.amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.amount > 0.0 ? Colors.green : Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction.name.toUpperCase()}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(transaction.dateAndTime),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Icon(
                  Icons.chevron_right,
                  size: 30.0,
                ),
              ],
            ),
          ),
        ),
        confirmDismiss: (direction) {
          return showDialog(
            builder: (context) => AlertDialog(
              content: Text(
                'Delete this transaction?',
              ),
              title: Text(
                'Confirmation',
              ),
              actions: [
                FlatButton(
                  child: Text(
                    'No',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
            context: context,
          );
        },
        onDismissed: (direction) {
          transactionsModel.deleteTransaction(transaction.id);
        },
      ),
      onLongPress: () {
        Navigator.of(context).pushNamed(
          RouteHelper.EDIT_TRANSACTION,
          arguments: transaction.id,
        );
      },
    );
  }
}