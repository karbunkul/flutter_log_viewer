import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class LogNotifier extends ValueNotifier<List<LogRecord>> {
  LogNotifier(List<LogRecord> value) : super(value);

  add(LogRecord event) {
    value.insert(0, event);
    notifyListeners();
  }

  clear() {
    value.clear();
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
