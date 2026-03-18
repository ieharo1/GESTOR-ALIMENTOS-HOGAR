# 🥚 Gestor de Alimentos Hogar

<p align="center">
  <img src="assets/logo.png" alt="Logo de la App" width="200"/>
</p>

---

## 📱 Descripción

**Gestor de Alimentos Hogar** es una aplicación móvil desarrollada en **Flutter** que permite gestionar alimentos almacenados en tu hogar:

- 🧊 **Refrigeración**: Alimentos refrigerados y congelados
- 🗄️ **Alacena**: Artículos almacenados en despensa
- 🛒 **Lista de Compras**: Productos agotados y recomendaciones

> La aplicación funciona **100% offline**, sin necesidad de conexión a internet.

---

## ✨ Características

### Funcionalidades Implementadas ✅

- ✅ **Gestión de Refrigeración** - Agregar, editar, eliminar productos refrigerados/congelados
- ✅ **Gestión de Alacena** - Agregar, editar, eliminar artículos de despensa
- ✅ **Lista de Compras Automática** - Productos agotados (cantidad = 0)
- ✅ **Recomendaciones Inteligentes** - Productos próximos a caducar y poco stock
- ✅ **Búsqueda en Tiempo Real** - Filtra productos por nombre
- ✅ **Persistencia Local** - Base de datos Hive (funciona offline)
- ✅ **Diseño Material Design 3** - Interfaz moderna y atractiva
- ✅ **Soporte Modo Claro/Oscuro** - Se adapta al sistema
- ✅ **Notificaciones** - Alertas de productos faltantes
- ✅ **Validaciones Completas** - Datos correctos siempre
- ✅ **UI Animada** - Transiciones suaves
- ✅ **Botón Regresar** - En todas las pantallas

### Próximamente 🔄

- 🔔 **Notificaciones Programadas** - Recordatorios de caducidad
- 📊 **Estadísticas** - Gráficos de consumo
- 📤 **Exportar/Importar** - Respaldo de datos
- 🌐 **Sincronización Cloud** - Backup en la nube
- 👥 **Múltiples Usuarios** - Cuenta familiar
- 📱 **Versión iOS** - Para iPhone/iPad

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Framework | Flutter | 3.41.x |
| Lenguaje | Dart | 3.11.x |
| Estado | Provider | 6.1.x |
| Base de Datos | Hive | 2.2.x |
| Notificaciones | flutter_local_notifications | 18.0.x |
| Diseño | Material Design 3 | - |

---

## 📁 Estructura del Proyecto

```
GESTOR-ALIMENTOS-HOGAR/
├── 📂 lib/
│   ├── 📂 core/
│   │   └── constants/
│   │       └── app_constants.dart
│   ├── 📂 data/
│   │   ├── 📂 database/
│   │   │   └── database_service.dart
│   │   ├── 📂 models/
│   │   │   └── food_item.dart
│   │   ├── 📂 repositories/
│   │   │   └── food_repository.dart
│   │   └── 📂 services/
│   │       └── notification_service.dart
│   ├── 📂 presentation/
│   │   ├── 📂 providers/
│   │   │   └── food_provider.dart
│   │   ├── 📂 screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── refrigeracion_screen.dart
│   │   │   ├── alacena_screen.dart
│   │   │   ├── shopping_list_screen.dart
│   │   │   └── about_screen.dart
│   │   └── 📂 widgets/
│   │       ├── food_item_card.dart
│   │       └── add_food_item_form.dart
│   └── main.dart
├── 📂 assets/
│   └── logo.png
├── 📂 android/
├── 📂 ios/
├── pubspec.yaml
└── README.md
```

---

## 📥 Descargar e Instalar

### 📱 Android

[![Descargar APK](https://img.shields.io/badge/Descargar-APK-blue?style=for-the-badge&logo=android)](build/app/outputs/flutter-apk/app-debug.apk)

**O instálalo manualmente:**
1. Descarga el archivo `app-debug.apk`
2. Transfiérelo a tu teléfono Android
3. Ábrelo e instálalo (permite fuentes desconocidas)
4. ¡Listo! 🐟

### 📋 Requisitos

- Android 5.0+ (API 21 o superior)
- Espacio: ~25 MB

---

## 🚀 Cómo Ejecutar el Proyecto

### 1. Clonar el Repositorio
```bash
git clone https://github.com/ieharo1/GESTOR-ALIMENTOS-HOGAR.git
cd GESTOR-ALIMENTOS-HOGAR
```

### 2. Instalar Dependencias
```bash
flutter pub get
```

### 3. Ejecutar en Emulador/Dispositivo
```bash
flutter run
```

### 4. Compilar APK Debug
```bash
flutter build apk --debug
```

### 5. Compilar APK Release
```bash
flutter build apk --release
```

---

## 📖 Cómo Usar la App

### 🏠 Pantalla Principal
- Toca **Refrigeración** o **Alacena** para gestionar productos
- Toca **Lista de Compras** para ver productos faltantes
- Toca **Acerca de** para información del desarrollador

### ➕ Agregar Producto
1. Toca el botón **"+"** (FAB)
2. Completa el formulario:
   - Nombre del producto
   - Cantidad (puede ser 0 si está agotado)
   - Fecha de ingreso
   - Tipo (Refrigerado/Congelado - solo en Refrigeración)
3. Toca **"Guardar"**

### ✏️ Editar Producto
1. Toca el ícono de **editar** (lápiz) en la tarjeta
2. Modifica los datos
3. Toca **"Actualizar"**

### 🗑️ Eliminar Producto
1. Toca el ícono de **eliminar** (basura)
2. Confirma la eliminación

### 🔍 Buscar Producto
- Escribe en la barra de búsqueda para filtrar

### 🛒 Lista de Compras
- **Por Comprar**: Productos con cantidad = 0
- **Recomendaciones**: Productos con poco stock o por caducar
- Toca **"+"** para indicar cuánto compraste

---

## 💾 Base de Datos

La app usa **Hive** para persistencia local:

```
FoodItem {
  id: String (UUID)
  category: String ("Refrigeración" / "Alacena")
  type: String? ("Refrigerado" / "Congelado")
  name: String
  quantity: int
  entryDate: DateTime
  expirationDate: DateTime
}
```

---

## 👨‍💻 Desarrollado por Isaac Esteban Haro Torres

**Ingeniero en Sistemas · Full Stack Developer · Automatización · Data**

### 📞 Contacto

- 📧 **Email:** zackharo1@gmail.com
- 📱 **WhatsApp:** [+593 988055517](https://wa.me/593988055517)
- 💻 **GitHub:** [ieharo1](https://github.com/ieharo1)
- 🌐 **Portafolio:** [ieharo1.github.io](https://ieharo1.github.io/portafolio-isaac.haro/)

---

## 📄 Licencia

© 2026 Isaac Esteban Haro Torres - Todos los derechos reservados.

---

⭐ Si te gustó el proyecto, ¡dame una estrella en GitHub!
