import 'package:flutter/material.dart';

typedef OnSearchCallback = void Function(String query);

typedef OnClearCallback = void Function();

class CustomSearchBar extends StatelessWidget {
  final OnSearchCallback onSearch;
  final OnClearCallback? onClear;

  const CustomSearchBar({
    required this.onSearch,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          onSearch(value.trim());
        },
        decoration: InputDecoration(
          hintText: 'Search tasks, events, notes...',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    if (onClear != null) {
                      onClear!();
                    }
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
