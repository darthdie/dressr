import 'package:built_collection/built_collection.dart';
import 'package:dressr/models/shirt.dart';

class AppState {
  AppState({
    BuiltList<Shirt> shirts,
    this.newShirtImage
  }):
    this.shirts = shirts ?? new BuiltList<Shirt>();

  final BuiltList<Shirt> shirts;
  final String newShirtImage;

  AppState copyWith({
    BuiltList<Shirt> shirts,
    String newShirtImage
  }) {
    return new AppState(
      shirts: shirts ?? this.shirts,
      newShirtImage: newShirtImage ?? this.newShirtImage,
    );
  }
}

class UpdateNewShirtImage {
  UpdateNewShirtImage(this.image);

  final String image;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is UpdateNewShirtImage) {
    return state.copyWith(newShirtImage: action.image);
  }

  return state;
}