import 'package:flutter/material.dart';

class SmartIndicator extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final bool isActive;
  final VoidCallback? onTap;
  final bool compact;

  const SmartIndicator({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    required this.isActive,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final primaryColor = theme.colorScheme.primary;
    // Dezenter Hintergrund: Wenn aktiv, ganz leichte Färbung, sonst fast transparent
    final surfaceColor = isActive 
        ? primaryColor.withValues(alpha: 0.1) 
        : theme.colorScheme.surfaceVariant.withValues(alpha: 0.2);
    final textColor = isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant;

    return Tooltip(
      message: description,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            // Dezenter Rahmen wie bei einer Textbox
            border: Border.all(
              color: isActive ? primaryColor.withValues(alpha: 0.5) : theme.dividerColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Der markante Buchstabe im Kreis
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : theme.colorScheme.outlineVariant,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Dezentes Wort daneben
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isActive && !compact)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.check_circle, size: 14, color: primaryColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
