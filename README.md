# Flutter Firebase Task Manager

A real-time task management application built with Flutter and Firebase Firestore for CSC 4360. This app supports full CRUD operations and nested subtasks with live cloud synchronization.

## 🚀 Enhanced Features (Phase F)

To meet the requirements for Phase F, the following enhanced features were implemented:

1. **Nested Subtasks & Expansion UI**: Instead of a flat list, each task uses an `ExpansionTile`. Users can add specific sub-items to any task, which are stored as nested arrays in Firestore and updated in real-time.
2. **System Dark Mode Support**: The app implements `ThemeMode.system` within the `MaterialApp` configuration. It automatically toggles between a clean light theme and a battery-saving dark theme based on the user's device settings.
3. **Real-time Stream Integration**: Utilizing `StreamBuilder`, the app ensures that any change made in the Firebase Console or on another device is reflected instantly without a manual refresh.

## 🛠️ Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone [YOUR_GITHUB_URL_HERE]
   cd task_manager
