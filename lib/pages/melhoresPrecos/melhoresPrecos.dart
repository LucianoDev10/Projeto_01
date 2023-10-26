import 'package:flutter/material.dart';

import '../../model/produtos/produtosModel.dart';
import '../../utils/delitarCaracter.dart';
import '../produto/produtosInd_page.dart';
import 'melhoresPrecos_bloc.dart';

class MelhoresPrecosPage extends StatefulWidget {
  const MelhoresPrecosPage({super.key});

  @override
  State<MelhoresPrecosPage> createState() => _MelhoresPrecosState();
}

class _MelhoresPrecosState extends State<MelhoresPrecosPage> {
  final ProdutoBloc _ProdutoBloc = ProdutoBloc();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _ProdutoBloc.fetchProdutos();
  }

  Future<void> _refreshData() async {
    await _ProdutoBloc.fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Melhores Preços'),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder<List<Produto>>(
          stream: _ProdutoBloc.streamNotDestaque,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            List<Produto> produtos = snapshot.data!;

            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                Produto produto = produtos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProdutoInd(produto: produto),
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                        Container(
                          width: 80, // Largura da imagem
                          height: 60,
                          child: Image.network(
                            '${produto.pro_foto}',
                            width: double.infinity, // Largura da imagem
                            height: 250, // Altura da imagem
                            fit: BoxFit.contain, // Ajuste da imagem
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                limitarTexto('${produto.pro_descricao}',
                                    15), // Limita a 20 caracteres
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight
                                      .bold, // Pode ser FontWeight.bold para negrito, se desejar
                                  color: Colors.black, // Cor do texto
                                  // Outras propriedades de estilo de fonte podem ser adicionadas aqui
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
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ProdutoBloc.dispose();
    super.dispose();
  }
}
