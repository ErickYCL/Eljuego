import 'package:bloc/bloc.dart';
import 'package:the_game/models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:the_game/utils/colaCircular.dart';

import 'estados.dart';
import 'eventos.dart';

const limiteMaximoDeJugadores = 5;
/*
Agregar evento turno pasado y carta jugada, y el Movimiento bloqueado que ya lo tenemos.

Hacer el minimo de cartas a jugar por CartaJugada, a partir del numero de cartas en el mazo
*/

class ElJuegoBloc extends Bloc<Evento, Estado> {
  late ColaCircular<Jugador> _colaCircular;
  IList<Jugador> jugadores = IList();
  // ignore: prefer_final_fields
  int _cartasJugadasPorActual = 0;
  int _limiteMaximoCartas = 0;

  final Mazo mazo;
  DescarteAscendente descarteAscendente1 = DescarteAscendente();
  DescarteAscendente descarteAscendente2 = DescarteAscendente();

  DescarteDescendente descarteDescendente1 = DescarteDescendente();
  DescarteDescendente descarteDescendente2 = DescarteDescendente();

  ElJuegoBloc(this.mazo) : super(EstadoInicial()) {
    on<TurnoPasado>(onTurnoPasado);

    on<JugadorAgregado>(onJugadorAgregado);

    on<PartidaIniciada>(onPartidaIniciada);

    on<MovimientosBloqueados>(onMovimientosBloqueados);

    on<CartaJugada>(onCartaJugada);

    on<ColaVacia>(onColaVacia);
  }

  void onMovimientosBloqueados(event, emit) {
    emit(
        PartidaPerdida(numeroDeCartas: numerodeCartasFinales(jugadores, mazo)));
  }

  void onColaVacia(event, emit) {
    emit(PartidaGanada());
  }

  void onPartidaIniciada(event, emit) {
    _colaCircular = ColaCircular(jugadores);
    _limiteMaximoCartas = calcularCartasMax(jugadores: jugadores.length);
    for (var jugador in jugadores) {
      jugador.robarCartas(mazo: mazo, limiteMaximo: _limiteMaximoCartas);
    }
    emit(Turno(
        jugador: _colaCircular.quienVa,
        descarteAscendente1: descarteAscendente1,
        descarteAscendente2: descarteAscendente2,
        descarteDescendente1: descarteDescendente1,
        descarteDescendente2: descarteDescendente2));
  }

  void onJugadorAgregado(event, emit) {
    mazo.barajar();
    if (jugadores.contains(event.jugador)) {
      emit(Lobby(jugadores: jugadores, mensaje: 'jugador duplicado'));
      return;
    }
    jugadores = jugadores.add(event.jugador);
    emit(Lobby(jugadores: jugadores, mensaje: ''));
    if (jugadores.length == limiteMaximoDeJugadores) {
      add(PartidaIniciada());
    }
  }

  void onCartaJugada(event, emit) {
    bool jugoBien(CartaJugada evento) {
      if (_colaCircular.quienVa.mano.contains(evento.carta)) {
        return (event.descarte.recibirCarta(evento.carta));
      }
      return false;
    }

    if (jugoBien(event)) {
      var jugadorActual = _colaCircular.quienVa;
      _colaCircular.quienVa.mano =
          _colaCircular.quienVa.mano.remove(event.carta);
      _cartasJugadasPorActual++;
      if (_colaCircular.quienVa.mano.isEmpty) {
        if (mazo.estaVacio()) {
          _colaCircular.sacar(_colaCircular.quienVa);
          if (_colaCircular.estaVacio) {
            emit(PartidaGanada());
            return;
          }
        } else {
          int aRobar = calcularCartasParaRobar(
              mazo, jugadorActual.mano, _limiteMaximoCartas);
          jugadorActual.robarCartas(mazo: mazo, limiteMaximo: aRobar);
          _colaCircular.siguiente();
        }
      }
      emit(
        Turno(
            jugador: _colaCircular.quienVa,
            descarteAscendente1: descarteAscendente1,
            descarteAscendente2: descarteAscendente2,
            descarteDescendente1: descarteDescendente1,
            descarteDescendente2: descarteDescendente2),
      );
      return;
    }
    emit(
      Turno(
          jugador: _colaCircular.quienVa,
          descarteAscendente1: descarteAscendente1,
          descarteAscendente2: descarteAscendente2,
          descarteDescendente1: descarteDescendente1,
          descarteDescendente2: descarteDescendente2),
    );
  }

  void onTurnoPasado(event, emit) {
    if (_cartasJugadasPorActual >= minimoAJugar(mazo)) {
      _cartasJugadasPorActual = 0;
      _colaCircular.quienVa.robarCartas(
          mazo: mazo,
          limiteMaximo: calcularCartasParaRobar(
              mazo, _colaCircular.quienVa.mano, _limiteMaximoCartas));
      emit(Turno(
          jugador: _colaCircular.siguiente(),
          descarteAscendente1: descarteAscendente1,
          descarteAscendente2: descarteAscendente2,
          descarteDescendente1: descarteDescendente1,
          descarteDescendente2: descarteDescendente2));
      return;
    }
    emit(Turno(
        jugador: _colaCircular.quienVa,
        descarteAscendente1: descarteAscendente1,
        descarteAscendente2: descarteAscendente2,
        descarteDescendente1: descarteDescendente1,
        descarteDescendente2: descarteDescendente2));
    return;
  }

  // @override
  // void onChange(Change<Estado> change) {
  //   super.onChange(change);
  //   print(change);
  // }
}

int calcularCartasMax({required int jugadores}) {
  Map<int, int> limiteCartasEnMano = {1: 8, 2: 7, 3: 6, 4: 6, 5: 6};
  if (limiteCartasEnMano.containsKey(jugadores)) {
    return limiteCartasEnMano[jugadores]!;
  }
  throw Exception('Número de jugadores incorrecto');
}

int numerodeCartasFinales(IList<Jugador> jugadores, Mazo mazo) {
  int numeroDeCartas = 0;
  for (var j in jugadores) {
    numeroDeCartas += j.mano.length;
  }
  numeroDeCartas += mazo.cantidadCartasRestantes;
  return numeroDeCartas;
}

int calcularCartasParaRobar(Mazo mazo, IList<Carta> mano, int limiteMaximo) {
  int cantidadARobar = limiteMaximo - mano.length;
  if (mazo.cantidadCartasRestantes < cantidadARobar) {
    cantidadARobar = mazo.cantidadCartasRestantes;
  }
  return cantidadARobar;
}

int minimoAJugar(Mazo mazo) => mazo.estaVacio() ? 1 : 2;
