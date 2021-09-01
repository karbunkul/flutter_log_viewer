import 'package:flutter/widgets.dart';
import 'package:log_viewer/src/typedef.dart';
import 'package:logging/logging.dart';

class LogViewerScope extends InheritedWidget {
  final ValueNotifier<List<LogRecord>> logs;
  final VoidCallback clear;
  final StackTraceBuilder stackTraceBuilder;
  final Formatter formatter;

  const LogViewerScope({
    Key? key,
    required Widget child,
    required this.logs,
    required this.clear,
    required this.stackTraceBuilder,
    required this.formatter,
  }) : super(key: key, child: child);

  static LogViewerScope of(BuildContext context) {
    final LogViewerScope? result =
        context.dependOnInheritedWidgetOfExactType<LogViewerScope>();
    assert(result != null, 'No LogViewerScope found in context');
    return result!;
  }

  changeLevel(Level level) {
    Logger.root.level = level;
  }

  @override
  bool updateShouldNotify(LogViewerScope old) {
    return false;
  }
}
