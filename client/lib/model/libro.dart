import 'package:json_annotation/json_annotation.dart';

part 'libro.g.dart';

@JsonSerializable()
class Libro {
  int id;
  String titolo;
  String? autore;
  String? descrizione;
  String isbn;
  String? genere;

  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
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

  static DateTime? _fromJsonDate(String? date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date); // expects 'yyyy-MM-dd' or ISO 8601
    } catch (_) {
      // Try other formats if needed
      return null;
    }
  }

  static String? _toJsonDate(DateTime? date) => date?.toIso8601String();
}
