import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Recensione {
  int id;
  String titolo;
  String? autore;
  String? descrizione;
  String isbn;
  String? genere;
  DateTime? anno_pubblicazione;

  Recensione({
    required this.id,
    required this.titolo,
    this.autore,
    this.descrizione,
    required this.isbn,
    this.genere,
    this.anno_pubblicazione,
  });

  factory Recensione.fromJson(Map<String, dynamic> json) =>
      _$RecensioneFromJson(json);

  Map<String, dynamic> toJson() => _$RecensioneToJson(this);
}
