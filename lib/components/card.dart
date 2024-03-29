import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/models/transaction.dart';

class CardTransaction extends StatelessWidget {
  final Transaction tr;
  final void Function(String) onDelete;

  const CardTransaction({super.key,
    required this.tr,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              child: Text(
                'R\$${tr.value}',
              ),
            ),
          ),
        ),
        title: Text(
          tr.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(tr.date),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () => onDelete(tr.id),
        ),
      ),
    );
  }
}
