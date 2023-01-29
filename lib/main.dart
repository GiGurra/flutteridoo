import 'package:flutter/material.dart';
import 'package:flutteridoo/state_binding.dart';
import 'package:logging/logging.dart';

const appTitle = 'Bonk!';
final log = Logger(appTitle);

void main() {
  initLogging();
  final themeState = AppThemeState();
  final domainState = AppDomainState();
  runApp(AppBootstrapper(themeState, domainState));
}

class AppBootstrapper extends StatelessWidget {
  final AppThemeState themeState;
  final AppDomainState domainState;

  const AppBootstrapper(this.themeState, this.domainState, {super.key});

  @override
  Widget build(BuildContext context) {
    log.info("building AppBootstrapper");
    return bind(themeState, () => bind(domainState, App.new));
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    log.info("building App");

    return observe<AppThemeState>((theme) => MaterialApp(
          title: appTitle,
          theme: theme.theme,
          home: const AppUi(),
        ));
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
  const AppUi({super.key});

  @override
  Widget build(BuildContext context) {
    log.info("build $this");
    return Scaffold(
      appBar: createAppBar(context, appTitle), // should not rebuild
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            makeText(),
            observe<AppDomainState>((state) => Text(
                  '${state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            ElevatedButton(
              onPressed: modify<AppThemeState>(context, (d) => d.toggle()),
              child: const Text("Change material design version"),
            ),
            observe<AppThemeState>((theme) => Text(
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
    // backgroundColor: Theme.of(context).colorScheme.background,
    //  foregroundColor: Theme.of(context).colorScheme.onBackground,
  );
}

Text makeText() {
  log.info("made text");
  return const Text('You have pushed the button this many times:');
}