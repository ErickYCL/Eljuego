import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';

class Carta with EquatableMixin{
  final int valor;

  Carta({required this.valor});
  @override
  String toString() => '$valor';
  
  @override
  List<Object?> get props => [valor];
}

class Mazo {
  int get cantidadCartasRestantes => cartas.length;
   
  List<Carta> cartas =
      List<Carta>.generate(98, (index) => Carta(valor: index + 2));

  void barajar() {
    cartas.shuffle();
  }

  bool estaVacio() {
    return cartas.isEmpty;
  }

  Either<Problema, Carta> robar() {
    if (estaVacio()) return left(MazoVacio());

    Carta carta = cartas.first;
    cartas.removeAt(0);
    return right(carta);
  }

  @override
  String toString() => '$cartas';
}

sealed class Problema {}

class MazoVacio extends Problema {}

sealed class Descarte with EquatableMixin {
  final List<Carta> _descartadas = [];
  bool recibirCarta(Carta carta);

  Carta get laDeArriba => _descartadas.last;
  @override
  
  List<Object?> get props => [_descartadas];
}

class DescarteAscendente extends Descarte {
  DescarteAscendente(){
    _descartadas.add(Carta(valor: 1));
  }
  @override
  bool recibirCarta(Carta carta) {
    if (_descartadas.isEmpty) {
      _descartadas.add(carta);
      return true;
    }
    Carta c = _descartadas.last;
    if (c.valor < carta.valor) {
      _descartadas.add(carta);
      return true;
    }
    if (carta.valor == (c.valor - 10)) {
      _descartadas.add(carta);
      return true;
    }
    return false;
  }

  @override
  String toString() => 'DescarteA $_descartadas';
}

class DescarteDescendente extends Descarte {
  DescarteDescendente(){
    _descartadas.add(Carta(valor: 100));
  }
  @override
  bool recibirCarta(Carta carta) {
    if (_descartadas.isEmpty) {
      _descartadas.add(carta);
      return true;
    }
    Carta c = _descartadas.last;
    if (c.valor > carta.valor) {
      _descartadas.add(carta);
      return true;
    }
    if (carta.valor == (c.valor + 10)) {
      _descartadas.add(carta);
      return true;
    }
    return false;
  }

  @override
  String toString() => 'DescarteD $_descartadas';
}

class Jugador with EquatableMixin {
  final String nombre;
  IList<Carta> mano;

  Jugador({required this.nombre, required this.mano});

  @override
  String toString() {
    return 'Jugador $nombre con mano $mano';
  }

  @override
  List<Object?> get props => [nombre];

  void robarCartas({required Mazo mazo, required int limiteMaximo}) {
    if (mazo.estaVacio()) return;
    
    for (var i = 0; i < limiteMaximo; i++) {
      var posibleCartas = mazo.robar();
      posibleCartas.match((l) => null, (r) => {mano = mano.add(r)});
    }
  }
}
