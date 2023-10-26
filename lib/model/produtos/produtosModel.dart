class Produto {
  int? pro_id;
  String? pro_descricao;
  String? pro_foto;
  String? pro_subDescricao;
  double? pro_preco;
  int? pro_qtd;
  int? cat_id;

  Produto(
      {this.pro_id,
      this.pro_descricao,
      this.pro_foto,
      this.pro_subDescricao,
      this.pro_preco,
      this.pro_qtd,
      this.cat_id});

  Produto.fromJson(Map<String, dynamic> json) {
    pro_id = json['pro_id'];
    pro_descricao = json['pro_descricao'];
    pro_subDescricao = json['pro_subDescricao'];
    pro_foto = json['pro_foto'];
    pro_preco = double.parse(json['pro_preco']);
    pro_qtd = json['pro_qtd'];
    cat_id = json['cat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_id'] = this.pro_id;
    data['pro_descricao'] = this.pro_descricao;
    data['pro_subDescricao'] = this.pro_subDescricao;
    data['pro_foto'] = this.pro_foto;
    data['pro_preco'] = this.pro_preco;
    data['pro_qtd'] = this.pro_qtd;
    data['cat_id'] = this.cat_id;
    return data;
  }

  @override
  String toString() {
    return "Produto{pro_id: $pro_id, pro_descricao: $pro_descricao, pro_subDescricao: $pro_subDescricao, pro_foto: $pro_foto, pro_preco: $pro_preco,  pro_qtd: $pro_qtd, cat_id: $cat_id}";
  }
}
