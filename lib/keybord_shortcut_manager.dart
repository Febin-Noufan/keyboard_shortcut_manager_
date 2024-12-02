// ignore_for_file: deprecated_member_use

/// A Flutter library for advanced keyboard shortcut interactions.
///
/// Provides a [KeyboardShortcutListener] widget that enables complex
/// keyboard shortcut functionality with dynamic visibility and configurable actions.
library keyboard_shortcut_listener;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that enables keyboard shortcut functionality with configurable actions.
///
/// This widget wraps child widgets and provides a mechanism to:
/// - Listen to keyboard events
/// - Trigger focus and submit actions based on specific key presses
/// - Toggle shortcut visibility dynamically
class KeyboardShortcutListener extends StatefulWidget {
  /// The child widget to be wrapped with keyboard shortcut functionality.
  final Widget child;

  /// A list of [ShortcutFocus] configurations defining keyboard shortcuts.
  ///
  /// Each [ShortcutFocus] represents a specific keyboard shortcut with
  /// associated focus and optional submit actions.
  final List<ShortcutFocus> shortcuts;

  /// A [ValueNotifier] to control and observe the visibility of shortcut keys.
  ///
  /// When set to true, keyboard shortcuts are active and can be triggered.
  /// Typically used to show/hide shortcut key labels in the UI.
  final ValueNotifier<bool> shortcutKeysVisible;

  /// Creates a [KeyboardShortcutListener] widget.
  ///
  /// [child] is the widget to be wrapped.
  /// [shortcuts] defines the keyboard shortcuts and their associated actions.
  /// [shortcutKeysVisible] controls the visibility and activation of shortcuts.
  const KeyboardShortcutListener({
    super.key,
    required this.child,
    required this.shortcuts,
    required this.shortcutKeysVisible,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KeyboardShortcutListenerState createState() =>
      _KeyboardShortcutListenerState();
}

/// The state class for [KeyboardShortcutListener] that manages keyboard event handling.
///
/// Handles the core logic of capturing keyboard events, managing Alt key state,
/// and triggering appropriate actions for configured shortcuts.
class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener> {
  /// A map to efficiently lookup shortcut configurations by their key.
  ///
  /// Provides O(1) access to shortcut configurations, improving performance
  /// over linear searching through the original list.
  late Map<String, ShortcutFocus> shortcutMap;

  /// Tracks the current state of the Alt key.
  ///
  /// Used to determine when to show/hide shortcut keys and trigger Alt+Key combinations.
  bool isAltPressed = false;

  @override
  void initState() {
    super.initState();
    // Convert the list of shortcuts into a map for faster key-based lookups
    shortcutMap = {
      for (var shortcut in widget.shortcuts) shortcut.key: shortcut
    };
  }

  /// Handles keyboard events and triggers appropriate actions.
  ///
  /// This method manages two primary interactions:
  /// 1. Toggles shortcut visibility when the Alt key is pressed
  /// 2. Triggers focus and submit actions for configured Alt+Key shortcuts
  ///
  /// The method differentiates between key down and key up events to
  /// provide a responsive and intuitive shortcut experience.
  void handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Check for Alt key press to show shortcut keys
      if (event.logicalKey == LogicalKeyboardKey.altLeft) {
        if (!isAltPressed) {
          setState(() {
            isAltPressed = true;
          });
          widget.shortcutKeysVisible.value = true; // Show labels
        }
      } else if (isAltPressed) {
        // Handle Alt + Key combination
        String keyLabel = event.logicalKey.keyLabel.toLowerCase();
        if (shortcutMap.containsKey(keyLabel)) {
          // Trigger focus action
          shortcutMap[keyLabel]?.onFocus();

          // Conditionally trigger submit action based on configuration
          if (shortcutMap[keyLabel]!.onPress) {
            shortcutMap[keyLabel]?.onSubmit();
          }
        }
      }
    } else if (event is RawKeyUpEvent) {
      // Check for Alt key release to hide shortcut keys
      if (event.logicalKey == LogicalKeyboardKey.altLeft) {
        setState(() {
          isAltPressed = false;
        });
        widget.shortcutKeysVisible.value = false; // Hide labels
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the child with RawKeyboardListener to capture keyboard events
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: handleKeyPress,
      child: widget.child,
    );
  }
}

/// Represents a keyboard shortcut configuration with associated actions.
///
/// This class allows defining complex keyboard interactions for form fields
/// or other interactive widgets, providing granular control over focus and
/// submission behaviors.
class ShortcutFocus {
  /// The keyboard key representing the shortcut (lowercase).
  ///
  /// Used to match against pressed keys when Alt is held down.
  final String key;

  /// The [FocusNode] associated with the target widget or field.
  ///
  /// Provides programmatic control over widget focus.
  final FocusNode focusNode;

  /// A function to be called when the shortcut key is pressed to focus the widget.
  ///
  /// Typically calls [FocusNode.requestFocus()] to move cursor/focus to the widget.
  final Function onFocus;

  /// A function to be called when the shortcut key triggers a submission.
  ///
  /// Can be used to perform validation, save data, or trigger form submission.
  final Function onSubmit;

  /// Determines whether the [onSubmit] function should be called.
  ///
  /// If true, [onSubmit] is triggered along with [onFocus].
  /// If false, only [onFocus] is triggered, allowing for more controlled interactions.
  final bool onPress;

  /// Creates a [ShortcutFocus] configuration.
  ///
  /// [key] specifies the keyboard key.
  /// [focusNode] provides focus control for the target widget.
  /// [onFocus] defines the action to focus on the widget.
  /// [onSubmit] defines the action to submit or perform on the widget.
  /// [onPress] controls whether [onSubmit] is triggered.
  ShortcutFocus({
    required this.onPress,
    required this.key,
    required this.focusNode,
    required this.onFocus,
    required this.onSubmit,
  });
}