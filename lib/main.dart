import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),).bodyText2,
          titleTextStyle: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),).headline6,
        ),
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple).copyWith(secondary: Colors.amber)
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
  final List<Transaction> _userTransactions = [
    //Transaction(id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now(),),
    //Transaction(id: 't2', title: 'Weekly Groceries', amount: 16.99, date: DateTime.now(),),
  ];
  bool _showChart = true;
  List<Transaction> get _recentTransactions{
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7),),);
    }).toList();
  }

  get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;
  void _addNewTransaction(String txtitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }
  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    });
  }
  void _deleteTransaction(String id){
      setState(() {
        _userTransactions.removeWhere((tx) => tx.id == id);
      });
  }

  @override
  Widget build(BuildContext context) {
    final isLanndscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('Personal Expenses', style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: Icon(CupertinoIcons.add),
    ),
          ],
        ),
    ) : AppBar(
      title: Text('Personal Expenses', style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
      actions: <Widget>[
        IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add),),
      ],
    ) as PreferredSizeWidget;
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLanndscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch.adaptive(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: _showChart, onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },),
              ],
            ),
            if(!isLanndscape) Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
                child: Chart(_recentTransactions)),
            if(!isLandscape) txListWidget,
            if(isLandscape) _showChart ? Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.6,
                child: Chart(_recentTransactions))
                : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS ? CupertinoPageScaffold(child: pageBody) : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),),
    );
  }
}
