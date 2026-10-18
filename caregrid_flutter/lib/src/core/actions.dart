import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

/// Runs a server action and reports the outcome in a snackbar.
Future<bool> runAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
    if (success != null) {
      messenger.showSnackBar(SnackBar(content: Text(success)));
    }
    return true;
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(describeError(e)),
        backgroundColor: Colors.red.shade700,
      ),
    );
    return false;
  }
}

String describeError(Object e) {
  if (e is CareGridException) return e.message;
  final text = e.toString();
  return text.length > 200 ? '${text.substring(0, 200)}...' : text;
}

/// Asks for a short text (reason, outcome, note). Returns null on cancel.
Future<String?> askText(
  BuildContext context, {
  required String title,
  required String label,
  String confirm = 'Submit',
  String initial = '',
  bool required = true,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final text = controller.text.trim();
            if (required && text.isEmpty) return;
            Navigator.pop(context, text);
          },
          child: Text(confirm),
        ),
      ],
    ),
  );
}

/// Yes / no confirmation built into the page.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  String action = 'Confirm',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(action),
        ),
      ],
    ),
  );
  return result ?? false;
}
