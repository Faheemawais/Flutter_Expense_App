import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData(){
    if(_amountController.text.isEmpty){
      return;
    }
    final enterdTitle = _titleController.text;
    final enterdAmount = double.parse(_amountController.text);

    if(enterdTitle.isEmpty || enterdAmount <= 0 || _selectedDate == null){
      return;
    }
    widget.addTx(
      enterdTitle,
      enterdAmount,
      _selectedDate,
    );
    
    Navigator.of(context).pop();
  }
  void _presentDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime.now(),).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(decoration: InputDecoration(labelText: 'Title'), controller: _titleController, onSubmitted: (_) => _submitData(),),
              TextField(decoration: InputDecoration(labelText: 'Amount'), controller: _amountController, keyboardType: TextInputType.number, onSubmitted: (_) => _submitData(),),
              Container(
                height: 70,
                child: Row(children: <Widget>[
                   Expanded(child: Text(_selectedDate == null ? 'No Date Chosen!' : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}')),
                  TextButton(onPressed: _presentDatePicker, child: Text('Choose date', style: TextStyle(fontWeight: FontWeight.bold),), style: TextButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                  ),),
                    ],),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.primary,),
                child: Text('Add Transaction'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
