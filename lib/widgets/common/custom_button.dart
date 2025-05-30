import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class custom_button extends StatelessWidget {
  final String text;
  final VoidCallback? on_pressed;
  final bool is_loading;
  final Color? background_color;
  final Color? text_color;
  final Color? border_color;
  final Widget? icon;
  final double? width;
  final double height;

  const custom_button({
    super.key,
    required this.text,
    this.on_pressed,
    this.is_loading = false,
    this.background_color,
    this.text_color,
    this.border_color,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_enabled = on_pressed != null && !is_loading;
    final Color bg_color = background_color ?? 
        (is_enabled ? app_colors.primary : Colors.grey[300]!);
    final Color txt_color = text_color ?? 
        (background_color == null ? Colors.white : Colors.black87);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: is_enabled ? on_pressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg_color,
          foregroundColor: txt_color,
          elevation: is_enabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: border_color != null 
                ? BorderSide(color: border_color!) 
                : BorderSide.none,
          ),
        ),
        child: is_loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: txt_color,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
