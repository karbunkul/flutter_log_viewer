import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:log_viewer/log_viewer.dart';
import 'package:logging/logging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
      builder: (_, child) => LogViewer(
        child: child!,
        formatters: [
          MapLogErrorFormatter(),
        ],
        logLevel: Level.ALL,
        stackTraceBuilder: (_, stack) {
          var index = 0;
          var rows = stack
              .toString()
              .split('\n')
              .where((element) => element.isNotEmpty)
              .map((e) {
            var item = e.replaceAll(RegExp(r'#\d+'), '');
            var pathMatch = RegExp(r'\(.[^(]+\)$');
            var path = pathMatch.firstMatch(item)!.group(0);
            item = item.replaceAll(pathMatch, '');
            index++;

            return ListTile(
              dense: true,
              leading: Text('#$index'),
              title: Text(
                item.trim(),
                style: Theme.of(_).textTheme.subtitle2,
              ),
              subtitle: Text(path!),
            );
          }).toList();

          return Column(children: rows);
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ViewerPage()));
              },
              icon: Icon(Icons.featured_play_list_outlined))
        ],
      ),
    );
  }
}

class ViewerPage extends StatelessWidget {
  const ViewerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogViewerConsumer(
      builder: (_, scope) {
        return Scaffold(
          appBar: AppBar(
            title: Text(DateTime.now().toIso8601String()),
            actions: [
              IconButton(
                onPressed: () {
                  scope.clear();
                  Logger('actions').info('tap clear button', {
                    'hello': 'world',
                    'items': [1, 2, 3, 4]
                  });
                },
                icon: Icon(Icons.clear),
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    var record = scope.logs.value.elementAt(index);
                    return ListTile(
                      onTap: _onTap(_, record, scope),
                      trailing:
                          Text(record.time.toIso8601String().substring(0, 19)),
                      title: Text(
                          '${record.level.toString()} - ${record.loggerName}'),
                      subtitle: Text(record.message),
                    );
                  },
                  childCount: scope.logs.value.length,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              double? a;
              try {
                print(a! / 1);
              } catch (e, stackTrace) {
                Logger('tap').severe('error', e, stackTrace);
              }
            },
          ),
        );
      },
    );
  }

  VoidCallback? _onTap(
      BuildContext context, LogRecord event, LogViewerScope scope) {
    if (event.stackTrace != null || event.error != null) {
      return () {
        var formatter = scope.formatter(event.error);
        showModalBottomSheet(
            context: context,
            builder: (__) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      formatter.build(__, event.error),
                      SizedBox(height: 12),
                      scope.stackTraceBuilder(__, event.stackTrace),
                      // Text(formatter.export(event.error)),
                    ],
                  ),
                ),
              );
            });
      };
    }

    return null;
  }
}

class MapLogErrorFormatter extends LogErrorFormatter {
  @override
  Widget build(BuildContext context, value) {
    return JsonViewer(value);
  }

  @override
  String export(value) {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

  @override
  bool hasApply(value) {
    return value is Map;
  }
}
