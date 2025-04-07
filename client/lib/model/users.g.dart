// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String?,
      cognome: json['cognome'] as String?,
      username: json['username'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cognome': instance.cognome,
      'username': instance.username,
      'token': instance.token,
    };
