import 'package:dressr/models/accessory.dart';
import 'package:dressr/models/piece.dart';
import 'package:dressr/models/shirt.dart';

class PieceFactory {
  static Piece fromJson(dynamic json) {
    if (PieceType.values.firstWhere((v) => v.toString() == json['type']) == PieceType.Shirt) {
      return new Shirt.fromJson(json);
    }

    return new Accessory.fromJson(json);
  }
}