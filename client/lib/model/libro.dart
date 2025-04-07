import 'package:json_annotation/json_annotation.dart';

part 'Recensione.g.dart';

@JsonSerializable()
class Libro {
  int id;
  String titolo;
  String? autore;
  String? descrizione;
  String isbn;
  String? genere;
  DateTime? anno_pubblicazione;

  Libro({
    required this.id,
    required this.titolo,
    this.autore,
    this.descrizione,
    required this.isbn,
    this.genere,
    this.anno_pubblicazione,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => _$LibroFromJson(json);

  Map<String, dynamic> toJson() => _$LibroToJson(this);
}
