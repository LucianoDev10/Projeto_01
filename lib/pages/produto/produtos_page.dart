import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages/produto/produtosInd_page.dart';

import '../../model/produtos/produtosModel.dart';
import '../../utils/delitarCaracter.dart'; // Importe o modelo de produtos

class ProdutosPage extends StatelessWidget {
  final List<Produto> produtos; // Receba a lista de produtos como parâmetro

  const ProdutosPage({Key? key, required this.produtos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView.builder(
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
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada
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
      ),
    );
  }
}
