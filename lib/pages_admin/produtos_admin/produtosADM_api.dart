import 'dart:ffi';

import '../../model/categorias/categorias_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/produtos/produtosModel.dart';
import '../../utils/api_response.dart';
import '../../utils/url.dart';

class produtosADMapi {
  static Future<List<Categorias>> getCategorias() async {
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

  static Future<List<Produto>> getcatProdutos(int catId) async {
    // var url = ('http://192.168.0.70:3000/categorias/${categorias.cat_id}');
    var url = ('$apiUrl/produtos/categorias/${catId}');

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
        List<dynamic> data = jsonResponse['resultado'];

        if (data == null) {
          return []; // Trata o caso em que 'produtos' é null
        }
        List<Produto> produtosList = List<Produto>.from(
          data.map((produto) => Produto.fromJson(produto)),
        );
        return produtosList;
      }

      print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      return []; // Retorna uma lista vazia em caso de erro
    } catch (e) {
      print('Erro na requisição: $e');
      return []; // Retorna uma lista vazia em caso de exceção
    }
  }

  static Future<bool?> criarProduto(int catId, String descricao, double preco,
      String foto, String subDescricao) async {
    final url = Uri.parse('$apiUrl/produtos/categorias/${catId}');

    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final Map<String, dynamic> body = {
      "pro_descricao": descricao,
      "pro_preco": preco,
      "cat_id": catId,
      "pro_foto": foto,
      "pro_subDescricao": subDescricao,
    };

    final jsonBody = jsonEncode(body);

    final response = await http.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 201) {
      print('Produto criado com sucesso');
      return true;
    } else {
      print('Erro ${response.statusCode}: ${response.reasonPhrase}');

      return false;
    }
  }

  static Future<bool?> atualizarProduto(int proId, String decricao,
      double preco, String foto, String subDescricao) async {
    try {
      var url = ('$apiUrl/produtos/$proId');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> params = {
        'pro_descricao': decricao,
        'pro_preco': preco,
        'pro_foto': foto,
        'pro_subDescricao': subDescricao,
      };

      String s = json.encode(params);

      var response = await http.put(Uri.parse(url),
          body: s, headers: headers); // Use put em vez de post

      if (response.statusCode == 200) {
        print('Produto atualizado com sucesso');
        return true;
      } else if (response.statusCode == 400) {
        print('Erro 400: Requisição inválida');
        return false;
      } else {
        print('Erro ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      ApiResponse.error("Não foi possível atualizar os dados: $error");
      return false;
    }
  }

  Future<Produto> getDetalhesProduto(int proId) async {
    final String api =
        '$apiUrl/produtos/atualizar/$proId'; // Substitua pela URL da sua API

    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> produtoMap = data['produto'];

      Produto produto = Produto.fromJson(produtoMap);

      return produto;
    } else {
      throw Exception('Falha ao carregar detalhes da categoria');
    }
  }

  Future<bool> excluirProduto(int produtoId) async {
    final String api = '$apiUrl/produtos/excluir/$produtoId';

    final response = await http.delete(Uri.parse(api));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String mensagem = data['mensagem'];

      if (mensagem == 'Produto excluído com sucesso') {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Falha ao excluir o produto');
    }
  }
}
