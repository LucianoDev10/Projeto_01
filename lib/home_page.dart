import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages/categorias/categorias_page.dart';
import 'package:projeto_01_teste/pages/melhoresPrecos/melhoresPrecos.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_page.dart';
import 'package:projeto_01_teste/pages/perfil/EditarPerfil.dart';
import 'package:projeto_01_teste/utils/custom_icons_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final List<Widget> _telas = [
    const CategoriaPage(),
    const MelhoresPrecosPage(),
    const PedidosPage(),
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
              icon: Icon(CustomIcons.store),
              label: "Produtos",
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.basket_shopping),
              label: "Melhores Preços",
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
