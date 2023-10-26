import 'dart:async';

import 'package:projeto_01_teste/model/produtos/produtosModel.dart';
import 'package:projeto_01_teste/pages/melhoresPrecos/melhoresPrecos_api.dart';

class ProdutoBloc {
  final _streamControllerProdutos = StreamController<List<Produto>>.broadcast();
  Stream<List<Produto>> get streamNotDestaque =>
      _streamControllerProdutos.stream;

  fetchProdutos() async {
    try {
      List<Produto> Produtos = await MelhoresPrecoApi.getMelhoresPrecos();
      _streamControllerProdutos.add(Produtos);
    } catch (e) {
      _streamControllerProdutos.addError(e);
    }
  }

  void dispose() {
    _streamControllerProdutos.close();
  }
}
