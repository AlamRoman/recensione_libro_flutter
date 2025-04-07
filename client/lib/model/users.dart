import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';

@JsonSerializable()
class Users {
  int id;
  String? nome;
  String? cognome;
  String username;
  String? token;

  Users({
    required this.id,
    this.nome,
    this.cognome,
    required this.username,
    this.token,
  });

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
