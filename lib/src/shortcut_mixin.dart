// lib/src/shortcut_mixin.dart
import 'package:flutter/material.dart';
import 'keyboard_shortcut_listener.dart';

/// A mixin that provides a convenient way to add keyboard shortcuts to widgets.
///
/// Allows easy wrapping of widgets with keyboard shortcut functionality.
///
/// Usage:
/// ```dart
/// class MyWidget extends StatelessWidget with ShortcutMixin {
///   @override
///   Widget build(BuildContext context) {
///     return withShortcuts(
///       child: YourWidget(),
///       shortcuts: {
///         'n': () => createNewItem(),
///       }
///     );
///   }
/// }
/// ```
mixin ShortcutMixin {
  /// Wraps a widget with [KeyboardShortcutListener].
  ///
  /// [child] is the widget to be wrapped with shortcut functionality.
  /// [shortcuts] is an optional map of keyboard shortcuts to their actions.
  ///
  /// Returns a [KeyboardShortcutListener] widget containing the original child.
  Widget withShortcuts({
    required Widget child,
    Map<String, VoidCallback>? shortcuts,
  }) {
    // Register any provided shortcuts
    shortcuts?.forEach((key, action) {
      KeyboardShortcutListener.registerShortcut(key, action);
    });

    return KeyboardShortcutListener(child: child);
  }
}
