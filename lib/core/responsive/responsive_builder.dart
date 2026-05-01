import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Widget responsável por trocar layouts automaticamente conforme a largura da tela.
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // Captura largura atual da tela
    final width = MediaQuery.of(context).size.width;

    // Se largura for igual ou maior que tablet,usa layout desktop.
    if (width >= AppBreakpoints.tablet) {
      return desktop;
    }
    // Se largura for igual ou maior que mobile, usa layout tablet. Caso tablet não exista, usa mobile.
    if (width >= AppBreakpoints.mobile) {
      return tablet ?? mobile;
    }
    // Caso contrário, usa layout mobile.
    return mobile;
  }
}