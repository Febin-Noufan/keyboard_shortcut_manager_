# Keyboard Shortcut Listener

A Flutter package that provides an advanced keyboard shortcut listener with dynamic visibility and configurable actions.

## Features

- Enable keyboard shortcuts with complex interactions
- Dynamic shortcut key visibility
- Configurable focus and submit actions
- Alt-key based shortcut activation

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_shortcut_listener: ^0.1.0
```

## Usage

```dart
import 'package:keyboard_shortcut_listener/keyboard_shortcut_listener.dart';
import 'package:flutter/material.dart';

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _shortcutKeysVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcutListener(
      shortcutKeysVisible: _shortcutKeysVisible,
      shortcuts: [
        ShortcutFocus(
          key: 'n',
          focusNode: _nameFocusNode,
          onFocus: () => _nameFocusNode.requestFocus(),
          onSubmit: () {}, // Optional
          onPress: false,
        ),
        ShortcutFocus(
          key: 'e',
          focusNode: _emailFocusNode,
          onFocus: () => _emailFocusNode.requestFocus(),
          onSubmit: () {}, // Optional
          onPress: false,
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Shortcut Behavior

- Press `Alt` to show shortcut keys
- Release `Alt` to hide shortcut keys
- While `Alt` is pressed, use configured keys to interact with form fields

## Parameters

### `KeyboardShortcutListener`
- `child`: The widget to wrap with keyboard shortcut functionality
- `shortcuts`: List of `ShortcutFocus` configurations
- `shortcutKeysVisible`: Controls shortcut key visibility

### `ShortcutFocus`
- `key`: Keyboard shortcut key (lowercase)
- `focusNode`: Focus control for the target widget
- `onFocus`: Action to focus on the widget
- `onSubmit`: Action to submit or perform on the widget
- `onPress`: Controls whether `onSubmit` is triggered

## Limitations
- Currently supports Alt-key based shortcuts
- Designed primarily for form interactions

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
