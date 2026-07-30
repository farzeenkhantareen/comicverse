# 🌌 ComicVerse

[![Flutter](https://img.shields.io/badge/Flutter-v3.5.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](file:///c:/Users/farze/Desktop/Comicverse/LICENSES.md)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](file:///c:/Users/farze/Desktop/Comicverse/pubspec.yaml)

ComicVerse is a premium, highly optimized offline comic & manga reader app built with Flutter. Featuring a gorgeous Material 3 design, smooth micro-animations, and fast performance powered by Riverpod and Hive, it delivers a beautiful, fully customizable, and completely local reading experience for your favorite digital collections.

---

## ✨ Features

- **📱 Exquisite Design:** Premium Material 3 styling (dark-first), modern typography via Google Fonts, and smooth micro-animations powered by `flutter_animate`.
- **📖 Premium Reader Engine:** Interactive comic & manga viewing with immersive layout modes and zoom support via `photo_view`.
- **⚡ Supercharged Offline Database:** Ultra-fast local performance, history tracking, bookmarks, and configurations using Hive & SQLite storage layers.
- **🛹 Dynamic Navigation & DI:** Declarative, modern routing using `go_router` and responsive state management with Riverpod 2.x.
- **✨ Easy Cataloging:** Add new comics easily by updating metadata in `catalog.json` and placing corresponding media files in `assets/`.

---

## 🛠️ Tech Stack & Packages

- **Core & UI Framework:** [Flutter SDK](https://flutter.dev) (Dart)
- **State Management:** `flutter_riverpod` & `riverpod_annotation`
- **Routing & Navigation:** `go_router`
- **Local Databases:** `hive_flutter` & `sqflite` (SQLite)
- **User Interface Extensions:** `google_fonts`, `flutter_animate`, `shimmer`, `smooth_page_indicator`, `carousel_slider`, `photo_view`, and `flutter_staggered_grid_view`

---

## 📂 Project Architecture

ComicVerse is built following **Clean Architecture** patterns, separating concerns cleanly across feature modules:

```
lib/
├── core/                    # Global core infrastructure
│   ├── constants/           # Centralized values (colors, metrics, copy strings)
│   ├── theme/               # Material 3 dark-first styling
│   ├── router/              # Declarative routes via GoRouter
│   └── di/                  # Riverpod global states
├── features/                # Domain features (Splash, Onboarding, Home, Search, Reader, Settings)
│   └── <feature_name>/
└── shared/                  # Reusable items
    ├── models/              # Clean entity definitions (Comic, Chapter)
    ├── repositories/        # Local metadata indexing (catalog.json parser)
    └── services/            # Storage layers (Hive initialization)
```

For a detailed breakdown of core components and data flows, please see the [ARCHITECTURE.md](file:///c:/Users/farze/Desktop/Comicverse/ARCHITECTURE.md).

---

## 🚀 Quick Setup & Installation

To run ComicVerse on your local machine:

1. **Clone the Repository:**
   ```bash
   git clone git@github.com:farzeenkhantareen/comicverse.git
   cd comicverse
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify and Run Tests:**
   ```bash
   flutter analyze
   ```
   ```bash
   flutter test
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

For detailed platform-specific requirements, visit [INSTALLATION.md](file:///c:/Users/farze/Desktop/Comicverse/INSTALLATION.md).

---

## 📄 Documentation Links

- [Architecture Design](file:///c:/Users/farze/Desktop/Comicverse/ARCHITECTURE.md)
- [Installation Guide](file:///c:/Users/farze/Desktop/Comicverse/INSTALLATION.md)
- [Attributions](file:///c:/Users/farze/Desktop/Comicverse/ATTRIBUTIONS.md)
- [Privacy Policy](file:///c:/Users/farze/Desktop/Comicverse/PRIVACY_POLICY.md)
- [Licenses](file:///c:/Users/farze/Desktop/Comicverse/LICENSES.md)

