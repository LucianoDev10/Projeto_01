import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidosInd_page.dart';
import '../../utils/itens_ordenar.dart';
import 'pedidos_bloc.dart';
import '../../model/pedidos/pedidos_modal.dart';
import 'package:intl/intl.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final PedidosBloc _pedidosBloc = PedidosBloc();
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

  String _formatDate(String inputDate) {
    // Converte a data de "2023-10-09 23:34:52" para um objeto DateTime
    final parsedDate = DateTime.parse(inputDate);

    // Formata a data para o formato "dd/MM/yyyy"
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Page'),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder<List<Pedidos>>(
          stream: _pedidosBloc.streamNotDestaque,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            List<Pedidos> pedidos = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      Pedidos pedido = pedidos[index];
                      return GestureDetector(
                        onTap: () async {
                          final sucess = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PedidosIndPage(
                                pedidoId: pedido.pedId!,
                                pedidoStatus: pedido.pedStatus ?? "",
                                atualizarPedidos: atualizaPedidos,
                              ),
                            ),
                          );
                          if (sucess == true) {
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
                                'Data do pedido:  ${_formatDate(pedido.pedData ?? "")}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: pedido.pedStatus == 'Encerrado'
                                      ? Border.all(
                                          color: Colors.green, width: 2.0)
                                      : Border.all(
                                          color: minhaCorPersonalizada,
                                          width: 2.0),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Status do pedido: ${pedido.pedStatus}',
                                  style: TextStyle(
                                    color: pedido.pedStatus == 'Encerrado'
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

  @override
  void dispose() {
    _pedidosBloc.dispose();
    super.dispose();
  }
}
