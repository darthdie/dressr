import 'package:dressr/app_state.dart';
import 'package:dressr/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

void main() async {
  var persistor = new Persistor<AppState>(
    storage: new FlutterStorage("dressr"),
    decoder: AppState.fromJson,
  );
  
  final store = new Store<AppState>(
    appStateReducer,
    initialState: new AppState(),
    middleware: [persistor.createMiddleware()]
  );

  await persistor.load(store);

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