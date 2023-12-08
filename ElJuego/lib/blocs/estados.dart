import 'package:the_game/models.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

sealed class Estado {}

final class EstadoInicial extends Estado {}

class Turno extends Estado with EquatableMixin {
  final Jugador jugador;
  final DescarteAscendente descarteAscendente1;
  final DescarteAscendente descarteAscendente2;
  final DescarteDescendente descarteDescendente1;
  final DescarteDescendente descarteDescendente2;

  Turno(
      {required this.jugador,
      required this.descarteAscendente1,
      required this.descarteAscendente2,
      required this.descarteDescendente1,
      required this.descarteDescendente2});

  @override
  List<Object?> get props => [
        jugador,
        descarteAscendente1,
        descarteAscendente2,
        descarteDescendente1,
        descarteDescendente2
      ];
}

class PartidaPerdida extends Estado with EquatableMixin {
  final int numeroDeCartas;

  PartidaPerdida({required this.numeroDeCartas});
  @override
  List<Object?> get props => [numeroDeCartas];
}

class PartidaGanada extends Estado{
}

class Lobby extends Estado with EquatableMixin {
  final IList<Jugador> jugadores;
  final String mensaje;

  Lobby({required this.mensaje, required this.jugadores});

  @override
  List<Object?> get props => [jugadores, mensaje];

  @override
  String toString() {
    return 'Soy Lobby con $jugadores con $mensaje';
  }
}
