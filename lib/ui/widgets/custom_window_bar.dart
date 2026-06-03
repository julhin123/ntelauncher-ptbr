import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../core/services/window_service.dart';

class CustomWindowBar extends StatelessWidget {
  final WindowService windowService;
  final VoidCallback? onSettingsPressed;

  const CustomWindowBar({
    super.key,
    required this.windowService,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => windowManager.startDragging(),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onSettingsPressed != null)
                    _WindowButton(
                      icon: Icons.settings,
                      onPressed: onSettingsPressed!,
                    ),
                  _WindowButton(
                    icon: Icons.minimize,
                    onPressed: () => windowService.minimize(),
                  ),
                  _WindowButton(
                    icon: Icons.close,
                    onPressed: () => windowService.close(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _WindowButton({required this.icon, required this.onPressed});

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.7),
          ),
        ),
      ),
    );
  }
}
