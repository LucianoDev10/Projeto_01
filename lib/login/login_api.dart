import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_01_teste/utils/url.dart';

import '../model/usuarios/usuario2_model.dart';
import '../utils/api_response.dart';

class LoginApi {
  static Future<ApiResponse<Usuario2>> login(String email, String senha) async {
    try {
      // var url = ('http://localhost:3000/usuarios/login');
      // var url = ('http://10.125.229.17:3000/usuarios/login');
      var url = ('$apiUrl/usuarios/login');
      print([email, senha]);
      print(url);

      Map<String, String> headers = {
        "Content-type": "application/json",
      };
      Map<String, dynamic> params = {
        "email": email,
        "senha": senha,
      };

      String s = json.encode(params);

      var response = await http.post(Uri.parse(url), body: s, headers: headers);

      Map<String, dynamic> mapResponse = json.decode(response.body);
      print(response);

      if (response.statusCode == 401) {
        // fazer logout
        return ApiResponse.error("Email ou senha incorretos");
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> usuarioMap = mapResponse['usuario'];

        Usuario2 user = Usuario2.fromJson(usuarioMap);

        print("deu certo");

        user.save();
        //print(user);

        return ApiResponse.ok(user);
      }

      // Se não for 401 nem 200, retornar erro com a mensagem do JSON
      return ApiResponse.error(mapResponse["mensagem"]);
    } catch (error) {
      return ApiResponse.error(
          "Não foi possível fazer o login. Verifique o seu e-mail e senha.$error");
    }
  }

  static Future<ApiResponse<bool>> cadastrar(Usuario2 usuario) async {
    try {
      var url = '$apiUrl/usuarios/cadastro';

      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      Map<String, String?> requestBody = {
        "nome": usuario.nome,
        "email": usuario.email,
        "telefone": usuario.telefone,
        "endereco": usuario.endereco,
        "numero": usuario.numero,
        "senha": usuario.senha,
      };

      String requestBodyJson = json.encode(requestBody);
      //print('Request Body JSON: $requestBodyJson');

      final response = await http.post(Uri.parse(url),
          body: requestBodyJson, headers: headers);

      Map<String, dynamic> mapResponse2 = json.decode(response.body);

      if (response.statusCode == 401) {
        // Tratar deslogar
        return ApiResponse.error("Não autorizado");
      }

      if (response.statusCode == 200) {
        //print("deu certo");

        Map<String, dynamic> usuarioMap = mapResponse2['usuario'];

        Usuario2 user = Usuario2.fromJson(usuarioMap);

        //print(user);

        user.save();
        return ApiResponse.ok(true);
      }

      final mapResponse = json.decode(response.body);
      return ApiResponse.error(mapResponse["mensagem"]);
    } catch (error) {
      print("Erro durante o cadastro: $error");
      return ApiResponse.error(
          "Não foi possível fazer seu cadastro!\nVerifique seus dados.");
    }
  }

  static Future<ApiResponse<bool>> recuperarSenha(String email) async {
    try {
      Usuario2 user = Usuario2();
      //user.clear(); //limpa o logado
      var url = 'https://10.125.229.217:3000 r/v1/recuperarsenha';

      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      Map params = {"email": email};
      String s = json.encode(params);

      var response = await http.post(Uri.parse(url), body: s, headers: headers);

      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 401) {
        // deslogar
      }

      if (response.statusCode == 200) {
        return ApiResponse.ok(true);
      }

      return ApiResponse.error(mapResponse["error"]);
    } catch (error, exception) {
      return ApiResponse.error(
          "Não foi possível fazer o login!\nVerifique o seu e-mail e senha.");
    }
  }
}
