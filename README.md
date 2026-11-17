# SUnite

*Find your group at Sabancı.*

SUnite is a Flutter mobile app, exclusive to Sabancı University students, for finding and forming groups of any kind. Students post and browse listings on category boards (**Course Groups**, **Erasmus**, **Startups & Projects** and **Events**), either as an existing group looking for new members or as a student looking for a group to join. Accounts are limited to `@sabanciuniv.edu` e-mail addresses, and data is stored in Firebase (Authentication + Cloud Firestore).

This repository is developed for **CS310 Mobile Application Development**, Sabancı University, 2026-2027 Fall.

## Group 32

| Member | Student ID |
| --- | --- |
| Azra At | 34090 |
| Ece Ulutaş | 35589 |
| Elif Çamlıkaya | 35191 |
| Mert Ali İlter | 34447 |

## Running the app

Built and tested with **Flutter 3.47.8** (stable channel, Dart 3.13.7) on an Android emulator (Pixel 8, API 35).

1. Start an Android emulator (Android Studio → Device Manager → ▶).
2. From the project root, run:

```bash
flutter pub get
flutter run
```

Checks: `flutter analyze` (lints) and `flutter test` (widget tests).

## Repository structure

- `lib/main.dart`: app entry point, theme and routes
- `lib/screens/`: one folder per screen; `main_shell.dart` holds the bottom navigation bar
- `lib/utils/`: shared colors, text styles, spacing and theme
- `assets/`: Inter font and images
- `test/`: widget tests
- `docs/`: project documents (Step 1 proposal, Step 2.1 wireframes)

## Credits

Font: [Inter](https://github.com/rsms/inter), SIL Open Font License 1.1.
