import 'dart:io';

import 'package:flutter/material.dart';
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
    return ChangeNotifierProvider<AppThemeState>.value(
      value: themeState,
      builder: (_, __) => ChangeNotifierProvider<AppDomainState>.value(
        value: domainState,
        builder: (_, __) => const App(),
      ),
    );
  }
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    log.info("building App");

    return Consumer<AppThemeState>(builder: (_, theme, __) {
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

class AppUi extends StatelessWidget {
  AppUi({super.key}) {
    log.info("Made new instance $this@${identityHashCode(this)}");
  }

  @override
  Widget build(BuildContext context) {
    log.info("build $this@${identityHashCode(this)}");
    //sleep(const Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Consumer<AppDomainState>(
                builder: (_, state, __) => Text('${state.counter}')),
            ElevatedButton(
              onPressed: () => context.read<AppThemeState>().toggle(),
              child: const Text("Change material design version"),
            ),
            Consumer<AppThemeState>(
                builder: (_, theme, __) => Text(
                    "using brightness=${theme.theme.brightness}, matv=${theme.theme.useMaterial3 ? "3" : "2"}")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AppDomainState>().increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void initLogging() {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}
