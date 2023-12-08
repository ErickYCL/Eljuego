import 'package:the_game/models.dart';

sealed class Estado {}

class EstadoInicial extends Estado {}

class Lobby extends Estado {
  final List<Jugador> jugadores;

  Lobby({required this.jugadores});
}

sealed class Evento {}

class JugadorAgregado extends Evento {
  final Jugador jugador;

  JugadorAgregado({required this.jugador});
}