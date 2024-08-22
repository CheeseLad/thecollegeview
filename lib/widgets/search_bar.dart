import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchChanged;

  const SearchBar(
      {super.key, required this.controller, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => onSearchChanged(),
      decoration: const InputDecoration(
        hintText: 'Search articles...',
        border: InputBorder.none,
      ),
    );
  }
}
