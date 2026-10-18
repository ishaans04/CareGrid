import 'package:flutter/material.dart';

import '../core/actions.dart';
import '../core/live_feed.dart';

/// Loads data with [load] and reloads it whenever the live feed reports a
/// change. Every data-driven screen is built on this one component.
class LiveLoader<T> extends StatefulWidget {
  const LiveLoader({super.key, required this.load, required this.builder});

  final Future<T> Function() load;
  final Widget Function(
    BuildContext context,
    T data,
    Future<void> Function() reload,
  )
  builder;

  @override
  State<LiveLoader<T>> createState() => _LiveLoaderState<T>();
}

class _LiveLoaderState<T> extends State<LiveLoader<T>> {
  T? _data;
  Object? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    LiveFeed.instance.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    LiveFeed.instance.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    if (_loading) return;
    _loading = true;
    try {
      final data = await widget.load();
      if (!mounted) return;
      setState(() {
        _data = data;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    } finally {
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      if (_error != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 40),
                const SizedBox(height: 8),
                Text(describeError(_error!), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _reload, child: const Text('Retry')),
              ],
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    return widget.builder(context, data, _reload);
  }
}
