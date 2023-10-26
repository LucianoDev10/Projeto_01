import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../model/produtos/produtosModel.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_api.dart'; // Importe a função para criar pedidos

class ProdutoInd extends StatelessWidget {
  final Produto produto; // Produto recebido como argumento

  ProdutoInd({Key? key, required this.produto}) : super(key: key);

  Future<void> _adicionarAoCarrinho(
      BuildContext context, Produto produto) async {
    try {
      // Verifica se o usuário possui um pedido em andamento
      final pedidoEmAndamento = await PedidosApi.getPedidoEmAndamento();

      final resultado = await PedidosApi.adicionarProdutoAoPedido(
          pedidoEmAndamento!.pedId!, produto.pro_id!);

      if (resultado == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto adicionado ao pedido'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao adicionar ao carrinho'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.network(
                      '${produto.pro_foto}',
                      width: double.infinity, // Largura da imagem
                      height: 250, // Altura da imagem
                      fit: BoxFit.contain, // Ajuste da imagem
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      ' ${produto.pro_descricao}',
                      style: const TextStyle(
                          color: Color.fromARGB(200, 0, 0, 0),
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: Text(
                      '${produto.pro_subDescricao}',
                      style: const TextStyle(
                        color: Color.fromARGB(200, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preço: ${produto.pro_preco.toString()}',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _adicionarAoCarrinho(context, produto);
                  },
                  child: Text('Adicionar ao Carrinho'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
