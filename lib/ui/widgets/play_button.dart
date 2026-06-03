import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlayButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const PlayButton({
    super.key,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.isEnabled && widget.onPressed != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isClickable ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isClickable
                ? RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: _isHovered ? 0.9 : 0.7),
                      AppColors.primaryDark.withValues(alpha: _isHovered ? 0.8 : 0.5),
                    ],
                  )
                : null,
            color: isClickable ? null : AppColors.disabled.withValues(alpha: 0.5),
            boxShadow: isClickable
                ? [
                    BoxShadow(
                      color: AppColors.playGlow.withValues(alpha: _isHovered ? 0.6 : 0.3),
                      blurRadius: _isHovered ? 30 : 15,
                      spreadRadius: _isHovered ? 5 : 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              Icons.play_arrow_rounded,
              size: 64,
              color: isClickable
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
