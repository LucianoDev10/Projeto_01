class Categorias {
  int? cat_id;
  String? cat_nome;
  String? cat_icons;

  Categorias({this.cat_id, this.cat_nome, this.cat_icons});

  Categorias.fromJson(Map<String, dynamic> json) {
    cat_id = json['cat_id'];
    cat_nome = json['cat_nome'];
    cat_icons = json['cat_icons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.cat_id;
    data['cat_nome'] = this.cat_nome;
    data['cat_icons'] = this.cat_icons;

    return data;
  }

  @override
  String toString() {
    return 'Categorias{cat_id: $cat_id, cat_nome: $cat_nome, cat_icons: $cat_icons}';
  }
}
