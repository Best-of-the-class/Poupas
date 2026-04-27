import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Extension para facilitar uso de medidas e tipo de dispositivo via context.
extension SizeExtensions on BuildContext {
  /// Retorna tamanho completo da tela.
  Size get screenSize => MediaQuery.of(this).size;
  /// Retorna largura da tela.
  double get width => screenSize.width;
  /// Retorna altura da tela.
  double get height => screenSize.height;

  /// Verifica se é celular. Menor que 600px
  bool get isMobile => width < AppBreakpoints.mobile;

  /// Verifica se é tablet. Entre 600px e 1023px
  bool get isTablet =>
      width >= AppBreakpoints.mobile &&
      width < AppBreakpoints.tablet;

  /// Verifica se é desktop. A partir de 1024px
  bool get isDesktop => width >= AppBreakpoints.tablet;

  /// Verifica se é desktop grande. A partir de 1440px
  bool get isLargeDesktop =>
      width >= AppBreakpoints.desktop;
}