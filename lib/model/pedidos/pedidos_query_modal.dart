class ProdutoQuery {
  int? proId;
  int? pepId;
  String? proDescricao;
  double? proPreco;
  String? pepFrete;
  String? proFoto;

  ProdutoQuery(
      {this.proId,
      this.pepId,
      this.proDescricao,
      this.proPreco,
      this.pepFrete,
      this.proFoto});

  ProdutoQuery.fromJson(Map<String, dynamic> json) {
    proId = json['pro_id'];
    pepId = json['pep_id'];
    proDescricao = json['pro_descricao'];
    proPreco = double.parse(json['pro_preco']);
    pepFrete = json['pep_frete'];
    proFoto = json['pro_foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_id'] = this.proId;
    data['pep_id'] = this.pepId;
    data['pro_descricao'] = this.proDescricao;
    data['pro_preco'] = this.proPreco;
    data['pep_frete'] = this.pepFrete;
    data['pro_foto'] = this.proFoto;
    return data;
  }
}
