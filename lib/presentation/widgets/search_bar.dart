import 'package:flutter/material.dart';

class StopSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onClear;
  final String initialValue;

  const StopSearchBar({
    Key? key,
    required this.onChanged,
    required this.onClear,
    this.initialValue = '',
  }) : super(key: key);

  @override
  State<StopSearchBar> createState() => _StopSearchBarState();
}

class _StopSearchBarState extends State<StopSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search stops...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onClear();
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged(value);
        },
      ),
    );
  }
}
