class Entregas {
  int? entId;
  String? entStatusAdmin;
  String? entStatusEntregador;
  int? entHoras;
  String? entValorFrete;
  int? usuId;
  int? pedId;

  Entregas(
      {this.entId,
      this.entStatusAdmin,
      this.entStatusEntregador,
      this.entHoras,
      this.entValorFrete,
      this.usuId,
      this.pedId});

  Entregas.fromJson(Map<String, dynamic> json) {
    entId = json['ent_id'];
    entStatusAdmin = json['ent_status_admin'];
    entStatusEntregador = json['ent_status_entregador'];
    entHoras = json['ent_horas'];
    entValorFrete = json['ent_valor_frete'];
    usuId = json['usu_id'];
    pedId = json['ped_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ent_id'] = this.entId;
    data['ent_status_admin'] = this.entStatusAdmin;
    data['ent_status_entregador'] = this.entStatusEntregador;
    data['ent_horas'] = this.entHoras;
    data['ent_valor_frete'] = this.entValorFrete;
    data['usu_id'] = this.usuId;
    data['ped_id'] = this.pedId;
    return data;
  }
}
