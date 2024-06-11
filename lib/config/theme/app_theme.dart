import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          primary: Color(0xFFE6111C), // Color rojo de Netflix

          secondary: Colors.white, // Ajusta según sea necesario

          background: Colors.black12, // Color de fondo oscuro
          error: Color(0xFFB00020), // Color de error oscuro
          onPrimary: Colors.white, // Color de texto sobre el color primario
          onSecondary: Colors.white, // Color de texto sobre el color secundario
          onSurface:
              Colors.white, // Color de texto sobre el color de superficie
          onBackground: Colors.white, // Color de texto sobre el color de fondo
          onError: Colors.white, // Color de texto sobre el color de error
          brightness: Brightness.dark,
          surface: Colors.black12,
        ),
        brightness: Brightness.dark,
      );
}
