import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutteridoo/state_binding.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

const appTitle = 'Bonk!';
final log = Logger(appTitle);

void main() {
  initLogging();
  runApp(AppBootstrapper(AppThemeState(), AppDomainState()));
}

class AppBootstrapper extends StatelessWidget {
  final AppThemeState themeState;
  final AppDomainState domainState;

  const AppBootstrapper(this.themeState, this.domainState, {super.key});

  @override
  Widget build(BuildContext context) {
    log.info("building AppBootstrapper");
    return bind(themeState, bind(domainState, const App()));
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    log.info("building App");

    return observe<AppThemeState>((context, theme) {
      log.info("building MaterialApp");
      final ui = AppUi();
      return MaterialApp(
        title: appTitle,
        theme: theme.theme,
        home: ui,
      );
    });
  }
}

class AppThemeState extends ChangeNotifier {
  final List<ThemeData> _availableThemes = [
    ThemeData.light().copyWith(useMaterial3: true),
    ThemeData.dark().copyWith(useMaterial3: true),
    ThemeData.light().copyWith(useMaterial3: false),
    ThemeData.dark().copyWith(useMaterial3: false),
  ];

  ThemeData _theme = ThemeData.light().copyWith(useMaterial3: true);

  ThemeData get theme => _theme;

  void _set(ThemeData newTheme) {
    if (_theme != newTheme) {
      _theme = newTheme;
      notifyListeners();
    }
  }

  void toggle() {
    log.info("---------------------------------");
    log.info("Changing material design version!");
    final newIndex =
        (_availableThemes.indexOf(_theme) + 1) % _availableThemes.length;
    _set(_availableThemes[newIndex]);
  }
}

class AppDomainState extends ChangeNotifier {
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
  AppUi({super.key}) {
    log.info("Made new instance $this@${identityHashCode(this)}");
  }

  @override
  Widget build(BuildContext context) {
    log.info("build $this@${identityHashCode(this)}");
    //sleep(const Duration(seconds: 1));
    return Scaffold(
      appBar: createAppBar(context, appTitle), // should not rebuild
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            makeText(),
            observe<AppDomainState>(
              (context, state) => Text(
                '${state.counter}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ElevatedButton(
              onPressed: modify<AppThemeState>(context, (d) => d.toggle()),
              child: const Text("Change material design version"),
            ),
            observe<AppThemeState>((context, theme) => Text(
                "using brightness=${theme.theme.brightness}, matv=${theme.theme.useMaterial3 ? "3" : "2"}")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            modify<AppDomainState>(context, (state) => state.increment()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

AppBar createAppBar(BuildContext context, String title) {
  log.info("Created app bar");
  return AppBar(
    title: Text(title),
  );
}

Text makeText() {
  log.info("made text");
  return const Text('You have pushed the button this many times:');
}
