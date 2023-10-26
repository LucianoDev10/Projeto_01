import 'dart:async';
import 'package:projeto_01_teste/model/pedidos/pedidos_modal.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_api.dart';

class PedidosBloc {
  final _streamControllerPedidos = StreamController<List<Pedidos>>.broadcast();
  Stream<List<Pedidos>> get streamNotDestaque =>
      _streamControllerPedidos.stream;

  fetchPedidos() async {
    try {
      List<Pedidos> pedidos = await PedidosApi.getPedidos();
      _streamControllerPedidos.add(pedidos);
    } catch (e) {
      _streamControllerPedidos.addError(e);
    }
  }

  void dispose() {
    _streamControllerPedidos.close();
  }
}
