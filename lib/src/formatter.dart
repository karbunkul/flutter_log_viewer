import 'package:flutter/cupertino.dart';

abstract class LogErrorFormatter {
  Widget build(BuildContext context, value);
  bool hasApply(value);

  String export(value) {
    return value.toString();
  }
}
