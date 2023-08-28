import '../models/transaction.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
class TransactionList extends StatelessWidget {
 final List<Transaction> transactions;
 final Function deleteTx;

 TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? LayoutBuilder(builder: (ctx, constraints){
      return Column(children: <Widget>[
        Text('No Transactions added yet!', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 20),),
        SizedBox(height: 20,),
        Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,)),
      ],);
    },) : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(radius: 30, child: Padding(
                padding: EdgeInsets.all(6),
                  child: FittedBox(child: Text('\$${transactions[index].amount}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                transactions[index].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(transactions[index].date) ,style: TextStyle(color: Colors.grey),
              ),
              trailing: MediaQuery.of(context).size.width > 360 ?
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                  onPressed: () => deleteTx(transactions[index].id),
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, textStyle: TextStyle(color: Theme.of(context).colorScheme.error)),
                  label: Text('Delete',))
              : IconButton(icon: Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                onPressed: () => deleteTx(transactions[index].id),
              ),
            ),
          );
          /*Card(
            child: Row(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  vertical:10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  '\$${transactions[index].amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(transactions[index].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),),
                  Text(DateFormat.yMMMd().format(transactions[index].date) ,style: TextStyle(color: Colors.grey),),
                ],
              ),
            ],
            ),
          );*/
        },
        itemCount: transactions.length,
    );
  }
}
