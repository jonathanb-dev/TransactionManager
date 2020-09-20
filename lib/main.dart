import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Helpers
import './helpers/route_helper.dart';

// Models
import './models/transactions.dart';

// Screens
import './modules/transaction/screens/transactions_screen.dart';
import './modules/transaction/screens/edit_transaction_screen.dart';

void main() {
  runApp(TransactionManager());
}

class TransactionManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Transactions(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteHelper.TRANSACTIONS,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        routes: {
          RouteHelper.TRANSACTIONS: (context) => TransactionsScreen(),
          RouteHelper.EDIT_TRANSACTION: (context) => EditTransactionScreen(),
        },
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
        ],
        theme: ThemeData(
        accentColor: Colors.pink,
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xfff0f0f0),
        ),
      ),
    );
  }
}