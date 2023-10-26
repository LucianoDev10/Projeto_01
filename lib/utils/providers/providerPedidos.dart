import 'package:flutter/material.dart';
import 'package:projeto_01_teste/model/pedidos/pedidos_modal.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_api.dart';

class PedidosProvider extends ChangeNotifier {
  List<Pedidos> _pedidos = [];

  List<Pedidos> get pedidos => _pedidos;

  Future<void> fetchPedidos() async {
    try {
      List<Pedidos> pedidos = await PedidosApi.getPedidos();
      _pedidos = pedidos;
      notifyListeners(); // Notifica os ouvintes sobre a mudança nos pedidos
    } catch (error) {
      // Trate os erros, se necessário
    }
  }
}
