import 'package:caregrid_server/server.dart';
import 'package:caregrid_server/bootstrap.dart';

/// This is the starting point for your Serverpod server. Typically, there is
/// no need to modify this file.
Future<void> main(List<String> args) =>
    args.isNotEmpty && args.first == 'bootstrap'
    ? bootstrap(args.skip(1).toList())
    : run(args);
