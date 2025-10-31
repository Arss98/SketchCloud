import 'package:flutter/material.dart';

final class ExitDialog extends StatelessWidget {
  final VoidCallback onExitConfirmed;

  const ExitDialog({super.key, required this.onExitConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выйти без сохранения?'),
      content: const Text('Все несохраненные изменения будут потеряны.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onExitConfirmed();
          },
          child: const Text('Выйти'),
        ),
      ],
    );
  }
}
