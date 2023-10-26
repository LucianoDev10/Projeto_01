import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:projeto_01_teste/model/entregas/entregas_modal.dart';

import '../../utils/url.dart';

class PedidosADMapi {
  static Future<List<Entregas>> getPedidos() async {
    var url = ('$apiUrl/entregas/');
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

        List<Entregas> produtosList = List<Entregas>.from(
            data.map((produto) => Entregas.fromJson(produto)));

        return produtosList;
      }

      print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      return []; // Retorna uma lista vazia em caso de erro
    } catch (e) {
      print('Erro na requisição: $e');
      return []; // Retorna uma lista vazia em caso de exceção
    }
  }

  Future<bool?> PedidoEncerrado(int PedidoId) async {
    // var url = ('http://192.168.0.70:3000/pedidos/pedidoEncerrado/$PedidoId');
    var url = ('$apiUrl/entregas/Encerrado/$PedidoId');

    Map<String, String> headers = {
      "Content-type": "application/json",
    };

    try {
      var response = await http.post(Uri.parse(url), headers: headers);
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 401) {
        print('Erro 401: Não autorizado');
        return false; // Retorna uma lista vazia em caso de erro
      }
      if (response.statusCode == 400) {
        print('O pedido já está encerrado');
        return false; // Retorna uma lista vazia em caso de erro
      }
      if (response.statusCode == 200) {
        return true;
      }

      print('Erro ${response.statusCode}: ${response.reasonPhrase}');
      return false; // Retorna uma lista vazia em caso de erro
    } catch (e) {
      print('Erro na requisição: $e');
      return false; // Retorna uma lista vazia em caso de exceção
    }
  }
}
