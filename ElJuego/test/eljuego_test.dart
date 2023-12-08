
import 'package:bloc_test/bloc_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:test/test.dart';
import 'package:the_game/blocs/eljuego.dart';
import 'package:the_game/blocs/estados.dart';
import 'package:the_game/blocs/eventos.dart';
import 'package:the_game/mazitos/mazitos.dart';
import 'package:the_game/models.dart';

void main() {
  blocTest<ElJuegoBloc, Estado>(
    'si no se llega al limite se aceptan jugadores',
    build: () => ElJuegoBloc(Mazo()),
    act: (bloc) => bloc
        .add(JugadorAgregado(jugador: Jugador(mano: IList(), nombre: 'pepe'))),
    expect: () => [
      Lobby(
          mensaje: '',
          jugadores: IList([Jugador(nombre: 'pepe', mano: IList())]))
    ],
  );

  blocTest<ElJuegoBloc, Estado>(
    'que no se pueda meter el mismo jugador',
    build: () => ElJuegoBloc(Mazo()),
    act: (bloc) {
      bloc.add(
          JugadorAgregado(jugador: Jugador(nombre: 'pepe', mano: IList())));
      bloc.add(
          JugadorAgregado(jugador: Jugador(nombre: 'pepe', mano: IList())));
    },
    skip: 1,
    expect: () => [
      Lobby(
          jugadores: IList([Jugador(nombre: 'pepe', mano: IList())]),
          mensaje: 'Jugador duplicado')
    ],
  );



  late Jugador jugador;
  blocTest<ElJuegoBloc, Estado>('que el jugador tire 5 cartas y jale 5',
        build: () => ElJuegoBloc(MazoMovimientoBloqueado()),
        act: (bloc) {
             jugador = Jugador(nombre: 'jose', mano: IList());
          bloc.add(JugadorAgregado(jugador: jugador));
          bloc.add(PartidaIniciada());
          bloc.add(CartaJugada(
              carta: Carta(valor: 2), descarte: bloc.descarteAscendente1));
          bloc.add(CartaJugada(
              carta: Carta(valor: 3), descarte: bloc.descarteAscendente1));
          bloc.add(CartaJugada(
              carta: Carta(valor: 4), descarte: bloc.descarteAscendente1));
          bloc.add(CartaJugada(
              carta: Carta(valor: 5), descarte: bloc.descarteAscendente1));
          bloc.add(CartaJugada(
              carta: Carta(valor: 6), descarte: bloc.descarteAscendente1));
          bloc.add(TurnoPasado());
        },
        expect: () => [
              Lobby(
                  mensaje: '',
                  jugadores: IList([jugador])),
              Turno(
                  jugador: Jugador(
                      nombre: 'jose',
                      mano: IList([
                        Carta(valor: 99),
                        Carta(valor: 98),
                        Carta(valor: 7),
                        Carta(valor: 8),
                        Carta(valor: 9),
                        Carta(valor: 10),
                        Carta(valor: 11),
                        Carta(valor: 12)
                      ])),
                  descarteAscendente1: DescarteAscendente()
                    ..recibirCarta(Carta(valor: 2))
                    ..recibirCarta(Carta(valor: 3))
                    ..recibirCarta(Carta(valor: 4))
                    ..recibirCarta(Carta(valor: 5))
                    ..recibirCarta(Carta(valor: 6)),
                  descarteAscendente2: DescarteAscendente(),
                  descarteDescendente1: DescarteDescendente(),
                  descarteDescendente2: DescarteDescendente()),
            ]);
   
  

  test('minimoAJugar con mazo vacío', () {
      final mazoVacio = Mazo(); 
      expect(minimoAJugar(mazoVacio), 2);
    });
   
   


    test('calcularCartasMax para 2 jugadores', () {
      expect(calcularCartasMax(jugadores: 2), 7);
    });

     test('calcularCartasMax para 3 o mas jugadores', () {
      expect(calcularCartasMax(jugadores: 4), 6);
    });

 test('numerodeCartasFinales con jugadores y mazo', () {
      final mazo = Mazo(); 
      final jugadores = IList([Jugador(nombre: 'jorjais', mano: IList()), Jugador(nombre: 'angel', mano: IList())]);
      final int numCartasFinales = numerodeCartasFinales(jugadores, mazo);
      expect(numCartasFinales, 98); 
    });

     test('minimoAJugar con mazo vacío', () {
      final mazoVacio = Mazo(); 
      final int minimo = minimoAJugar(mazoVacio);
      expect(minimo, 2); 
    });

    
  

  
}
    