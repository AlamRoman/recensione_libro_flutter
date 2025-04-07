import 'package:json_annotation/json_annotation.dart';

part 'recensione.g.dart';

@JsonSerializable()
class Recensione {
  int id;
  int id_user;
  int id_libro;
  int voto;
  String? commento;
  DateTime data_ultima_modifica;

  Recensione({
    required this.id,
    required this.id_libro,
    required this.id_user,
    required this.voto,
    this.commento,
    required this.data_ultima_modifica,
  });

  factory Recensione.fromJson(Map<String, dynamic> json) =>
      _$RecensioneFromJson(json);

  Map<String, dynamic> toJson() => _$RecensioneToJson(this);
}
