import 'package:flutter/widgets.dart';
import 'package:log_viewer/src/scope.dart';
import 'package:log_viewer/src/typedef.dart';

class LogViewerConsumer extends StatefulWidget {
  final LogBuilder builder;

  const LogViewerConsumer({Key? key, required this.builder}) : super(key: key);

  @override
  _LogViewerConsumerState createState() => _LogViewerConsumerState();
}

class _LogViewerConsumerState extends State<LogViewerConsumer> {
  void didChangeDependencies() {
    super.didChangeDependencies();
    scope.logs.addListener(_listener);
  }

  LogViewerScope get scope => LogViewerScope.of(context);

  @override
  void deactivate() {
    super.deactivate();
    scope.logs.removeListener(_listener);
  }

  _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext _) {
    return widget.builder(_, scope);
  }
}
