// lib/src/keyboard_shortcut_listener.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shortcut_visibility_manager.dart';

/// A widget that listens for keyboard events and manages shortcut interactions.
///
/// Provides dynamic shortcut registration and visibility toggling functionality.
///
/// Usage:
/// ```dart
/// KeyboardShortcutListener(
///   child: YourWidget(),
/// )
/// ```
class KeyboardShortcutListener extends StatefulWidget {
  /// The child widget to be wrapped with keyboard shortcut functionality.
  final Widget child;

  const KeyboardShortcutListener({
    super.key,
    required this.child,
  });

  /// Internal storage for registered shortcut actions.
  static final Map<String, VoidCallback> _shortcutActions = {};

  /// Dynamically registers a keyboard shortcut.
  ///
  /// [key] is the keyboard key to trigger the shortcut.
  /// [action] is the callback to be executed when the shortcut is triggered.
  ///
  /// Example:
  /// ```dart
  /// KeyboardShortcutListener.registerShortcut('n', () => createNewFile());
  /// ```
  static void registerShortcut(String key, VoidCallback action) {
    _shortcutActions[key.toLowerCase()] = action;
  }

  /// Removes a previously registered shortcut.
  ///
  /// [key] is the keyboard key of the shortcut to be unregistered.
  static void unregisterShortcut(String key) {
    _shortcutActions.remove(key.toLowerCase());
  }

  @override
  // ignore: library_private_types_in_public_api
  _KeyboardShortcutListenerState createState() =>
      _KeyboardShortcutListenerState();
}

/// State management for [KeyboardShortcutListener].
class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener> {
  /// Tracks whether the Alt key is currently pressed.
  bool isAltPressed = false;

  /// Instance of [ShortcutVisibilityManager] to manage shortcut visibility.
  final _shortcutVisibilityManager = ShortcutVisibilityManager();

  @override
  Widget build(BuildContext context) {
    // Uses RawKeyboardListener to capture low-level keyboard events
    // ignore: deprecated_member_use
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyPress,
      child: widget.child,
    );
  }

  /// Handles keyboard key press and release events.
  ///
  /// Manages Alt key for showing/hiding shortcut keys and executing shortcuts.
  // ignore: deprecated_member_use
  void _handleKeyPress(RawKeyEvent event) {
    // ignore: deprecated_member_use
    if (event is RawKeyDownEvent) {
      // Check for Alt key press to show shortcut keys
      if (event.logicalKey == LogicalKeyboardKey.altLeft) {
        if (!isAltPressed) {
          setState(() => isAltPressed = true);
          _shortcutVisibilityManager.setShortcutKeysVisible(true);
        }
      } 
      // When Alt is pressed, check for registered shortcut keys
      else if (isAltPressed) {
        final keyLabel = event.logicalKey.keyLabel.toLowerCase();
        final action = KeyboardShortcutListener._shortcutActions[keyLabel];
        
        if (action != null) {
          action.call();
        }
      }
    } 
    // Handle Alt key release to hide shortcut keys
    // ignore: deprecated_member_use
    else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.altLeft) {
        setState(() => isAltPressed = false);
        _shortcutVisibilityManager.setShortcutKeysVisible(false);
      }
    }
  }
}