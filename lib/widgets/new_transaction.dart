// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewTransaction extends StatefulWidget {

  final Function addTx; 

  const NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;


  void _SubmitData() {

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(_amountController.text.isEmpty) {
      return;
    }

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    
     widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate, 
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2022), 
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      },
      );
    },
   );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
              elevation: 6,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        ),
                      autocorrect: true,
                      // onChanged: (val) => titleInput = val,
                      controller: _titleController,
                      onSubmitted: (_) => _SubmitData(),
                    ),
                    TextField(decoration: const InputDecoration(
                      labelText: 'Amount',
                      ),
                     autocorrect: true,
                     keyboardType: TextInputType.number,
                    //  onChanged: (val) => amountInput = val,
                    controller: _amountController,
                    onSubmitted: (_) => _SubmitData(),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate ==null 
                              ? 'No Date Choosen Yet!' 
                              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                            ),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _presentDatePicker,
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text(
                        'Add Transaction'
                        ),
                      textColor: Theme.of(context).textTheme.button.color,
                      onPressed: () {
                        _SubmitData();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}