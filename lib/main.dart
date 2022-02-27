// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: const TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'Shoes',
    //   amount: 1800,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Shirt',
    //   amount: 1000,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = true;

  List<Transaction> get _recentTransactions{
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
      final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString(),
      );

      setState(() {
        _userTransaction.add(newTx);
      });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

void _startAddNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
  },);
}

List <Widget> _buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget){
  return [ Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text('Show Chart'),
               Switch.adaptive(
                 activeColor: Theme.of(context).accentColor,
                 value: _showChart, 
                 onChanged: (val) {
                   setState(() {
                     _showChart = val;
                   });
                 },
                 ),
             ],
           ),
              _showChart ? Container(
              height: (mediaQuery.size.height -
              appBar.preferredSize.height - 
              mediaQuery.padding.top) * 0.7,
             child: Chart(_recentTransactions),
             )
            : txListWidget, 
  ];
}

List <Widget> _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget){
  return [ Container(
             height: (mediaQuery.size.height -
              appBar.preferredSize.height - 
              mediaQuery.padding.top) * 0.3,
             child: Chart(_recentTransactions),
             ),
             txListWidget,
  ];
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
        title: const Text(
          'Personal Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontFamily: 'OpenSans',
            fontSize: 20,
            ),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30,
            onPressed: () => _startAddNewTransaction(context), 
            )
        ],
      );
      final txListWidget = Container(
             height: (mediaQuery.size.height - 
             appBar.preferredSize.height - 
             mediaQuery.padding.top) * 0.7,
             child: TransactionList(_userTransaction, _deleteTransaction)
             );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // '...' spread operator it extracts list items 
           if (isLandscape) 
              ... _buildLandscapeContent(
                mediaQuery, 
                appBar, 
                txListWidget),
           if(!isLandscape) 
              ... _buildPortraitContent(
                mediaQuery, 
                appBar, 
                txListWidget),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS 
      ? Container() 
      : FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
