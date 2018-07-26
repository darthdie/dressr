import 'package:built_collection/built_collection.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/shirt.dart';
import 'package:redux_persist/redux_persist.dart';

class AppState {
  AppState({
    BuiltList<Shirt> shirts,
    Shirt newShirt,
    Accessory newAccessory,
    BuiltList<Accessory> accessories,
  }):
    this.shirts = shirts ?? new BuiltList<Shirt>(),
    this.newShirt = newShirt ?? new Shirt(),
    this.newAccessory = newAccessory ?? new Accessory(),
    this.accessories = accessories ?? new BuiltList<Accessory>();

  final BuiltList<Shirt> shirts;
  final Shirt newShirt;
  final Accessory newAccessory;
  final BuiltList<Accessory> accessories;

  AppState copyWith({
    BuiltList<Shirt> shirts,
    Shirt newShirt,
    Accessory newAccessory,
    BuiltList<Accessory> accessories,
  }) {
    return new AppState(
      shirts: shirts ?? this.shirts,
      newShirt: newShirt ?? this.newShirt,
      newAccessory: newAccessory ?? this.newAccessory,
      accessories: accessories ?? this.accessories,
    );
  }

  static AppState fromJson(dynamic map) {
    if (map == null) {
      return new AppState();
    }

    return new AppState(
      shirts: new BuiltList((map['shirts'] ?? []).map((i) => new Shirt.fromJson(i))),
      accessories: new BuiltList((map['accessories'] ?? []).map((a) => new Accessory.fromJson(a)))
    );
  }

  Map toJson() {
    return {
      'shirts': shirts.map((s) => s.toJson()).toList(),
      'accessories': accessories.map((a) => a.toJson()).toList()
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

class UpdateNewAccessoryImage {
  UpdateNewAccessoryImage(this.image);

  final String image;
}

class UpdateNewAccessoryName {
  UpdateNewAccessoryName(this.name);

  final String name;
}

class AddAccessoryAction {
}

class AddAccessoryToNewShirt {
  AddAccessoryToNewShirt(this.id);

  final String id;
}

class RemoveAccessoryToNewShirt {
  RemoveAccessoryToNewShirt(this.id);

  final String id;
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
    case UpdateNewAccessoryImage:
      return state.copyWith(newAccessory: state.newAccessory.copyWith(image: action.image));
    case UpdateNewAccessoryName:
      return state.copyWith(newAccessory: state.newAccessory.copyWith(name: action.name));
    case AddAccessoryAction:
      return state.copyWith(
        accessories: state.accessories.rebuild((b) => b.add(state.newAccessory)),
        newAccessory: new Accessory()
      );
    case AddAccessoryToNewShirt:
      return state.copyWith(
        newShirt: state.newShirt.copyWith(accessories: state.newShirt.accessories.rebuild((b) => b..add(action.id)))
      );
    case RemoveAccessoryToNewShirt:
      return state.copyWith(
        newShirt: state.newShirt.copyWith(accessories: state.newShirt.accessories.rebuild((b) => b..remove(action.id)))
      );
    default:
      return state;
  }
}