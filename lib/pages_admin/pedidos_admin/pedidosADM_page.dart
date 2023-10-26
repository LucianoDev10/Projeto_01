import 'package:flutter/material.dart';
import 'package:projeto_01_teste/model/entregas/entregas_modal.dart';
import 'package:projeto_01_teste/pages_admin/pedidos_admin/pedidosADM_bloc.dart';
import 'package:projeto_01_teste/pages_admin/pedidos_admin/pedidosADM_ind.dart';

import '../../utils/itens_ordenar.dart';

class PedidosADMpage extends StatefulWidget {
  const PedidosADMpage({super.key});

  @override
  State<PedidosADMpage> createState() => _PedidosADMpageState();
}

class _PedidosADMpageState extends State<PedidosADMpage> {
  final PedidosBlocADM _pedidosBloc = PedidosBlocADM();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _pedidosBloc.fetchPedidos();
  }

  Future<void> _refreshData() async {
    await _pedidosBloc.fetchPedidos();
  }

  Future<void> atualizaPedidos() async {
    await _pedidosBloc.fetchPedidos(); // Atualize os dados dos pedidos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos de Entregas'),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder<List<Entregas>>(
          stream: _pedidosBloc.streamNotDestaque,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            List<Entregas> entregas = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: entregas.length,
                    itemBuilder: (context, index) {
                      Entregas entrega = entregas[index];
                      return GestureDetector(
                        onTap: () async {
                          final success = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PedidosADMind(
                                pedidoId: entrega.pedId!,
                                status: entrega.entStatusAdmin!,
                                atualizarPedidos: atualizaPedidos,
                              ),
                            ),
                          );
                          if (success == true) {
                            await _refreshData();
                          }
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white, // Cor de fundo
                            borderRadius: BorderRadius.circular(
                                10.0), // Borda arredondada
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // Sombra
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID do pedido:  ${entrega.entId.toString()}',
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: entrega.entStatusAdmin == 'Aceito'
                                      ? Border.all(
                                          color: Colors.green, width: 2.0)
                                      : Border.all(
                                          color: minhaCorPersonalizada,
                                          width: 2.0),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Status do pedido: ${entrega.entStatusAdmin}',
                                  style: TextStyle(
                                    color: entrega.entStatusAdmin == 'Aceito'
                                        ? Colors.green
                                        : minhaCorPersonalizada,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
