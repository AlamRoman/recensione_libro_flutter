// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recensione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recensione _$RecensioneFromJson(Map<String, dynamic> json) => Recensione(
      id: (json['id'] as num).toInt(),
      id_libro: (json['id_libro'] as num).toInt(),
      id_user: (json['id_user'] as num).toInt(),
      voto: Recensione._parseVoto(json['voto']),
      commento: json['commento'] as String?,
      data_ultima_modifica:
          Recensione._fromJsonDate(json['data_ultima_modifica'] as String?),
    );

Map<String, dynamic> _$RecensioneToJson(Recensione instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.id_user,
      'id_libro': instance.id_libro,
      'voto': Recensione._encodeVoto(instance.voto),
      'commento': instance.commento,
      'data_ultima_modifica':
          Recensione._toJsonDate(instance.data_ultima_modifica),
    };
