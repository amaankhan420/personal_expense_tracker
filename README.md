# 💸 Personal Expense Tracker

A Flutter application for tracking personal expenses, managing budgets, and visualizing spending
habits.

---

## 📱 Features

- Add, edit, and delete expenses
- Set a monthly budget
- Visual analytics with pie and bar charts
- Expense summary and filtering
- Persistent local storage using SQLite
- Light & dark theme toggle (saved with SharedPreferences)

---

## 📂 Folder Structure

lib/
├── constants/ # Constant values like categories
├── data/
│ ├── databases/ # SQLite helper
│ └── shared_pref/ # SharedPreferences files
├── models/ # Data models for budget and expense
├── providers/ # State management using Provider
├── screens/ # Main UI screens
├── widgets/ # Reusable UI components
└── main.dart # App entry point

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  sqflite: ^2.3.2
  shared_preferences: ^2.5.3
  path_provider: ^2.1.3
  path: ^1.9.0
  intl: ^0.19.0
  fl_chart: ^0.65.0
```

---

## 🚀 Getting Started

1. Clone the repository:
   git clone https://github.com/amaankhan420/personal_expense_tracker.git
   cd personal_expense_tracker

2. Install dependencies:
   flutter pub get

3. Run the app:
   flutter run

---

## 🎨 App Icon Setup

1. To change the app icon, replace the image at:
   assets/icon/app_icon.png

2. Then run:
   flutter pub run flutter_launcher_icons

Note: Ensure flutter_launcher_icons is listed under dev_dependencies and configured in pubspec.yaml.

---

## 🛠 Future Improvements

Cloud sync (Firebase)
Category-based budgets
PDF export of monthly summaries

---

## 📃 License

You can name this file `README.md` and place it at the root of your Flutter project.

