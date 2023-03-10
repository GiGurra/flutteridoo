import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget bind<TState extends ChangeNotifier, TUi extends Widget>(
    TState state, TUi child) {
  return ChangeNotifierProvider.value(value: state, child: child);
}

Widget observe<T>(Widget Function(BuildContext, T) callback) {
  return Consumer<T>(builder: (context, model, child) => callback(context, model));
}

void Function() modify<T>(BuildContext context, void Function(T) callback) {
  return () => callback(context.read<T>());
}
