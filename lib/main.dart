import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// The main application widget.
/// Builds the [MaterialApp] and defines the overall theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Icon Dock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

/// The home page widget that contains the [Dock] and an animated AppBar.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Dock')),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[200]!, Colors.blueGrey[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Dock<IconData>(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (IconData icon, bool isDragging) {
              return DockItem(
                icon: icon,
                isDragging: isDragging,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A single item in the [Dock].
/// Displays an icon within a container with a shadow when dragged.
class DockItem extends StatelessWidget {
  /// Creates a [DockItem].
  ///
  /// The [icon] parameter must not be null and specifies the icon to display.
  /// The [isDragging] parameter specifies whether the item is currently being dragged.
  final IconData icon;
  final bool isDragging;

  const DockItem({
    super.key,
    required this.icon,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    // Create a transformation matrix for scaling when dragging.
    Matrix4 transform = Matrix4.identity(); // Initialize as identity matrix
    if (isDragging) {
      transform.scale(1.1); // Scale up if dragging
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: const BoxConstraints(minWidth: 48),
      height: 48,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[icon.hashCode % Colors.primaries.length],
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      transform: transform, // Apply the transformation matrix here
      child: Center(child: Icon(icon, color: Colors.white)),
    );
  }
}

/// A dock containing reorderable [items] that can be dragged and animated.
/// This class manages the layout of the dock and provides animations
/// when items are dragged between slots.
class Dock<T> extends StatefulWidget {
  /// Creates a new instance of [Dock].
  ///
  /// The [items] parameter must not be null and should provide the
  /// initial list of items to be displayed in the dock.
  ///
  /// The [builder] function must be provided to create widgets
  /// for each item in the dock based on the item data and its drag state.
  const Dock({
    super.key,
    required this.items,
    required this.builder,
  });

  /// List of initial [T] items in the dock.
  final List<T> items;

  /// Builder function to create widgets for each item in the dock.
  final Widget Function(T, bool) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] that manages the reordering and animations.
class _DockState<T> extends State<Dock<T>> with TickerProviderStateMixin {
  /// List of items currently being manipulated.
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 100, // Set height for the ReorderableListView
        child: ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return Draggable<int>(
              key: ValueKey(_items[index]),
              data: index,
              feedback: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                  AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 200),
                  )..forward(),
                ),
                child: widget.builder(_items[index], true),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: widget.builder(_items[index], false),
              ),
              child: DragTarget<int>(
                builder: (context, candidateData, rejectedData) {
                  return widget.builder(_items[index], false);
                },
                onAccept: (int oldIndex) => _onReorder(oldIndex, index),
              ),
            );
          },
          onReorder: _onReorder,
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                final double animValue =
                    Curves.easeInOut.transform(animation.value);
                final double elevation = lerpDouble(0, 8, animValue)!;
                return Material(
                  elevation: elevation,
                  color: Colors.transparent,
                  child: child,
                );
              },
              child: child,
            );
          },
        ),
      ),
    );
  }

  /// Reorders the items when an icon is dragged.
  ///
  /// [oldIndex] is the starting position and [newIndex] is the target.
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1; // Adjust newIndex if the dragged item is above
      }
      final T item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }
}
