import 'dart:async';

import 'package:projeto_01_teste/model/categorias/categorias_modal.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_api.dart';

import '../../model/produtos/produtosModel.dart';

class ProdutosADMbloc {
  final _streamControllerCategorias =
      StreamController<List<Categorias>>.broadcast();
  Stream<List<Categorias>> get streamNotDestaque =>
      _streamControllerCategorias.stream;

  final _streamControllerProdutos = StreamController<List<Produto>>.broadcast();
  Stream<List<Produto>> get streamProdutos => _streamControllerProdutos.stream;

  fetchCategorias() async {
    try {
      List<Categorias> categorias = await produtosADMapi.getCategorias();
      _streamControllerCategorias.add(categorias);
    } catch (e) {
      _streamControllerCategorias.addError(e);
    }
  }

  fetchProdutos(int catId) async {
    try {
      List<Produto> produtos = await produtosADMapi.getcatProdutos(catId);
      _streamControllerProdutos.add(produtos);
    } catch (e) {
      _streamControllerProdutos.addError(e);
    }
  }

  void dispose() {
    _streamControllerCategorias.close();
    _streamControllerProdutos.close();
  }
}
