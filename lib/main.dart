import 'package:flutter/material.dart';
import 'package:flutteridoo/state_binding.dart';
import 'package:logging/logging.dart';

const appTitle = 'Bonk!';
final log = Logger(appTitle);

void main() {
  initLogging();
  runApp(MaterialApp(
    title: appTitle,
    //theme: ThemeData(),
    home: bind(AppState(), AppUi.new),
  ));
}

class AppState extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}

void initLogging() {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class AppUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.info("build $this");
    return Scaffold(
      appBar: createAppBar(appTitle), // should not rebuild
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            makeText(),
            observe<AppState>((state) => Text(
                  '${state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: modify<AppState>(context, (state) => state.increment()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

AppBar createAppBar(String title) {
  log.info("Created app bar");
  return AppBar(
    title: Text(title),
  );
}

Text makeText() {
  log.info("made text");
  return const Text('You have pushed the button this many times:');
}
