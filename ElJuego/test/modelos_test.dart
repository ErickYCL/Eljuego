
import 'package:test/test.dart';
import 'package:the_game/models.dart';

void main(){
  group('si el descarte ascendente...', () {
  test('Si el descarte ascendente acepta cuando esta vacio', () {
    DescarteAscendente descarte = DescarteAscendente();
    bool acepto = descarte.recibirCarta(Carta(valor: 10));
    expect(acepto, equals(true));

  });

  test('Si el descarte ascendente acepta cuando uno mayor', () {
    DescarteAscendente descarte = DescarteAscendente();
    descarte.recibirCarta(Carta(valor: 10));
    bool acepto = descarte.recibirCarta(Carta(valor: 20));
    expect(acepto, equals(true));

  });

  test('Si el descarte ascendente no acepta uno menor', () {
    DescarteAscendente descarte = DescarteAscendente();
    descarte.recibirCarta(Carta(valor: 10));
    bool acepto = descarte.recibirCarta(Carta(valor: 5));
    expect(acepto, equals(false));

  });

    test('Si el descarte ascendente acepta una de exactamente menor en 10', () {
    DescarteAscendente descarte = DescarteAscendente();
    descarte.recibirCarta(Carta(valor: 20));
    bool acepto = descarte.recibirCarta(Carta(valor: 10));
    expect(acepto, equals(true));

  });
  });

  group('Si el descarte es descendente...', () {
      test('Si el descarte descendente acepta cuando esta vacio', () {
    DescarteDescendente descarte = DescarteDescendente();
    bool acepto = descarte.recibirCarta(Carta(valor: 90));
    expect(acepto, equals(true));

  });

  test('Si el descarte descendente acepta cuando uno menor', () {
    DescarteDescendente descarte = DescarteDescendente();
    descarte.recibirCarta(Carta(valor: 80));
    bool acepto = descarte.recibirCarta(Carta(valor: 75));
    expect(acepto, equals(true));

  });

  test('Si el descarte descendente no acepta uno mayor', () {
    DescarteDescendente descarte = DescarteDescendente();
    descarte.recibirCarta(Carta(valor: 80));
    bool acepto = descarte.recibirCarta(Carta(valor: 85));
    expect(acepto, equals(false));

  });

    test('Si el descarte descendente acepta una de exactamente mayor en 10', () {
    DescarteDescendente descarte = DescarteDescendente();
    descarte.recibirCarta(Carta(valor: 70));
    bool acepto = descarte.recibirCarta(Carta(valor: 80));
    expect(acepto, equals(true));

  });
    
  });

}