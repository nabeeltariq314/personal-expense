// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {

final List<Transaction> transactions;
Function deleteTx;
TransactionList(this.transactions, this.deleteTx);



@override
  Widget build(BuildContext context) {
    return Container(
              child: transactions.isEmpty 
              ? LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                children: [
                Text(
                  'No Transactions Added Yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                    ),
                ),
              ],);
              })  
              : ListView.builder(
                itemBuilder: (cTx, index){
                  return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
          },
          itemCount: transactions.length,
        ),
    );
  }
}