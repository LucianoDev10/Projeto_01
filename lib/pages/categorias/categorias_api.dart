import 'package:http/http.dart' as http;
import 'package:projeto_01_teste/model/produtos/produtosModel.dart';
import 'package:projeto_01_teste/utils/url.dart';
import 'dart:convert';

import '../../model/categorias/categorias_modal.dart';

class CategoriasApi {
  static Future<List<Categorias>> getCategorias() async {
    var url = ('$apiUrl/categorias/');
    //var url = ('http://192.168.0.70:3000/categorias/');

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

  static Future<List<Produto>> getcatProtutos(Categorias categorias) async {
    // var url = ('http://192.168.0.70:3000/categorias/${categorias.cat_id}');
    var url = ('$apiUrl/categorias/${categorias.cat_id}');

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
            data.map((produto) => Produto.fromJson(produto)));
        return produtosList;
      }

      print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      return []; // Retorna uma lista vazia em caso de erro
    } catch (e) {
      print('Erro na requisição: $e');
      return []; // Retorna uma lista vazia em caso de exceção
    }
  }
}
