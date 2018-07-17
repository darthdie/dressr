import 'package:dressr/app_state.dart';
import 'package:dressr/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return state;
}

void main() {
  final store = new Store<AppState>(appStateReducer, initialState: new AppState());

  runApp(new StoreProvider<AppState>(
    store: store,
    child: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dressr',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}