import 'dart:ui';

class ItensOrdenar {
  final String id;
  final String nome;

  ItensOrdenar(this.id, this.nome);

  static List<ItensOrdenar> getIntensOrdenarDelivery() {
    return <ItensOrdenar>[
      ItensOrdenar("padrao", 'Padrão'),
      ItensOrdenar("menor", 'Menor Preço'),
      ItensOrdenar("maior", 'Maior Preço')
    ];
  }
}

class ItensOrdenarMarketplace {
  late String id;
  late String nome;

  ItensOrdenarMarketplace(this.id, this.nome);

  static List<ItensOrdenarMarketplace> getIntensOrdenarMarketplace() {
    return <ItensOrdenarMarketplace>[
      ItensOrdenarMarketplace("padrao", 'Padrão'),
      ItensOrdenarMarketplace("menor", 'Menor Preço'),
      ItensOrdenarMarketplace("maior", 'Maior Preço')
    ];
  }
}

Color minhaCorPersonalizada = Color(0xFFFFD700); // Cor amarela mais escura
