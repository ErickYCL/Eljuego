import 'package:the_game/models.dart';

class MazoMovimientoBloqueado extends Mazo {
  MazoMovimientoBloqueado() {
    cartas = [
      Carta(valor: 99),
      Carta(valor: 98),
      Carta(valor: 2),
      Carta(valor: 3),
      Carta(valor: 4),
      Carta(valor: 5),
      Carta(valor: 6),
      Carta(valor: 7),
      Carta(valor: 8),
      Carta(valor: 9),
      Carta(valor: 10),
      Carta(valor: 11),
      Carta(valor: 12),
      Carta(valor: 13)

    ];
  }

  @override
  void barajar() {
    // No queremos cambiar el orden para probarlo
  }
}
