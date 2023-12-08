import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:the_game/blocs/eljuego.dart';
import 'package:the_game/blocs/estados.dart';
import 'package:the_game/blocs/eventos.dart';
import 'package:the_game/mazitos/mazitos.dart';
import 'package:the_game/models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

ElJuegoBloc bloc = ElJuegoBloc(MazoMovimientoBloqueado());
final consola = Console();

Future<void> main(List<String> args) async {
  while (true) {
    var estado = bloc.state;
    switch (estado) {
      case (EstadoInicial estadoInicial):
        await _estadoInicial(estadoInicial);
        break;
      case (Lobby lobby):
        await _lobby(lobby);
        break;

      case (Turno turno):
        await _turno(turno);
        break;

      case (PartidaPerdida partidaPerdida):
        await _partidaPerdida(partidaPerdida);
        exit(0);
      case (PartidaGanada partidaGanada):
        await _partidaGanada(partidaGanada);
        exit(0);
      default:
        _porHacer();
    }
  }
}

Future<void> _partidaGanada(PartidaGanada partidaGanada) async {
  print("");
  consola.setForegroundColor(ConsoleColor.brightGreen);
  consola.writeLine("GANASTE", TextAlignment.center);
  consola.resetColorAttributes();
}

Future<void> _partidaPerdida(PartidaPerdida partidaPerdida) async {
  consola.setForegroundColor(ConsoleColor.red);
  consola.writeLine(
      '××××××××××× PERDISTE LA PARTIDA ××××××××××× ', TextAlignment.center);
  consola.resetColorAttributes();
  consola.writeLine("");
  consola.writeLine('Las cartas restantes fueron de:', TextAlignment.center);
  consola.setForegroundColor(ConsoleColor.brightGreen);
  consola.writeLine(partidaPerdida.numeroDeCartas, TextAlignment.center);
  consola.resetColorAttributes();
}

Future<void> _turno(Turno turno) async {
  Descarte aCualDescarte(int cual) => switch (cual) {
        1 => turno.descarteAscendente1,
        2 => turno.descarteAscendente2,
        3 => turno.descarteDescendente1,
        4 => turno.descarteDescendente2,
        _ => turno.descarteAscendente1,
      };
  print("");
  print('Ahora va el turno de:  ${turno.jugador.nombre}');
  consola.writeLine("");
  print('Baraja actual: ');
  var manoCartas = turno.jugador.mano.join(' | ');
  consola.writeLine("");
  consola.setForegroundColor(ConsoleColor.brightMagenta);
  print(manoCartas);
  consola.resetColorAttributes();
  consola.writeLine("");
  print('Barajas de descarte: ');
  print("");
  consola.setForegroundColor(ConsoleColor.brightBlue);
  print(turno.descarteAscendente1.laDeArriba);
  print(turno.descarteAscendente2.laDeArriba);
  print(turno.descarteDescendente1.laDeArriba);
  print(turno.descarteDescendente2.laDeArriba);
  consola.resetColorAttributes();
  consola.writeLine("");
  print('¿quieres abandonar la partida?(si/no)');
  var abandono = consola.readLine();
  // Verificar si la respuesta es una cadena vacía
  while (abandono!.isEmpty) {
    print('¿Quieres abandonar la partida?(si/no)');
    abandono = consola.readLine();
  }
  if (abandono.toLowerCase() == 'si') {
    bloc.add(MovimientosBloqueados());
    return;
  }

  print("");
  print('¿Terminaste tu turno?(si/no)');
  var terminado = consola.readLine();
  while (terminado!.isEmpty || (terminado != "si" && terminado != "no")) {
    print('¿Terminaste tu turno?(si/no)');
    terminado = consola.readLine();
  }
  if (terminado == 'si') {
    bloc.add(TurnoPasado());
    return;
  }
  consola.writeLine("");
  print('¿cual carta quieres jugar?');
  var cual = consola.readLine();
  while (cual!.isEmpty || !(cual.contains(RegExp(r'^[0-9]+$')))) {
    print('¿cual carta quieres jugar?');
    cual = consola.readLine();
  }
  int numeroCual = int.parse(cual);
  print("");
  print('¿en que mazo lo quieres poner?');
  var cualMazo = consola.readLine();
  while (cualMazo!.isEmpty || !(cual!.contains(RegExp(r'^[0-9]+$')))) {
    print('¿En que mazo lo quieres poner?');
    cual = consola.readLine();
  }
  int numeroCualMazo = int.parse(cualMazo);
  bloc.add(CartaJugada(
      carta: Carta(valor: numeroCual),
      descarte: aCualDescarte(numeroCualMazo)));
}

Future<void> _lobby(Lobby lobby) async {
  consola.clearScreen();
  print('Los jugadores actualmente en la partida son:');
  consola.setForegroundColor(ConsoleColor.green);
  print(lobby.jugadores.map((element) => element.nombre).join(','));
  consola.resetColorAttributes();
  print('¿Quieres agregar otro jugador?');
  var siono = consola.readLine();
  if (siono?.toLowerCase() == 'si') {
    consola.writeLine("Dame el nombre del jugador:");
    var nombre = consola.readLine();
    if (nombre == "") {
      print('!El nombre del jugador no debe estar vacio¡');
      return;
    }
    bloc.add(JugadorAgregado(jugador: Jugador(nombre: nombre!, mano: IList())));
    return;
  }
  if (siono?.toLowerCase() == 'no') {
    bloc.add(PartidaIniciada());
  }
}

void _porHacer() {
  print('aun no implementado, vuelva al rato');
  exit(0);
}

Future<void> _estadoInicial(EstadoInicial estado) async {
  consola.setForegroundColor(ConsoleColor.blue);
  consola.writeLine(
      '▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  Empezando el juego "El JUEGO"  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓',
      TextAlignment.center);
  consola.resetColorAttributes(); // Reset color to default
  print('Dame el nombre del jugador:');
  consola.setForegroundColor(ConsoleColor.green);
  String? jugador = consola.readLine();
  consola.resetColorAttributes();
  if (jugador == "") {
    consola.clearScreen();
    print('!El nombre del jugador no debe estar vacio¡');

    return;
  }

  bloc.add(JugadorAgregado(jugador: Jugador(nombre: jugador!, mano: IList())));
  await Future.delayed(Duration(milliseconds: 500));
}
