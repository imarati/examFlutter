import 'package:flutter/material.dart';

class ItemForm extends StatefulWidget {
  final String? initialName;
  final void Function(String name) onSubmit;

  const ItemForm({super.key, this.initialName, required this.onSubmit});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Добавить' : 'Редактировать'),
      content: TextField(controller: _controller),
      actions: [
        TextButton(
            onPressed: () {
              widget.onSubmit(_controller.text);
              Navigator.pop(context);
            },
            child: const Text("Сохранить"))
      ],
    );
  }
}
