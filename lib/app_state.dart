import 'package:built_collection/built_collection.dart';
import 'package:dressr/models/shirt.dart';
import 'package:redux_persist/redux_persist.dart';

class AppState {
  AppState({
    BuiltList<Shirt> shirts,
    Shirt newShirt,
  }):
    this.shirts = shirts ?? new BuiltList<Shirt>(),
    this.newShirt = newShirt ?? new Shirt();

  final BuiltList<Shirt> shirts;
  final Shirt newShirt;

  AppState copyWith({
    BuiltList<Shirt> shirts,
    Shirt newShirt,
  }) {
    return new AppState(
      shirts: shirts ?? this.shirts,
      newShirt: newShirt ?? this.newShirt,
    );
  }

  static AppState fromJson(dynamic map) {
    if (map == null) {
      return new AppState();
    }

    return new AppState(
      shirts: new BuiltList((map['shirts'] ?? []).map((i) => new Shirt.fromJson(i)))
    );
  }

  Map toJson() {
    return {
      'shirts': shirts.map((s) => s.toJson())
    };
  }
}

class UpdateNewShirtImage {
  UpdateNewShirtImage(this.image);

  final String image;
}

class UpdateNewShirtName {
  UpdateNewShirtName(this.name);

  final String name;
}

class UpdateNewShirtButtonable {
  UpdateNewShirtButtonable(this.buttonable);

  final bool buttonable;
}

class AddShirtAction {
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is PersistLoadedAction<AppState>) {
    return action.state ?? state;
  }

  switch (action.runtimeType) {
    case UpdateNewShirtImage:
      return state.copyWith(newShirt: state.newShirt.copyWith(image: action.image));
    case UpdateNewShirtName:
      return state.copyWith(newShirt: state.newShirt.copyWith(name: action.name));
    case UpdateNewShirtButtonable:
      return state.copyWith(newShirt: state.newShirt.copyWith(buttonable: action.buttonable));
    case AddShirtAction:
      return state.copyWith(
        shirts: state.shirts.rebuild((b) => b.add(state.newShirt)),
        newShirt: new Shirt()
      );
    default:
      return state;
  }
}