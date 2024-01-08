import 'package:flutter/material.dart';
import 'package:projeto_despesas/components/transaction_form.dart';
import 'dart:math';
import 'components/transaction_form.dart';
import 'models/transaction.dart';
import 'components/chart.dart';
import 'components/transaction_list.dart';

main() => runApp(DespesasApp());

class DespesasApp extends StatelessWidget {
  const DespesasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
        home: MyHomePage(),
        theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.indigo,
            secondary: Colors.indigoAccent,
          ),
          textTheme: tema.textTheme.copyWith(
              titleMedium: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              labelLarge: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context)
        .pop(); // PRA FECHAR O MODAL E SALVAR O ITEM NA LISTA/TELA
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showChart = !_showChart;
            });
          },
          icon: Icon(_showChart ? Icons.list : Icons.bar_chart),
        ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    final alturaDisponivel = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // if (isLandscape)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Exibir Gráfico."),
          //       Switch(
          //           value: _showChart,
          //           onChanged: (value) {
          //             setState(() {
          //               _showChart = value;
          //             });
          //           })
          //     ],
          //   ),
          if (_showChart || !isLandscape)
            Container(
              height: alturaDisponivel * (isLandscape ? 0.7 : 0.30),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
              height: alturaDisponivel * 0.7,
              child: TransactionList(_transactions, _deleteTransaction),
            )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
