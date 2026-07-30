# ComicVerse Architecture

ComicVerse follows **Clean Architecture** patterns adapted for Flutter projects:

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

## State Management
State is managed reactively using **Riverpod 2.x**. Business logic has no direct dependency on UI elements.

## Local Storage
- **Hive**: Used for super fast reading history, bookmark states, and global user configs.
- **SQLite**: Available when raw relational DB indexes are needed for large volume expansions.
