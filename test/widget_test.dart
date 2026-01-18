import 'package:flutter_test/flutter_test.dart';
import 'package:miaucaomigo/main.dart';

void main() {
  testWidgets('Teste de carregamento inicial', (WidgetTester tester) async {
    // Tenta carregar o app Miaucaomigo
    await tester.pumpWidget(const MiaucaomigoApp());

    // Verifica se o app iniciou (pode falhar se o Firebase não estiver configurado)
    expect(find.byType(MiaucaomigoApp), findsOneWidget);
  });
}
