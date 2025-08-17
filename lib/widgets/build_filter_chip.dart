import 'package:flutter/material.dart';

class BuildFilterChip extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool isSelected;
  final VoidCallback? onTap;

  const BuildFilterChip({
    Key? key,
    required this.label,
    required this.isDark,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.green.withOpacity(0.3)
                    : Colors.green.withOpacity(0.2))
              : (isDark
                    ? Colors
                          .grey
                          .shade800 // WhatsAppTheme.darkContainer
                    : Colors
                          .grey
                          .shade200 // WhatsAppTheme.lightContainer
                          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.green
                : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
