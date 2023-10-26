import 'dart:convert' as convert;

import '../../utils/prefs.dart';

class Usuario2 {
  int? usuId;
  String? nome;
  String? email;
  String? cpf;
  String? telefone;
  String? endereco;
  String? numero;
  String? cep;
  String? senha;
  String? tipo;

  Usuario2(
      {this.usuId,
      this.nome,
      this.email,
      this.cpf,
      this.telefone,
      this.endereco,
      this.numero,
      this.cep,
      this.senha,
      this.tipo});

  Usuario2.fromJson(Map<String, dynamic> json) {
    usuId = json['usu_id'];
    nome = json['usu_nome'];
    email = json['usu_email'];
    cpf = json['usu_cpf'];
    telefone = json['usu_telefone'];
    endereco = json['usu_endereco'];
    numero = json['usu_numero'];
    cep = json['usu_cep'];
    senha = json['usu_senha'];
    tipo = json['usu_tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['usu_id'] = this.usuId;
    data['usu_nome'] = this.nome;
    data['usu_email'] = this.email;
    data['usu_cpf'] = this.cpf;
    data['usu_telefone'] = this.telefone;
    data['usu_endereco'] = this.endereco;
    data['usu_numero'] = this.numero;
    data['usu_cep'] = this.cep;
    data['usu_senha'] = this.senha;
    data['usu_tipo'] = this.tipo;

    return data;
  }

  void clear() {
    Prefs.setString("user.prefs", "");
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static Future<Usuario2?> get() async {
    String json = await Prefs.getString("user.prefs");
    if (json.isEmpty) {
      return null;
    }
    print(json);

    Map<String, dynamic> map = convert.json.decode(json);

    Usuario2 user = Usuario2.fromJson(map);

    return user;
  }

  @override
  String toString() {
    return "Usuario{nome: $nome, email: $email, telefone: $telefone,  cep: $cep, endereco: $endereco, cpf:$cpf, senha: $senha, tipo:$tipo}";
  }
}
