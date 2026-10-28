# Mentis AI (Flutter + Firebase) - Phase 1-2 foundation

## Status (honest)
| Item | State |
|---|---|
| Source written | Theme, navigation, welcome, login, register, forgot password, Google sign-in, session restore, sign-out, Firestore profile creation, Firestore/Storage rules |
| Compiled / analyzed / tested | NO. Written in an environment without Flutter or network. Run the commands below and send me any errors. |
| Firebase configured | NO. You must supply your own google-services.json. |
| Rules deployed | NO. Files only. |
| Not built yet | Dashboard data, papers, notes, assistant, learning, literature review, graph, search, analytics, quizzes, flashcards, Storage upload, theme persistence, account linking |

## Setup
1. Install Flutter (stable), Android Studio SDK, VS Code + Flutter extension.
2. In this folder generate the Android platform files:
   flutter create . --platforms=android --org com.mentis --project-name mentis_ai
   (existing lib/ and pubspec.yaml are kept; if pubspec is changed, re-check dependencies.)
3. Firebase console: create a project, add an Android app (package com.mentis.mentis_ai, or your own),
   download google-services.json into android/app/.
4. Enable Authentication: Email/Password and Google. Add your debug SHA-1 and SHA-256
   (cd android && ./gradlew signingReport). Re-download google-services.json afterwards.
5. Add the Google Services Gradle plugin per the FlutterFire docs; set minSdkVersion 23.
6. Create Firestore and Storage, then: firebase deploy --only firestore:rules,storage
7. Run: flutter pub get && flutter analyze && flutter run
8. APK: flutter build apk --debug (release: use your own keystore, never commit it).

## Notes
- No AI key is used or needed. A future AiService should call a Cloud Function.
- Demo mode is a local flag; it never authenticates.
- Google/email account conflicts show a message; real linking is not implemented yet.
