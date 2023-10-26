import 'dart:convert';
import 'package:projeto_01_teste/model/usuarios/usuario2_model.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_01_teste/utils/url.dart';
import '../../model/pedidos/pedidos_modal.dart';
import '../../model/pedidos/pedidos_query_modal.dart';

class PedidosApi {
  static Future<List<Pedidos>> getPedidos() async {
    var user = await Usuario2.get();
    // var user2 = user?.usuId ?? '';
    var url = ('$apiUrl/pedidos/${user!.usuId}');
    // var url = ('http://192.168.0.70:3000/pedidos/${user!.usuId}');
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

        List<Pedidos> produtosList = List<Pedidos>.from(
            data.map((produto) => Pedidos.fromJson(produto)));

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

// AQUI SEMPRE RETORNA UM PEDIDO EM ANDAMENTO
  static Future<Pedidos?> getPedidoEmAndamento() async {
    var user = await Usuario2.get();
    // var url =('http://192.168.0.70:3000/pedidos/pedidoAndamento/${user!.usuId}');
    var url = ('$apiUrl/pedidos/pedidoAndamento/${user!.usuId}');

    try {
      var response = await http.post(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> pedidoData = data['pedido'];
        final Pedidos pedido = Pedidos.fromJson(pedidoData);
        return pedido;
      } else if (response.statusCode == 404) {
        // Se não houver um pedido em andamento, retorne null
        return null;
      } else {
        // Handle outros códigos de status de acordo com sua API
        throw Exception('Erro ao buscar pedido em andamento');
      }
    } catch (e) {
      // Handle erros de requisição, como conexão perdida, etc.
      throw Exception('Erro ao buscar pedido em andamento: $e');
    }
  }

// AQUI ADICIONAMOS UM PRODUTO AO PEDIDO
  static Future<bool?> adicionarProdutoAoPedido(
      int pedidoId, int produtoId) async {
    //var url =('http://192.168.0.70:3000/pedidos/produtos/$pedidoId/$produtoId');
    var url = ('$apiUrl/pedidos/produtos/$pedidoId/$produtoId');

    try {
      var response = await http.post(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        // Se não houver um pedido em andamento, retorne null
        return false;
      } else {
        // Handle outros códigos de status de acordo com sua API
        throw Exception('Erro ao buscar pedido em andamento');
      }
    } catch (e) {
      // Handle erros de requisição, como conexão perdida, etc.
      throw Exception('Erro ao adicionar pedido: $e');
    }
  }

// AQUI RETORNAMOS OS DADOS DOS PEDIDOS
  Future<List<ProdutoQuery>> getPedidosQuery(int pedidoId) async {
    var url = ('$apiUrl/pedidos/pedidosInd/$pedidoId');
    // var url = ('http://192.168.0.70:3000/pedidos/pedidosInd/$pedidoId');
    Map<String, String> headers = {
      "Content-type": "application/json",
    };

    try {
      var response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 401) {
        print('Erro 401: Não autorizado');
        return []; // Retorna uma lista vazia em caso de erro
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Modificação: Acesse o objeto "pedido" que contém a lista de pedidos
        List<dynamic> data = jsonResponse['pedido'];

        List<ProdutoQuery> produtosList = List<ProdutoQuery>.from(
          data.map((produto) => ProdutoQuery.fromJson(produto)),
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

// AQUI CONCLUIMOS UM PEDIDO
  Future<bool?> PedidoEncerrado(int PedidoId) async {
    // var url = ('http://192.168.0.70:3000/pedidos/pedidoEncerrado/$PedidoId');
    var url = ('$apiUrl/pedidos/pedidoEncerrado/$PedidoId');

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

  Future<bool?> PedidoProdutoExcluido(
      int PPid, int PedidoId, int produtoId) async {
    //  var url =('http://192.168.0.70:3000/produtos/excluirProduto/$PPid/$PedidoId/$produtoId');
    var url = ('$apiUrl/produtos/excluirProduto/$PPid/$PedidoId/$produtoId');

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
      if (response.statusCode == 202) {
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
