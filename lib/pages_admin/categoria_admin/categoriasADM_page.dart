import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_01_teste/model/categorias/categorias_modal.dart';

import 'categoriasADM_api.dart';
import 'categoriasADM_bloc.dart';
import 'categoriasADM_ind.dart';

class CategoriasADMpage extends StatefulWidget {
  const CategoriasADMpage({Key? key}) : super(key: key);

  @override
  State<CategoriasADMpage> createState() => _CategoriasADMpageState();
}

class _CategoriasADMpageState extends State<CategoriasADMpage> {
  final CategoriasADMbloc _categoriasBloc = CategoriasADMbloc();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _categoriasBloc.fetchCategorias();
  }

  Future<void> _refreshData() async {
    await _categoriasBloc.fetchCategorias();
  }

  final List<IconData> iconsList = [
    FontAwesomeIcons.iceCream,
    FontAwesomeIcons.memory,
    FontAwesomeIcons.water,
    FontAwesomeIcons.bacon,
    FontAwesomeIcons.bowlFood,
    FontAwesomeIcons.broom,
    FontAwesomeIcons.coffee,
    FontAwesomeIcons.hotdog,
    FontAwesomeIcons.lemon,
    FontAwesomeIcons.magnifyingGlassDollar,
  ];

  Future<void> _navigateToCategoriaPage() async {
    final success = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriaADMind(),
      ),
    );

    if (success == true) {
      await _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Categorias Admin',
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder<List<Categorias>>(
          stream: _categoriasBloc.streamNotDestaque,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Categorias> categorias = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToCategoriaPage,
                  child: const Text('Adicionar Nova Categoria'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      Categorias categoria = categorias[index];
                      return Container(
                        margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              FaIcon(
                                iconsList[index],
                                size: 20.0,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                categoria.cat_nome ?? '',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final classe = categoriasADMapi();
                                    final bool produtoExcluido = await classe
                                        .excluirCategoria(categoria.cat_id!);
                                    if (produtoExcluido == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Categoria excluido com sucesso'),
                                            content: const Text(
                                                'Clique em OK para voltar ao seu pedido.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('OK'),
                                                onPressed: () async {
                                                  _refreshData();
                                                  Navigator.of(context).pop();
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
                                          content:
                                              Text('O produto já foi excluido'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  })
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoriaADMind(categoria: categoria),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _categoriasBloc.dispose();
    super.dispose();
  }
}
