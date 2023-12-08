import 'package:the_game/models.dart';

class ColaCircular<T> {
  final List<T> _lista = [];

  ColaCircular(Iterable<T> valoresIniciales) {
    if (valoresIniciales.isEmpty) {
      throw ArgumentError.value("No se aceptan listas vacias");
    }
    _lista.addAll(valoresIniciales);
  }

  ColaCircular.desordenado(Iterable<T> valoresIniciales) {
    if (valoresIniciales.isEmpty) {
      throw ArgumentError.value("No se aceptan listas vacias");
    }
    _lista.addAll(valoresIniciales);
    _lista.shuffle();
  }

  T get quienVa {
    if (_lista.isEmpty) {
      throw ArgumentError.value("Ya no hay jugadores");
    }
    return _lista.first;
  }

  bool get estaVacio => _lista.isEmpty;

  T siguiente() {
    if (_lista.isEmpty) {
      throw ArgumentError.value("Ya no hay jugadores");
    }
    var primero = _lista.first;
    _lista.add(primero);
    _lista.removeAt(0);
    return quienVa;
  }

  void sacar(Jugador elemento) {
    if (_lista.isEmpty) {
      throw ArgumentError.value("Ya no hay jugadores");
    }
    _lista.remove(elemento);
    // return quienVa;
  }
}
