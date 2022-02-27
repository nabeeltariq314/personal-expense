import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/widgets/chart_bar.dart';
import '/models/transaction.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    print(recentTransactions);
    return List.generate(7, (index) {
      final weekDays = DateTime.now().subtract(
        Duration(days: index),
        );
      var totalSum = 0.0;
      for(var i=0; i<recentTransactions.length; i++){
        if(recentTransactions[i].date.day == weekDays.day &&
           recentTransactions[i].date.month == weekDays.month &&
           recentTransactions[i].date.year == weekDays.year){
            totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDays).substring(0, 1),
         'amount': totalSum,
         };
    }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map(
            (data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'], 
                  totalSpending == 0.0 
                  ? 0.0 
                  :  (data['amount'] as double) / totalSpending,
                ),
              );
            }
            ).toList(), 
        ),
      ),
    );
  }
}