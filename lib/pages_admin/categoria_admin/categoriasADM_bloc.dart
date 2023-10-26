import 'dart:async';

import 'package:projeto_01_teste/model/categorias/categorias_modal.dart';
import 'package:projeto_01_teste/pages_admin/categoria_admin/categoriasADM_api.dart';

class CategoriasADMbloc {
  final _streamControllerCategorias =
      StreamController<List<Categorias>>.broadcast();
  Stream<List<Categorias>> get streamNotDestaque =>
      _streamControllerCategorias.stream;

  fetchCategorias() async {
    try {
      List<Categorias> categorias = await categoriasADMapi.getCategorias();
      _streamControllerCategorias.add(categorias);
    } catch (e) {
      _streamControllerCategorias.addError(e);
    }
  }

  void dispose() {
    _streamControllerCategorias.close();
  }
}
