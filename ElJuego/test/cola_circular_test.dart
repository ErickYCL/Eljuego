
import 'package:test/test.dart';
import 'package:the_game/utils/colaCircular.dart';

void main() {
  test('Si lo construyo con [1,2,3] el actual quienVa vale 1...', () async {
    ColaCircular c = ColaCircular([1, 2, 3]);
    expect(c.quienVa, equals(1));
    
  });

  test('Si con [1,2,3] el siguiente seria 2', () {
    ColaCircular c = ColaCircular([1, 2, 3]);
    var x = c.siguiente();
    expect(x, equals(2));
  });


  test('que sea circular', () {
    var c = ColaCircular([1,2]);
    var x = c.siguiente();
    x = c.siguiente();
    expect(x, equals(1));
  });

    test('No se puede crear una cola vacía', () {
    expect(() => ColaCircular<int>([]), throwsArgumentError);
  });

  test('No se puede crear una cola desordenada vacía', () {
    expect(() => ColaCircular<int>.desordenado([]), throwsArgumentError);
  });


  

  
}