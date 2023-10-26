import 'dart:convert';
import 'package:projeto_01_teste/model/usuarios/usuario2_model.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_01_teste/utils/api_response.dart';
import 'package:projeto_01_teste/utils/url.dart';

class EditarPerfilApi {
  static Future<Usuario2> getUsuario() async {
    try {
      var user = await Usuario2.get();
      var url = ('$apiUrl/usuarios/getUsers/${user!.usuId}');

      // var url = ('http://192.168.0.70:3000/usuarios/getUsers/${user!.usuId}');

      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 401) {
        // deslogar
      }
      if (response.statusCode == 200) {
        Usuario2 usuario = Usuario2.fromJson(json.decode(response.body));

        return usuario;
      }
      return Usuario2();
    } catch (error) {
      return Usuario2();
    }
  }

  static Future<ApiResponse<bool>> saveUsuario(Usuario2 usuario) async {
    try {
      var user = await Usuario2.get();
      var url = ('$apiUrl/usuarios/atualizarUsuario/${user!.usuId}');

      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      Map params = {
        "usuNome": usuario.nome,
        "usuEmail": usuario.email,
        "usuTelefone": usuario.telefone,
        "usuCpf": usuario.cpf ?? "",
        "usuCep": usuario.cep ?? "",
        "usuEndereco": usuario.endereco ?? "",
        "usuNumero": usuario.numero ?? "",
      };

      String s = json.encode(params);

      var response = await http.post(Uri.parse(url), body: s, headers: headers);

      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 401) {
        // deslogar
      }
      if (response.statusCode == 200) {
        ///arrrumar
        user.nome = usuario.nome;
        user.email = usuario.email;
        user.telefone = usuario.telefone;
        user.cpf = usuario.cpf;
        user.endereco = usuario.endereco;
        user.numero = usuario.numero;
        user.cep = usuario.cep;

        user.save();

        return ApiResponse.ok(true);
      }
      return ApiResponse.error(mapResponse["mensagem"]);
    } catch (error) {
      return ApiResponse.error(
          "Não foi possível fazer alteração!\nVerifique seus dados.");
    }
  }
/*
  static Future<ApiResponse<bool>> trocarSenha(
      String senha, String senhaNova) async {
    try {
      var user = await Usuario2.get();
      var url = 'https://app.spotway.com.br/v1/trocarsenha';

      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      Map params = {
        "senha_atual": senha,
        "senha_nova": senhaNova,
      };

      String s = json.encode(params);

      var response = await http.post(Uri.parse(url), body: s, headers: headers);

      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 400) {}

      if (response.statusCode == 200) {
        //Usuario user = Usuario.fromJson(mapResponse["internauta"]);

        return ApiResponse.ok(true);
      }

      return ApiResponse.error(mapResponse["error"]);
    } catch (error) {
      return ApiResponse.error("Não foi possível trocar sua senha.");
    }
  }*/
}
