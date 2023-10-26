import 'dart:async';
import 'package:projeto_01_teste/model/entregas/entregas_modal.dart';
import 'package:projeto_01_teste/pages_admin/pedidos_admin/pedidosADM_api.dart';

class PedidosBlocADM {
  final _streamControllerPedidos = StreamController<List<Entregas>>.broadcast();
  Stream<List<Entregas>> get streamNotDestaque =>
      _streamControllerPedidos.stream;

  fetchPedidos() async {
    try {
      List<Entregas> pedidos = await PedidosADMapi.getPedidos();
      _streamControllerPedidos.add(pedidos);
    } catch (e) {
      _streamControllerPedidos.addError(e);
    }
  }

  void dispose() {
    _streamControllerPedidos.close();
  }
}
