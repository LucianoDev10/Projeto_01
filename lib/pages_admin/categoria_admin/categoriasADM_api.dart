import 'package:projeto_01_teste/utils/url.dart';

import '../../model/categorias/categorias_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/api_response.dart';

class categoriasADMapi {
  static Future<List<Categorias>> getCategorias() async {
    //var url = ('http://10.125.229.17:3000/categorias/');
    var url = ('$apiUrl/categorias/');

    Map<String, String> headers = {
      "Content-type": "application/json",
    };

    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 401) {
        print('Erro 401: Não autorizado');
        return []; // Retorna uma lista vazia em caso de erro
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['response'];
        List<Categorias> categoriasList = List<Categorias>.from(
            data.map((categoria) => Categorias.fromJson(categoria)));

        print("deu certo");
        print(categoriasList);
        return categoriasList;
      }

      print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      return []; // Retorna uma lista vazia em caso de erro
    } catch (e) {
      print('Erro na requisição: $e');
      return []; // Retorna uma lista vazia em caso de exceção
    }
  }

  static Future<bool?> criarCategoria(String catNome, String catIcons) async {
    try {
      var url = ('$apiUrl/categorias/');

      // var url = ('http://192.168.0.70:3000/categorias/');

      Map<String, String> headers = {
        "Content-type": "application/json",
      };
      Map<String, dynamic> params = {
        'cat_nome': catNome,
        'cat_icons': catIcons,
      };

      String s = json.encode(params);

      var response = await http.post(Uri.parse(url), body: s, headers: headers);

      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        // Categoria criada com sucesso
        print('Categoria criada com sucesso');
        return true;
      } else if (response.statusCode == 400) {
        // Trate o erro 400 (Bad Request) aqui, se necessário
        print('Erro 400: Requisição inválida');
        return false;
      } else {
        // Trate outros códigos de status aqui, se necessário
        print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      }
      return false;
    } catch (error) {
      ApiResponse.error("Não foi possível adicionar os novos dados.$error");
      return false;
    }
  }

  static Future<bool?> atualizarCategoria(
      int categoriaId, String catNome, String catIcons) async {
    try {
      //  var url = 'http://10.125.229.17:3000/categorias/$categoriaId';
      var url = ('$apiUrl/categorias/$categoriaId');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> params = {
        'cat_nome': catNome,
        'cat_icons': catIcons,
      };

      String s = json.encode(params);

      var response = await http.put(Uri.parse(url),
          body: s, headers: headers); // Use put em vez de post

      if (response.statusCode == 200) {
        // Categoria atualizada com sucesso
        print('Categoria atualizada com sucesso');
        return true;
      } else if (response.statusCode == 400) {
        // Trate o erro 400 (Bad Request) aqui, se necessário
        print('Erro 400: Requisição inválida');
        return false;
      } else {
        // Trate outros códigos de status aqui, se necessário
        print('Erro ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      ApiResponse.error("Não foi possível atualizar os dados: $error");
      return false;
    }
  }

// ATUALIZAR DADOS INDIVIDUAIS
  Future<Categorias> getDetalhesCategoria(int categoriaId) async {
    final String api =
        '$apiUrl/categorias/atualizar/$categoriaId'; // Substitua pela URL da sua API

    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> categoriaMap = data['categoria'];

      // Crie uma instância de Categorias com base nos dados do mapa
      Categorias categoria = Categorias.fromJson(categoriaMap);

      return categoria;
    } else {
      throw Exception('Falha ao carregar detalhes da categoria');
    }
  }

  Future<bool> excluirCategoria(int categoriaId) async {
    final String api = '$apiUrl/categorias/excluir/$categoriaId';

    final response = await http.delete(Uri.parse(api));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String mensagem = data['mensagem'];

      if (mensagem == 'Categoria excluída com sucesso') {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Falha ao excluir a categoria');
    }
  }
}
