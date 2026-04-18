# 🎨 Theme System do Projeto

Este diretório contém o sistema de tema global do aplicativo, responsável por padronizar cores, tipografia e aparência geral da interface.

A separação em arquivos diferentes garante organização, escalabilidade e consistência visual em todo o app.

Os arquivos relativos ao tema do aplicativo se encontram em: `lib\core\theme`.

---

## 📁 `app_colors.dart`

### Descrição
Arquivo responsável por centralizar todas as cores utilizadas no aplicativo.

### Responsabilidades
- Definir paleta de cores principal do app
- Padronizar cores de texto (claro, escuro e títulos)
- Definir cores semânticas (erro, sucesso, alerta, etc.)
- Evitar uso de cores "hardcoded" espalhadas pelo código

### Exemplo de uso
```dart
AppColors.primary
AppColors.background
AppColors.error
```

## 📁 `app_text_styles.dart`
### Descrição
Arquivo responsável por definir e centralizar todos os estilos de texto do aplicativo.

### Responsabilidades
- Definir tipografia padrão do app
- Padronizar estilos de título, corpo e subtítulos
- Garantir consistência visual entre telas
- Facilitar manutenção global de fontes

### Exemplo de uso
```dart
AppTextStyles.title
AppTextStyles.body
AppTextStyles.subtitle
```

## 📁 app_theme.dart
### Descrição
Arquivo responsável por configurar o tema global do aplicativo Flutter.

### Responsabilidades
- Unificar cores e tipografia em um único tema
- Configurar ThemeData do Flutter
- Definir estilos padrão para widgets globais
- Garantir consistência visual em todo o app

### Exemplo de uso
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
)
```

### Exemplo interno
```dart
ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    titleLarge: AppTextStyles.title,
    bodyMedium: AppTextStyles.body,
  ),
)
```