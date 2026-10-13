# DanBudget 💰

> A smart budget, commitment, and debt payoff planner designed for young adults. Built with Flutter & Riverpod.

---

## 📱 Features

- **Safe-to-Spend & Smart Allocation**: Calculates realistic daily and monthly spending limits based on your actual income and fixed obligations.
- **Commitments & Debt Tracking**: Track credit cards, personal loans, and buy-now-pay-later (e.g., SPayLater) installments with repayment simulations.
- **Financial Health Score**: Real-time health score assessment to keep your debt-to-income ratio and savings in check.
- **Account & Cash Management**: Monitor "Money on Hand" across accounts and cash wallets with quick balance adjustments and transfers.
- **Privacy & Security**: Built-in biometric lock and local-first data storage (Drift / SQLite) — your financial data stays securely on your device.
- **Sleek Dark Theme**: Designed with an emerald and navy dark theme for a pleasant, modern experience.

---

## 🚀 Trying Out the App

### Option 1: Install the Android APK (Quickest)
You can directly download and install the pre-built APK without installing Flutter or Android Studio:
1. Go to the [Releases](https://github.com/AdamDuke1956/DanBudget/releases) section.
2. Download `DanBudget-v1.5.5.apk`.
3. Open the downloaded `.apk` file on your Android device to install.

### Option 2: Run from Source

#### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.7.2 or higher)
- Android Studio / VS Code with Flutter extension
- Connected physical device or emulator

#### Setup & Run
```bash
# Clone the repository
git clone https://github.com/AdamDuke1956/DanBudget.git
cd DanBudget

# Install dependencies
flutter pub get

# Run code generator for database models (if modifying schemas)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

## 🛠️ Built With

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Local Database**: [Drift](https://drift.simonbinder.eu) (SQLite)
- **Charts & Visualizations**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Security & Storage**: `flutter_secure_storage`, `local_auth`
- **Typography**: [Google Fonts](https://fonts.google.com)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📱 Feedback UAT Google Form Link:- (https://forms.gle/raVBpf8QP1p8RuV27)
