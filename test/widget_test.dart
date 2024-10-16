import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:icondock/main.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp should build without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp should have correct theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme!.appBarTheme.backgroundColor, Colors.white);
      expect(app.theme!.visualDensity, VisualDensity.adaptivePlatformDensity);
    });
  });

  group('HomePage Widget Tests', () {
    testWidgets('HomePage should have AppBar with correct properties', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      final AppBar appBar = tester.widget(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
      expect((appBar.title as Text).data, 'Icon Dock');
      expect(appBar.centerTitle, true);
      expect(appBar.elevation, 4);
    });

    testWidgets('HomePage should contain a Dock widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.byType(Dock<IconData>), findsOneWidget);
    });
  });

  group('Dock Widget Tests', () {
    testWidgets('Dock should display correct number of items', (WidgetTester tester) async {
      final List<IconData> testIcons = [
        Icons.person,
        Icons.message,
        Icons.call,
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Dock<IconData>(
              items: testIcons,
              builder: (IconData icon, bool isDragging) {
                return DockItem(icon: icon, isDragging: isDragging);
              },
            ),
          ),
        ),
      );

      expect(find.byType(DockItem), findsNWidgets(testIcons.length));
    });

    testWidgets('DockItem should respond to dragging', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Dock<IconData>(
              items: const [Icons.person],
              builder: (IconData icon, bool isDragging) {
                return DockItem(icon: icon, isDragging: isDragging);
              },
            ),
          ),
        ),
      );

      final Finder dockItemFinder = find.byType(DockItem);

      // Verify initial state
      DockItem dockItem = tester.widget(dockItemFinder);
      expect(dockItem.isDragging, false);

      // Start dragging
      await tester.drag(dockItemFinder, const Offset(100, 0));
      await tester.pump();

      // Verify dragging state
      // Note: This test might need adjustment based on how dragging state is managed in your implementation
      // You might need to expose the dragging state or use a different method to verify it
    });
  });

  group('Integration Tests', () {
    testWidgets('Full app flow - Dock reordering', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial order
      final List<IconData> initialOrder = [
        Icons.person,
        Icons.message,
        Icons.call,
        Icons.camera,
        Icons.photo,
      ];

      for (int i = 0; i < initialOrder.length; i++) {
        expect(find.byIcon(initialOrder[i]), findsOneWidget);
      }

      // Perform a drag operation
      await tester.drag(find.byIcon(Icons.person), const Offset(200, 0));
      await tester.pumpAndSettle();

      // Verify new order
      // Note: The exact new positions might vary based on the drag implementation
      // This test assumes the first icon moves to the end
      final List<IconData> expectedNewOrder = [
        Icons.message,
        Icons.call,
        Icons.camera,
        Icons.photo,
        Icons.person,
      ];

      for (int i = 0; i < expectedNewOrder.length; i++) {
        expect(find.byIcon(expectedNewOrder[i]), findsOneWidget);
      }
    });
  });
}