// lib/src/shortcut_visibility_manager.dart
import 'package:flutter/foundation.dart';

/// Manages the global visibility state of keyboard shortcuts.
///
/// This singleton class provides a centralized way to control and track
/// the visibility of shortcut keys across the application.
///
/// Usage:
/// ```dart
/// final visibilityManager = ShortcutVisibilityManager();
/// visibilityManager.setShortcutKeysVisible(true);
/// ```
class ShortcutVisibilityManager {
  /// Private singleton instance of the manager.
  static final ShortcutVisibilityManager _instance =
      ShortcutVisibilityManager._internal();

  /// Factory constructor to return the singleton instance.
  factory ShortcutVisibilityManager() {
    return _instance;
  }

  /// Private constructor to prevent direct instantiation.
  ShortcutVisibilityManager._internal();

  /// Internal [ValueNotifier] to track shortcut key visibility.
  final ValueNotifier<bool> _shortcutKeysVisible = ValueNotifier<bool>(false);

  /// Provides access to the shortcut visibility notifier.
  ///
  /// Can be used with [ValueListenableBuilder] to react to visibility changes.
  ValueNotifier<bool> get shortcutKeysVisibleNotifier => _shortcutKeysVisible;

  /// Sets the visibility state of shortcut keys.
  ///
  /// [value] determines whether shortcut keys should be visible.
  /// Only updates if the new value differs from the current state.
  ///
  /// Example:
  /// ```dart
  /// visibilityManager.setShortcutKeysVisible(true); // Shows shortcut keys
  /// ```
  void setShortcutKeysVisible(bool value) {
    if (_shortcutKeysVisible.value != value) {
      _shortcutKeysVisible.value = value;
    }
  }

  /// Checks the current visibility state of shortcut keys.
  ///
  /// Returns `true` if shortcut keys are currently visible, `false` otherwise.
  bool get shortcutKeysVisible => _shortcutKeysVisible.value;
}
