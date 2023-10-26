import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_01_teste/model/categorias/categorias_modal.dart';
import 'package:projeto_01_teste/model/produtos/produtosModel.dart';
import 'package:projeto_01_teste/pages/categorias/categorias_api.dart';
import '../../utils/custom_icons_icons.dart';
import '../../utils/typograph.dart';
import '../../utils/widget_titulo.dart';
import '../produto/produtos_page.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({Key? key}) : super(key: key);

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage>
    with AutomaticKeepAliveClientMixin<CategoriaPage> {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  bool showProgress = false;
  late Future<List<Categorias>> categoriasFuture; // Adicionado

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
  @override
  void initState() {
    super.initState();
    categoriasFuture = CategoriasApi.getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // List<Area> areas;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          //nvabar
          SliverAppBar(
            elevation: 1.0,
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/images/paint_result.png',
              fit: BoxFit.cover,
              width: 110,
            ),
            floating: true,
            titleSpacing: 16,
            actions: [
              IconButton(
                onPressed: () {
                  //showSearch(context: context, delegate: SearchPage());
                },
                tooltip: 'Buscar',
                icon: const Icon(
                  CustomIcons.magnifying_glass,
                  size: 20,
                  color: Colors.black,
                ),
                // color: Colors.black,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CustomIcons.bell,
                  size: 20,
                ),
                color: Colors.black,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              //box titulo + busca + encontre segmentos
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Titulo(texto: "Categorias"),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: corCardAmarelo),
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                          const Text(
                            "Encontre os melhores preços da sua cidade",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            width: 155,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.black45,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ver preços",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  CustomIcons.chevron_right,
                                  color: Colors.white,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(top: 18),
                        child: Image.asset(
                          'assets/images/app-min.png',
                          fit: BoxFit.cover,
                          width: 150,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16.0,
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<Categorias>>(
              future: categoriasFuture, // Usar a Future carregada
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(30),
                    child: const Center(
                      child: Text(
                        'Não foi possível carregar as categorias',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.all(30),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(30),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  );
                }

                List<Categorias> categorias = snapshot.data!;

                return Container(
                  width: double.infinity,
                  color: const Color(0xffDFE7EB),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      Categorias categoria = categorias[index];

                      return Container(
                        margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Cor de fundo do contêiner branco
                          borderRadius: BorderRadius.circular(
                              8.0), // Raio de borda para arredondar
                        ),

                        // Cor de fundo do contêiner branco
                        child: ListTile(
                          title: Row(
                            children: [
                              FaIcon(
                                iconsList[index], // Ícone selecionado da lista
                                size: 20.0,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                categoria.cat_nome ?? '',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onTap: () {
                            _onCategoriaTapped(categoria);
                          },
                        ),
                      );
                    },
                    itemCount: categorias.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      categoriasFuture = CategoriasApi.getCategorias();
    });
  }

  Future<void> _onCategoriaTapped(Categorias categoria) async {
    List<Produto> produtos = await CategoriasApi.getcatProtutos(categoria);

    // Navega para a página de produtos
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProdutosPage(produtos: produtos),
      ),
    );
  }
}
