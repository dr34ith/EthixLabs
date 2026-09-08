import 'package:flutter/material.dart';

import 'library_card.dart' show kLibraryCrimson;

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _hasText = false);
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // dark charcoal, was bluish-purple
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused
              ? kLibraryCrimson
              : kLibraryCrimson.withOpacity(0.28), // subtle red at rest
          width: _isFocused ? 1.4 : 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        onChanged: (value) {
          setState(() => _hasText = value.isNotEmpty);
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          hintText: 'Search resources...',
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF6E6E7E)),
          prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF6E6E7E)),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Color(0xFF6E6E7E)),
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}