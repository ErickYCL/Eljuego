import 'package:the_game/models.dart';

sealed class Evento{

}
class PartidaIniciada extends Evento{}

class MovimientosBloqueados extends Evento{}

class TurnoPasado extends Evento{}

class ColaVacia extends Evento{}


class CartaJugada extends Evento{
  final Carta carta;
  final Descarte descarte;

  CartaJugada({required this.carta, required this.descarte});
}

class JugadorAgregado extends Evento{
  final Jugador jugador;

  JugadorAgregado({required this.jugador});
}
