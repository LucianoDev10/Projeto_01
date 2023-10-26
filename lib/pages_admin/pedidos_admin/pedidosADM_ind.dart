import 'package:flutter/material.dart';
import 'package:projeto_01_teste/model/pedidos/pedidos_modal.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_api.dart';
import 'package:projeto_01_teste/pages_admin/pedidos_admin/pedidosADM_api.dart';

import '../../model/pedidos/pedidos_query_modal.dart';
import '../../utils/delitarCaracter.dart';

class PedidosADMind extends StatefulWidget {
  final int pedidoId;
  final String status;
  final Function() atualizarPedidos;

  PedidosADMind({
    Key? key,
    required this.pedidoId,
    required this.status,
    required this.atualizarPedidos,
  }) : super(key: key);

  @override
  _PedidosADMindState createState() => _PedidosADMindState();
}

class _PedidosADMindState extends State<PedidosADMind> {
  late Future<List<Pedidos>> _pedidoDetails;
  final PedidosApi apiService = PedidosApi();

  @override
  void initState() {
    super.initState();
    _pedidoDetails = getPedidos(widget.pedidoId);
  }

  Future<List<Pedidos>> getPedidos(int pedidoId) async {
    List<ProdutoQuery> produtosQuery =
        await apiService.getPedidosQuery(pedidoId);

    // Agora, você pode criar uma lista de Pedidos com base nos dados de ProdutoQuery
    List<Pedidos> pedidosList = produtosQuery.map((produto) {
      // Use os dados de ProdutoQuery e adicione a variável desejada
      return Pedidos(
        pedId: pedidoId, // Preencha com o ID do pedido
        pedStatus: '', // Preencha com o status desejado
        pedData: '', // Preencha com a data desejada
        usuId: 0, // Preencha com o ID do usuário desejado
        dadosExtras: {
          'pro_id': produto.proId,
          'pep_id': produto.pepId,
          'pro_descricao': produto.proDescricao,
          'pro_preco': produto.proPreco,
          'pep_frete': produto.pepFrete,
          'pro_foto': produto.proFoto,
        },
        produtos: [produto], // Adicione o ProdutoQuery à lista de produtos
      );
    }).toList();

    return pedidosList;
  }

  void _atualizarPagina() async {
    final updatedPedidos = await getPedidos(widget.pedidoId);

    setState(() {
      _pedidoDetails = Future.value(updatedPedidos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido '),
      ),
      body: FutureBuilder<List<Pedidos>>(
        future: _pedidoDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Nenhum detalhe encontrado');
          } else {
            // Exiba os detalhes do pedido com base em snapshot.data
            List<Pedidos> detalhes = snapshot.data!;
            double somaTotal = 0.0;
            for (var pedido in detalhes) {
              if (pedido.dadosExtras != null &&
                  pedido.dadosExtras!.containsKey('pro_preco')) {
                somaTotal +=
                    double.parse(pedido.dadosExtras!['pro_preco'].toString());
              }
            }
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: const Text("Produtos a ser entregue:",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: detalhes.length,
                    itemBuilder: (context, index) {
                      Pedidos pedido = detalhes[index];
                      Map<String, dynamic>? dadosExtras =
                          pedido.dadosExtras; // Acesse os dados extras

                      return Container(
                        margin:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Cor de fundo
                          borderRadius:
                              BorderRadius.circular(10.0), // Borda arredondada
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Sombra
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/onde-comer.webp', // URL da imagem do banco de dados
                              width: 80, // Largura da imagem
                              height: 60, // Altura da imagem
                              fit: BoxFit.cover, // Ajuste da imagem
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    limitarTexto(
                                        '${dadosExtras?['pro_descricao'] ?? ''}',
                                        15), // Limita a 20 caracteres
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight
                                          .bold, // Pode ser FontWeight.bold para negrito, se desejar
                                      color: Colors.black, // Cor do texto
                                      // Outras propriedades de estilo de fonte podem ser adicionadas aqui
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'R\$ ${dadosExtras?['pro_preco']}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 12, 16),
                  color: Colors.white,
                  // Defina a cor de fundo desejada
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight
                              .bold, // Pode ser FontWeight.bold para negrito, se desejar
                          color: Colors.black,
                        ),
                      ),
                      widget.status != 'Aceito'
                          ? ElevatedButton(
                              onPressed: () async {
                                final classe = PedidosADMapi();
                                final bool? pedidoEncerrado =
                                    await classe.PedidoEncerrado(
                                        widget.pedidoId);
                                if (pedidoEncerrado == true) {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Pedido despachado com sucesso!'),
                                        content: const Text(
                                            'Clique em OK para voltar à página anterior.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              // Chame a função para atualizar os pedidos
                                              widget.atualizarPedidos();
                                              Navigator.pop(context, true);
                                              Navigator.pop(context,
                                                  true); // Volte para a página principal
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('O pedido já está encerrado'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Concluir Pedido',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight
                                      .bold, // Pode ser FontWeight.bold para negrito, se desejar
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.centerRight,
                              child: const Text(
                                'Pedido despachado com sucesso!',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                    ],
                  ),
                ),
                // Adicione espaçamento abaixo do botão, se necessário
              ],
            );
          }
        },
      ),
    );
  }
}
