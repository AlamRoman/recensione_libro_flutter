// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'libro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Libro _$LibroFromJson(Map<String, dynamic> json) => Libro(
      id: (json['id'] as num).toInt(),
      titolo: json['titolo'] as String,
      autore: json['autore'] as String?,
      descrizione: json['descrizione'] as String?,
      isbn: json['isbn'] as String,
      genere: json['genere'] as String?,
      anno_pubblicazione:
          Libro._fromJsonDate(json['anno_pubblicazione'] as String?),
    );

Map<String, dynamic> _$LibroToJson(Libro instance) => <String, dynamic>{
      'id': instance.id,
      'titolo': instance.titolo,
      'autore': instance.autore,
      'descrizione': instance.descrizione,
      'isbn': instance.isbn,
      'genere': instance.genere,
      'anno_pubblicazione': Libro._toJsonDate(instance.anno_pubblicazione),
    };
