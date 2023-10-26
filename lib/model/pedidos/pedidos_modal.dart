import 'package:projeto_01_teste/model/pedidos/pedidos_query_modal.dart';

class Pedidos {
  int? pedId;
  String? pedStatus;
  String? pedData;
  int? usuId;
  Map<String, dynamic>? dadosExtras; // Usar um mapa para armazenar dados extras
  List<ProdutoQuery>? produtos;

  Pedidos({
    this.pedId,
    this.pedStatus,
    this.pedData,
    this.usuId,
    this.dadosExtras,
    this.produtos,
  });

  factory Pedidos.fromJson(Map<String, dynamic> json) {
    // Copie todos os campos do JSON para o mapa de dados extras
    Map<String, dynamic> dadosExtras = Map<String, dynamic>.from(json);

    // Remova os campos que já estão mapeados no modelo
    dadosExtras.remove('ped_id');
    dadosExtras.remove('ped_status');
    dadosExtras.remove('ped_data');
    dadosExtras.remove('usu_id');

    List<dynamic>? pedidoProdutos = json['pedido'];
    List<ProdutoQuery> produtos = [];

    if (pedidoProdutos != null && pedidoProdutos is List) {
      produtos = pedidoProdutos
          .map((produto) => ProdutoQuery.fromJson(produto))
          .toList();
    }

    return Pedidos(
      pedId: json['ped_id'],
      pedStatus: json['ped_status'],
      pedData: json['ped_data'],
      usuId: json['usu_id'],
      dadosExtras: dadosExtras, // Armazena os dados extras
      produtos: produtos,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ped_id'] = this.pedId;
    data['ped_status'] = this.pedStatus;
    data['ped_data'] = this.pedData;
    data['usu_id'] = this.usuId;
    data['pedido'] = this.produtos?.map((produto) => produto.toJson()).toList();

    // Adicione os dados extras ao JSON final
    if (dadosExtras != null) {
      data.addAll(dadosExtras!);
    }

    return data;
  }

  @override
  String toString() {
    return "Pedidos{ped_id: $pedId, ped_status: $pedStatus, ped_data: $pedData, usu_id: $usuId}";
  }
}
