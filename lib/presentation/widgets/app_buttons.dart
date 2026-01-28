import 'package:farmconnect/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = type == AppButtonType.primary;
    final Color backgroundColor = isPrimary
        ? AppTheme.primaryGreen
        : Colors.transparent;
    final Color contentColor = isPrimary ? Colors.white : AppTheme.primaryGreen;
    final Border? border = isPrimary
        ? null
        : Border.all(color: AppTheme.primaryGreen, width: 1.5);

    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: contentColor,
                          ),
                        ),
                      ),
                      if (icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(icon, size: 20, color: contentColor),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
