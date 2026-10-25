# Panel Académico Universitario · EPIIS UNSAAC

> **Proyecto Integrador — Unidad I**  
> **Asignatura:** Desarrollo de Software II  
> **Docente:** Mtro. Ing. Yover Collantes Valer  
> **Semestre Académico:** 2026-II  
> **Institución:** Universidad Nacional de San Antonio Abad del Cusco (UNSAAC)  
> **Facultad:** Facultad de Ingeniería Eléctrica, Electrónica, Informática y Mecánica  
> **Escuela:** Escuela Profesional de Ingeniería Informática y de Sistemas (EPIIS)  

---

## 👥 Integrantes — Grupo 03

| Código Estudiante | Apellidos y Nombres | Correo Institucional |
| :---: | :--- | :--- |
| **221451** | RODRÍGUEZ-CCOYTO-JAIRO JASER | `221451@unsaac.edu.pe` |
| **220552** | QUISPE-CHECYA-JOAN GONZALO | `220552@unsaac.edu.pe` |

---

## 🔐 Credenciales de Acceso al Sistema

Para ingresar a la plataforma a través de la pantalla de autenticación institucional:

* **Usuario 1:**
  * **Código de Estudiante:** `221451`
  * **Contraseña:** `123`
* **Usuario 2:**
  * **Código de Estudiante:** `220552`
  * **Contraseña:** `123`

---

## 🚀 Características Principales

1. **Autenticación Institucional Estricta:**
   * Validación formal contra el padrón de estudiantes y verificación de contraseñas registradas.
   * Manejo contextual de errores (código no registrado o contraseña incorrecta).
2. **Dashboard Académico Adaptativo:**
   * KPIs en tiempo real de cursos activos, tareas pendientes, entregas de la semana y horas de estudio.
   * Mini-calendario académico mensual interactivo y lista de eventos próximos.
3. **Mis Cursos (Estilo Google Classroom):**
   * Tarjetas modulares con cabeceras de color sólido de acuerdo al color identitario del curso.
   * Información oficial de horarios, aulas y docentes extraída del catálogo de la Intranet UNSAAC.
   * Indicador visual de progreso y contador de entregables pendientes.
4. **Gestión de Cursos y Tareas (CRUD Local Offline-first):**
   * Creación, edición y eliminación de asignaturas universitarias con selector de créditos, ciclo y color.
   * Registro de tareas y entregables con nivel de prioridad (Alta, Media, Baja), fecha límite y horas estimadas.
   * Persistencia transparente y continua mediante `SharedPreferences` y estructura inicial en `JSON`.
5. **Centro de Idiomas (CID - UNSAAC):**
   * Panel de acreditación y requisito de grado para Bachillerato (Ley Universitaria N° 30220).
   * Historial detallado de notas por ciclo para Inglés Regular (Módulos 1 al 10) y Quechua Nativo (Básico A2 acreditado).
   * Filtros por nivel (Básico / Intermedio) e indicadores de promedio ponderado y horas acumuladas.
6. **Línea Gráfica Institucional:**
   * Paleta oficial de colores UNSAAC: Granate (`#7A1B28`) y Dorado (`#9A7410`).
   * Contornos rectos y sobrios acordes a interfaces empresariales y de escritorio (Windows 10).

---

## 🛠️ Tecnologías y Arquitectura

* **Framework:** [Flutter](https://flutter.dev/) (SDK 3.x / Dart 3.x).
* **Plataformas Soportadas:** Web (Chrome, Edge), Windows Desktop, Android.
* **Persistencia:** `shared_preferences` con almacenamiento local estructurado en JSON.
* **Patrón de Arquitectura:** Capas desacopladas (Vistas, Widgets comunes, Modelos de dominio y Servicios de datos).
* **Calidad de Código:** `flutter analyze` con **0 errores y 0 advertencias**, pruebas unitarias y de widgets con cobertura del 100%.

---

## 💻 Instrucciones de Ejecución Local

### 1. Clonar el repositorio
```bash
git clone https://github.com/GabzoRabzo/desarrollo-software-2-proyecto-integrador-grupo03.git
cd desarrollo-software-2-proyecto-integrador-grupo03
```

### 2. Obtener dependencias
```bash
flutter pub get
```

### 3. Ejecutar en el navegador Web
```bash
flutter run -d chrome
```

### 4. Ejecutar en Windows Desktop
```bash
flutter run -d windows
```

### 5. Ejecutar pruebas automatizadas
```bash
flutter test
```

---

© 2026 Universidad Nacional de San Antonio Abad del Cusco – Todos los derechos reservados.
