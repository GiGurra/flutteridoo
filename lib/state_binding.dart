import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget bind<TState extends ChangeNotifier, TUi extends Widget>(
    TState state, TUi Function() uiCtor) {
  return ChangeNotifierProvider(create: (_) => state, child: uiCtor());
}

Widget observe<T>(Widget Function(T) callback) {
  return Consumer<T>(builder: (context, model, child) => callback(model));
}

void Function() modify<T>(BuildContext context, void Function(T) callback) {
  return () => callback(context.read<T>());
}
