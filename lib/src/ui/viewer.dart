import 'package:flutter/widgets.dart';
import 'package:log_viewer/src/log_notifier.dart';
import 'package:log_viewer/src/scope.dart';
import 'package:log_viewer/src/typedef.dart';
import 'package:logging/logging.dart';

class LogViewer extends StatefulWidget {
  final Widget child;
  final Level? logLevel;
  final StackTraceBuilder? stackTraceBuilder;

  const LogViewer({
    Key? key,
    required this.child,
    this.logLevel,
    this.stackTraceBuilder,
  }) : super(key: key);

  @override
  _LogViewerState createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  final LogNotifier _logs = LogNotifier(<LogRecord>[]);

  @override
  void initState() {
    super.initState();
    Logger.root.level = widget.logLevel ?? Level.OFF;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Logger.root.onRecord.listen((event) {
      _logs.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LogViewerScope(
      child: widget.child,
      logs: _logs,
      clear: _logs.clear,
      stackTraceBuilder: _stackTraceBuilder,
    );
  }

  Widget _stackTraceBuilder(_, stack) {
    if (stack == null) {
      return Container();
    }

    if (widget.stackTraceBuilder != null) {
      return widget.stackTraceBuilder!(_, stack);
    }
    return Text(stack.toString());
  }
}
