import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_guia4/main.dart';

void main() {
  testWidgets('LoginScreen autentica e ingresa a Dashboard y Tareas', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PanelAcademicoApp());
    await tester.pumpAndSettle();

    expect(find.text('INGRESAR AL PANEL'), findsOneWidget);
    await tester.tap(find.text('INGRESAR AL PANEL'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bienvenido de regreso'), findsOneWidget);
    expect(find.text('DESARROLLO DE SOFTWARE II'), findsWidgets);

    await tester.tap(find.text('Tareas').first);
    await tester.pumpAndSettle();
    expect(find.text('Tareas y entregables'), findsOneWidget);
  });
}
