import 'package:flutter/material.dart';
import 'package:projeto_despesas/models/transaction.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, dynamic>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for(var i = 0; i < recentTransaction.length; i++){
       bool sameDay =  recentTransaction[i].date.day == weekDay.day;
       bool sameMonth =  recentTransaction[i].date.month == weekDay.month;
       bool sameYear =  recentTransaction[i].date.year == weekDay.year;

       if(sameDay && sameMonth && sameYear) {
       totalSum +=  recentTransaction[i].value;
       }
      }

      return {
      'day': DateFormat.E().format(weekDay)[0],
      'value' : totalSum };
    }).reversed.toList();
  }

  ///Para calcular o total que foi gasto na semana
  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactions.map((tr){
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    label: tr['day'],
                    value: tr['value'],
                    percentage: _weekTotalValue == 0 ? 0 : tr['value'] / _weekTotalValue,
                  ),
                );
              }).toList(),
            ),
          ),
      ),
    );
  }
}
