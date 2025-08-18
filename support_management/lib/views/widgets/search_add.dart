import 'package:flutter/material.dart';

class SearchAndAdd extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onAdd;
  final VoidCallback? onFilter;
  final bool showAdd;
  final bool showFilter;

  const SearchAndAdd({
    Key? key,
    required this.controller,
    this.onAdd,
    this.showAdd = true,
    this.onFilter,
    this.showFilter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search bar
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Rechercher',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/Search.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      );
                    },
                  ),
                ),
                suffixIcon: showFilter
                    ? GestureDetector(
                        onTap: () {
                          if (onFilter != null) {
                            onFilter!();
                          } else {
                            Navigator.pushNamed(context, '/home/filter');
                          }
                        },
                        child: Icon(
                          Icons.tune,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // optional: implement search callback
                // print('Search query: $value');
              },
              onFieldSubmitted: (value) {
                // optional: implement
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Add ticket button (optional)
        if (showAdd)
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }
}
