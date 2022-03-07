

class Currency {
  final String name;
  final double sell;
  final double? buy;
  final double? variation;

  Currency({ required this.name, required this.sell, required this.buy, this.variation});

}