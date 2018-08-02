import 'package:built_collection/built_collection.dart';
import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/outfit.dart';
import 'package:dressr/models/piece.dart';
import 'package:dressr/models/piece_factory.dart';
import 'package:dressr/models/shirt.dart';
import 'package:dressr/pages/select_piece/select_piece.dart';
import 'package:redux_persist/redux_persist.dart';

class AppState {
  AppState({
    BuiltList<Piece> pieces,
    BuiltList<Outfit> outfits,
    Shirt newShirt,
    this.selectedShirt,
    Accessory newAccessory,
    SelectPieceFilter selectPieceFilter,
    Outfit newOutfit
  }):
    this.shirts = new BuiltList<Shirt>((pieces ?? new BuiltList<Shirt>()).where((p) => p.type == PieceType.Shirt)),
    this.pieces = pieces ?? new BuiltList<Piece>(),
    this.outfits = outfits ?? new BuiltList<Outfit>(),
    this.newShirt = newShirt ?? new Shirt(),
    this.newOutfit = newOutfit ?? new Outfit(),
    this.newAccessory = newAccessory ?? new Accessory(),
    this.accessories = new BuiltList<Accessory>((pieces ?? new BuiltList<Accessory>()).where((p) => p.type == PieceType.Accessory)),
    this.selectPieceFilter = selectPieceFilter ?? SelectPieceFilter.All;

  final BuiltList<Piece> pieces;
  final BuiltList<Outfit> outfits;
  final BuiltList<Shirt> shirts;
  final Shirt newShirt;
  final Accessory newAccessory;
  final BuiltList<Accessory> accessories;
  final Shirt selectedShirt;
  final SelectPieceFilter selectPieceFilter;
  final Outfit newOutfit;

  AppState copyWith({
    BuiltList<Piece> pieces,
    BuiltList<Outfit> outfits,
    Shirt newShirt,
    Accessory newAccessory,
    Shirt selectedShirt,
    SelectPieceFilter selectPieceFilter,
    Outfit newOutfit
  }) {
    return new AppState(
      newShirt: newShirt ?? this.newShirt,
      newAccessory: newAccessory ?? this.newAccessory,
      pieces: pieces ?? this.pieces,
      outfits: outfits ?? this.outfits,
      selectedShirt: selectedShirt ?? this.selectedShirt,
      selectPieceFilter: selectPieceFilter ?? this.selectPieceFilter,
      newOutfit: newOutfit ?? this.newOutfit
    );
  }

  static AppState fromJson(dynamic map) {
    if (map == null) {
      return new AppState();
    }

    return new AppState(
      pieces: new BuiltList<Piece>((map['pieces'] ?? []).map((p) => PieceFactory.fromJson(p))),
      outfits: new BuiltList<Outfit>((map['outfits'] ?? []).map((o) => new Outfit.fromJson(o)))
    );
  }

  Map toJson() {
    return {
      'pieces': pieces.map((s) => s.toJson()).toList(),
      'outfits': outfits.map((o) => o.toJson()).toList()
    };
  }

  Piece getPiece(String id) {
    return pieces.firstWhere((p) => p.id == id, orElse: () => null);
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

class UpdateNewAccessoryImage {
  UpdateNewAccessoryImage(this.image);

  final String image;
}

class UpdateNewAccessoryName {
  UpdateNewAccessoryName(this.name);

  final String name;
}

class AddAccessoryToNewShirt {
  AddAccessoryToNewShirt(this.id);

  final String id;
}

class RemoveAccessoryToNewShirt {
  RemoveAccessoryToNewShirt(this.id);

  final String id;
}

class SelectShirtAction {
  SelectShirtAction(this.shirt);

  final Shirt shirt;
}

class SelectPieceFilterAction {
  SelectPieceFilterAction(this.filter);

  final SelectPieceFilter filter;
}

class AddOrUpdatePieceAction {
  AddOrUpdatePieceAction(this.piece);

  final Piece piece;
}

class AddOrUpdateOutfit {
  AddOrUpdateOutfit(this.outfit);

  final Outfit outfit;
}

class UpdateNewOutfit {
  UpdateNewOutfit(this.outfit);

  final Outfit outfit;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is PersistLoadedAction<AppState>) {
    return action.state ?? state;
  }

  if (action is AddOrUpdatePieceAction) {
    final existing = state.pieces.firstWhere((s) => s.id == action.piece.id, orElse: () => null);
    if (existing == null) {
      return state.copyWith(
        pieces: state.pieces.rebuild((b) => b.add(action.piece)),
      );
    }

    return state.copyWith(
      pieces: state.pieces.rebuild((b) => b..[state.pieces.indexOf(existing)] = action.piece)
    );
  } else if (action is UpdateNewOutfit) {
    return state.copyWith(
      newOutfit: action.outfit
    );
  } else if (action is AddOrUpdateOutfit) {
    final existing = state.outfits.firstWhere((s) => s.id == action.outfit.id, orElse: () => null);
    if (existing == null) {
      return state.copyWith(
        outfits: state.outfits.rebuild((b) => b.add(action.outfit)),
      );
    }

    return state.copyWith(
      outfits: state.outfits.rebuild((b) => b..[state.outfits.indexOf(existing)] = action.outfit)
    );    
  }

  switch (action.runtimeType) {
    case UpdateNewShirtImage:
      return state.copyWith(newShirt: state.newShirt.copyWith(image: action.image));
    case UpdateNewShirtName:
      return state.copyWith(newShirt: state.newShirt.copyWith(name: action.name));
    case UpdateNewShirtButtonable:
      return state.copyWith(newShirt: state.newShirt.copyWith(buttonable: action.buttonable));
    case UpdateNewAccessoryImage:
      return state.copyWith(newAccessory: state.newAccessory.copyWith(image: action.image));
    case UpdateNewAccessoryName:
      return state.copyWith(newAccessory: state.newAccessory.copyWith(name: action.name));
    // case AddAccessoryToNewShirt:
    //   return state.copyWith(
    //     newShirt: state.newShirt.copyWith(accessories: state.newShirt.accessories.rebuild((b) => b..add(action.id)))
    //   );
    // case RemoveAccessoryToNewShirt:
    //   return state.copyWith(
    //     newShirt: state.newShirt.copyWith(accessories: state.newShirt.accessories.rebuild((b) => b..remove(action.id)))
    //   );
    case SelectShirtAction:
      return state.copyWith(selectedShirt: action.shirt);
    case SelectPieceFilterAction:
      return state.copyWith(selectPieceFilter: action.filter);
    default:
      return state;
  }
}