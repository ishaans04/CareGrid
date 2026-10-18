import 'dart:async';

import 'package:flutter/material.dart';

import '../core/format.dart';

/// Live countdown to the next milestone Proof-of-Response expects.
/// Turns red and counts up once the deadline has passed.
class DeadlineCountdown extends StatefulWidget {
  const DeadlineCountdown({super.key, required this.deadline, this.label});

  final DateTime? deadline;
  final String? label;

  @override
  State<DeadlineCountdown> createState() => _DeadlineCountdownState();
}

class _DeadlineCountdownState extends State<DeadlineCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deadline = widget.deadline;
    if (deadline == null) return const SizedBox.shrink();
    final left = deadline.toUtc().difference(DateTime.now().toUtc()).inSeconds;
    final overdue = left < 0;
    final color = overdue
        ? Colors.red
        : left < 10
        ? Colors.orange
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          overdue ? Icons.alarm_on : Icons.timer_outlined,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${widget.label ?? 'Next milestone'}: '
            '${overdue ? 'overdue ${Fmt.seconds(-left)}' : 'in ${Fmt.seconds(left)}'}',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
