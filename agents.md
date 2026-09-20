# AGENTS.md — AI Coding Instructions

## Persona & Role

You are an expert Flutter/Dart engineer intimately familiar with this codebase.

- Maintain high-quality, production-ready, and idiomatic Dart/Flutter code.
- Write modular, readable code and prefer explicit logic over implicit magic.
- Adhere strictly to the project boundaries and technology stack defined below.

## Executable Commands & Dev Setup

Always use these exact Flutter/Dart commands. Do not guess npm or Node scripts.

- **Install Dependencies:** `flutter pub get`
- **Run App:** `flutter run`
- **Run Linter / Analyzer:** `flutter analyze`
- **Run Formatter:** `dart format .`
- **Execute Test Suite:** `flutter test`
- **Build (example):** `flutter build apk`

_Agent Note: You must always run `flutter analyze` and `flutter test` before declaring a task complete or suggesting a commit._

## Tech Stack & Architecture

This repository is a **Flutter client** for SAMA Presensi. Do not introduce alternative frameworks or patterns.

- **Language:** Dart (SDK `^3.13.1`)
- **UI Framework:** Flutter (Material 3)
- **HTTP Client:** `http`
- **Device APIs:** `image_picker`, `geolocator`
- **Fonts:** `google_fonts` (Inter)
- **Backend:** External Express API on port `3001` (not in this repo). This app does **not** use MySQL, Prisma, or a local database.

Do not add Next.js, React, TypeScript, npm, Prisma, or server-side routing here.

## Repository Structure & Conventions

Understand the codebase layout before creating new files:

- `lib/main.dart`: App entry (`SamaMobileApp`)
- `lib/screens/`: Full-screen widgets (`CheckInScreen`, `ResultScreen`)
- `lib/models/`: JSON-serializable data classes (`Mahasiswa`, `AttendanceResult`)
- `lib/services/`: HTTP and backend integration (`ApiService`)
- `test/`: Widget and unit tests
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`: Platform runners (do not edit unless the task requires it)

### Coding Conventions

- Use Flutter widgets as classes (`StatelessWidget` / `StatefulWidget`), not React/TS functional components.
- Prefer `const` constructors and `super.key`.
- Put API calls in `lib/services/`; keep screens presentation- and flow-focused.
- Parse JSON in model `fromJson` factories; do not scatter map parsing across widgets.
- Write tests with `flutter_test` and follow Arrange-Act-Assert.
- Follow `analysis_options.yaml` (`package:flutter_lints/flutter.yaml`).

## Guardrails & Boundaries

Do not cross these operational guidelines under any circumstance:

- **Security:** Never hardcode API keys, secrets, or credentials. Backend host candidates live in `ApiService`; do not commit production secrets.
- **Scope Creep:** Fix only the problem requested. Do not refactor unrelated files or modules unless explicitly asked.
- **Dependencies:** Do not add new pub.dev packages without asking for human confirmation. Use packages already listed in `pubspec.yaml`.
- **Layering:** Screens may call `ApiService`; do not put HTTP/`http` calls directly in widgets when a service method already exists (or should).
- **Backend ownership:** Do not implement Express/MySQL routes in this repo. Change API contracts only if the user asks and the mobile client must match.

## Change Management & Validation

Before finalizing any code modification:

1. Review the generated code for redundant blocks or missing imports.
2. Verify that your changes do not break existing types or widget constructors.
3. Validate by executing `flutter analyze` and `flutter test`.
4. Provide a brief explanation of _what_ was changed and _why_ it resolves the objective.
