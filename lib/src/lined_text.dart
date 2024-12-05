// lib/src/lined_text.dart
import 'package:flutter/material.dart';

import 'package:keyboard_shortcut_listener/main.dart';

/// A text widget that supports dynamic shortcut key display and interaction.
///
/// Provides an enhanced text widget that can:
/// - Extract and register keyboard shortcuts
/// - Toggle shortcut key visibility
/// - Underline shortcut keys when visible
///
/// Usage:
/// ```dart
/// LinedText(
///   text: '&New File',
///   onShortcutTriggered: () => createNewFile(),
/// )
/// ```
class LinedText extends StatefulWidget {
  /// The text to be displayed, potentially containing a shortcut key.
  final String text;

  /// Optional style for the text.
  final TextStyle? style;

  /// Callback triggered when the shortcut is activated.
  final VoidCallback? onShortcutTriggered;

  // Additional optional text rendering parameters
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final StrutStyle? strutStyle;

  const LinedText({
    super.key,
    required this.text,
    this.style,
    required this.onShortcutTriggered,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.strutStyle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LinedTextState createState() => _LinedTextState();
}

/// State management for [LinedText].
class _LinedTextState extends State<LinedText> {
  /// The extracted shortcut key from the text.
  String? _shortcutKey;

  @override
  void initState() {
    super.initState();
    // Extract and register the shortcut key when the widget is initialized
    _shortcutKey = _extractShortcutKey(widget.text);

    if (_shortcutKey != null && widget.onShortcutTriggered != null) {
      KeyboardShortcutListener.registerShortcut(
        _shortcutKey!,
        widget.onShortcutTriggered!,
      );
    }
  }

  @override
  void dispose() {
    // Unregister the shortcut when the widget is disposed
    if (_shortcutKey != null) {
      KeyboardShortcutListener.unregisterShortcut(_shortcutKey!);
    }
    super.dispose();
  }

  /// Extracts the shortcut key from the text.
  ///
  /// Looks for a character preceded by '&' and returns it as the shortcut key.
  ///
  /// Example:
  /// - '&New File' returns 'n'
  /// - 'Save &As' returns 'a'
  String? _extractShortcutKey(String text) {
    final ampersandIndex = text.indexOf('&');
    if (ampersandIndex >= 0 && ampersandIndex + 1 < text.length) {
      return text[ampersandIndex + 1].toLowerCase();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to react to shortcut visibility changes
    return ValueListenableBuilder<bool>(
      valueListenable: ShortcutVisibilityManager().shortcutKeysVisibleNotifier,
      builder: (context, shortcutKeysVisible, child) {
        return GestureDetector(
          onTap: widget.onShortcutTriggered,
          child: _buildLinedText(
            widget.text,
            shortcutKeysVisible,
            widget.style,
          ),
        );
      },
    );
  }

  /// Builds the text widget with optional shortcut key underlining.
  ///
  /// Handles different rendering based on shortcut key visibility.
  Widget _buildLinedText(
    String text, 
    bool shortcutKeysVisible, 
    TextStyle? style,
  ) {
    final ampersandIndex = text.indexOf('&');

    // If no '&' is found, render text normally
    if (ampersandIndex < 0) {
      return Text(
        text,
        style: style,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap ?? true,
        overflow: widget.overflow ?? TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
        strutStyle: widget.strutStyle,
      );
    }

    final beforeAmpersand = text.substring(0, ampersandIndex);
    final shortcutKey = text[ampersandIndex + 1];
    final afterAmpersand =
        ampersandIndex + 2 < text.length ? text.substring(ampersandIndex + 2) : '';

    // If shortcut keys are not visible, render text without '&'
    if (!shortcutKeysVisible) {
      return Text(
        beforeAmpersand + shortcutKey + afterAmpersand,
        style: style,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap ?? true,
        overflow: widget.overflow ?? TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
        strutStyle: widget.strutStyle,
      );
    }

    // Render text with shortcut key underlined
    return RichText(
      text: TextSpan(
        style: style ?? const TextStyle(color: Colors.black, fontSize: 16),
        children: [
          TextSpan(text: beforeAmpersand),
          TextSpan(
            text: shortcutKey,
            style: (style ?? const TextStyle()).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: afterAmpersand),
        ],
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap ?? true,
      overflow: widget.overflow ?? TextOverflow.ellipsis,
      maxLines: widget.maxLines,
      strutStyle: widget.strutStyle,
    );
  }
}