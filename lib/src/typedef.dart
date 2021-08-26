import 'package:flutter/widgets.dart';
import 'package:log_viewer/src/scope.dart';

typedef LogBuilder = Widget Function(
    BuildContext context, LogViewerScope scope);

typedef StackTraceBuilder = Widget Function(
    BuildContext context, StackTrace? stackTrace);
