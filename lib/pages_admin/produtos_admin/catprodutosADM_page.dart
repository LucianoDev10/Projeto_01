import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_bloc.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_page.dart';

import '../../model/categorias/categorias_modal.dart';

class CatprodutoADMPage extends StatefulWidget {
  const CatprodutoADMPage({super.key});

  @override
  State<CatprodutoADMPage> createState() => _CatprodutoADMPageState();
}

class _CatprodutoADMPageState extends State<CatprodutoADMPage> {
  final ProdutosADMbloc _categoriasBloc = ProdutosADMbloc();

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _categoriasBloc.fetchCategorias();
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

  Future<void> _refreshData() async {
    await _categoriasBloc.fetchCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Produtos Admin',
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
                const Text(
                  'Escolha a categoria',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProdutosADMpage(catId: categoria.cat_id!),
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
}
