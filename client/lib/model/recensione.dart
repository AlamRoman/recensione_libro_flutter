import 'package:json_annotation/json_annotation.dart';

part 'recensione.g.dart';

@JsonSerializable()
class Recensione {
  int id;
  int id_user;
  int id_libro;
  
  @JsonKey(
    fromJson: _parseVoto,
    toJson: _encodeVoto,
  )
  double voto;
  
  String? commento;

  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  DateTime? data_ultima_modifica;

  Recensione({
    required this.id,
    required this.id_libro,
    required this.id_user,
    required this.voto,
    this.commento,
    this.data_ultima_modifica,
  });

  factory Recensione.fromJson(Map<String, dynamic> json) =>
      _$RecensioneFromJson(json);

  Map<String, dynamic> toJson() => _$RecensioneToJson(this);

  static double _parseVoto(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static dynamic _encodeVoto(double voto) => voto;

  static DateTime? _fromJsonDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date); 
    } catch (_) {
      return null;
    }
  }

  static String? _toJsonDate(DateTime? date) => date?.toIso8601String();
}