import 'package:projeto_01_teste/model/produtos/produtosModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projeto_01_teste/utils/url.dart';

class MelhoresPrecoApi {
  static Future<List<Produto>> getMelhoresPrecos() async {
    var url = ('$apiUrl/produtos/melhoresPrecos/');
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
        print(data);

        List<Produto> produtosList = List<Produto>.from(
            data.map((produto) => Produto.fromJson(produto)));

        print("deu certo");
        print(produtosList);
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
