import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages/produto/produtosInd_page.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_api.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_bloc.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_ind.dart';

import '../../model/produtos/produtosModel.dart';
import '../../utils/delitarCaracter.dart'; // Importe o modelo de produtos

class ProdutosADMpage extends StatefulWidget {
  final int catId;

  const ProdutosADMpage({Key? key, required this.catId}) : super(key: key);

  @override
  State<ProdutosADMpage> createState() => _ProdutosADMpageState(catId: catId);
}

class _ProdutosADMpageState extends State<ProdutosADMpage> {
  final int catId;
  List<Produto> produtos = [];
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final ProdutosADMbloc _produtosBloc = ProdutosADMbloc();

  _ProdutosADMpageState({required this.catId});

  @override
  void initState() {
    super.initState();
    _produtosBloc.fetchProdutos(catId);
  }

  Future<void> _refreshData() async {
    await _produtosBloc.fetchProdutos(catId);
  }

  Future<void> _loadCategoriaProdutos() async {
    final success = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutoADMind(
          catId: widget.catId,
        ),
      ),
    );
    if (success == true) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder<List<Produto>>(
            stream: _produtosBloc.streamProdutos,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Produto> produtos = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadCategoriaProdutos,
                    child: const Text('Adicionar Novo produto'),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) {
                        Produto produto = produtos[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => ProdutoADMind(
                                  catId: widget.catId,
                                  proId: produto.pro_id,
                                ),
                              ),
                            )
                                .then((value) {
                              if (value == true) {
                                // A ação de atualização só ocorre se o valor retornado for verdadeiro.
                                _refreshData();
                              }
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 16.0, 0.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white, // Cor de fundo
                                borderRadius: BorderRadius.circular(
                                    10.0), // Borda arredondada
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
                                  /* Container(
                                    width: 80, // Largura da imagem
                                    height: 60,
                                    child: Image.network(
                                      '${produto.pro_foto}',
                                      width:
                                          double.infinity, // Largura da imagem
                                      height: 250, // Altura da imagem
                                      fit: BoxFit.contain, // Ajuste da imagem
                                    ),
                                  ),*/
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          limitarTexto(
                                              '${produto.pro_descricao}',
                                              15), // Limita a 20 caracteres
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'R\$ ${produto.pro_preco}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final classe = produtosADMapi();
                                        final bool produtoExcluido =
                                            await classe.excluirProduto(
                                                produto.pro_id!);
                                        if (produtoExcluido == true) {
                                          // ignore: use_build_context_synchronously
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Produto excluido com sucesso'),
                                                content: const Text(
                                                    'Clique em OK para voltar ao seu pedido.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () async {
                                                      _refreshData();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          // O pedido não pôde ser encerrado, você pode mostrar uma mensagem de erro aqui
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'O produto já foi excluido'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
