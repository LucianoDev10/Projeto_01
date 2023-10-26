import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages_admin/categoria_admin/categoriasADM_page.dart';
import 'package:projeto_01_teste/pages_admin/pedidos_admin/pedidosADM_page.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/catprodutosADM_page.dart';

import '../pages/perfil/EditarPerfil.dart';
import '../utils/custom_icons_icons.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final PageController _pageController = PageController();
  final List<Widget> _telas = [
    const CategoriasADMpage(),
    const CatprodutoADMPage(),
    const PedidosADMpage(),
    EditarPerfilPage()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _telas,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Define o tipo como fixed

          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.basket_shopping),
              label: "Categorias",
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.store),
              label: "Produtos",
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.newspaper),
              label: "Pedidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.user),
              label: "Meu perfil",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
