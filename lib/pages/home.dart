import 'package:dressr/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _HomePageViewModel>(
      converter: (store) => new _HomePageViewModel.create(store),
      builder: (context, viewModel) {
      },
    );
  }
}

class _HomePageViewModel {
  _HomePageViewModel();

  factory _HomePageViewModel.create(Store<AppState> store) {
    return new _HomePageViewModel();
  }
}