import 'package:flutter/material.dart';

import '../theme/neon_theme.dart';

/// Р“Р»Р°РІРЅРѕРµ РїРѕРґС‚РІРµСЂР¶РґР°СЋС‰РµРµ РґРµР№СЃС‚РІРёРµ: РіСЂР°РґРёРµРЅС‚ primary в†’ primaryContainer, pill (DESIGN.md).
class PrimaryGradientButton extends StatelessWidget {
  const PrimaryGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final neon = context.neon;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: neon.onPrimary,
          fontWeight: FontWeight.w600,
        );

    final borderRadius = BorderRadius.circular(neon.radiusPill);

    return AnimatedOpacity(
      opacity: onPressed == null ? 0.38 : 1,
      duration: const Duration(milliseconds: 120),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: neon.primaryGradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: neon.glowColor.withValues(alpha: 0.45),
              blurRadius: neon.blurLg,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            splashColor: neon.onPrimary.withValues(alpha: 0.10),
            highlightColor: neon.onPrimary.withValues(alpha: 0.06),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Center(
                child: DefaultTextStyle.merge(
                  style: labelStyle ??
                      TextStyle(
                        color: neon.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                  child: IconTheme.merge(
                    data: IconThemeData(color: neon.onPrimary, size: 20),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

