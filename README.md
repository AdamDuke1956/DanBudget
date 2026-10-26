# DanBudget 💰

> A smart budget, commitment, and debt payoff planner designed for young adults. Built with Flutter & Riverpod.

---

## 📱 Features

- **Safe-to-Spend & Smart Allocation**: Calculates realistic daily and monthly spending limits based on your actual income and fixed obligations.
- **Commitments & Debt Tracking**: Track credit cards, personal loans, and buy-now-pay-later (e.g., SPayLater) installments with repayment simulations.
- **Financial Health Score**: Real-time health score assessment to keep your debt-to-income ratio and savings in check.
- **Account & Cash Management**: Monitor "Money on Hand" across accounts and cash wallets with quick balance adjustments and transfers.
- **Malaysian Personal Income Tax Optimization Engine (LHDN Form BE — v1.6.0)**:
  - **6-Step Statutory Calculation**: Automatically computes Total Annual Gross Income, Statutory Reliefs (`Pelepasan Cukai`), Chargeable Income (`Pendapatan Bercukai`), Resident Progressive Tax Brackets (0% – 30%), Tax Rebates (RM400 Individual Rebate if Chargeable Income `<= RM35,000` + 1:1 Zakat/Fitrah Rebate), and Final Tax Payable / Refund (`PCB Paid - Final Calculated Tax`).
  - **11 Strict LHDN Relief Buckets & Sub-Caps**: Tracks Individual (RM9,000), Lifestyle / Gaya Hidup shared RM2,500 pot (including AI subscriptions like ChatGPT Plus, Claude Pro, GitHub Copilot), Sports & Fitness RM1,000 pot (excluding sports shoes/apparel), Medical & Healthcare RM10,000 pot (with RM1,000 sub-caps for Checkup/Mental Health, Dental, and Vaccinations), Medical/Education Insurance (RM4,000), Life Insurance & EPF (RM7,000 total / RM4,000 EPF sub-cap), PRS (RM3,000), Self Education (RM7,000 total / RM2,000 Upskilling sub-cap), SOCSO & EIS (RM350), SSPN Net Savings (RM8,000), and First-Time Homebuyer Loan Interest (up to RM7,000 / RM5,000).
  - **Receipt Auto-Classifier & Marginal Tax Impact Simulator**: Maps transactions to legal LHDN buckets, reports remaining cap headroom, calculates exact cash saved based on your marginal tax bracket, warns on saturated caps, and enforces the 7-year LHDN receipt retention alert.
- **Privacy & Security**: Built-in biometric lock and local-first data storage (Drift / SQLite) — your financial data stays securely on your device.
- **Sleek Dark Theme**: Designed with an emerald and navy dark theme for a pleasant, modern experience.

---

## 🚀 Trying Out the App

### Option 1: Install the Android APK (Quickest)
You can directly download and install the pre-built APK without installing Flutter or Android Studio:
1. Go to the [Releases](https://github.com/AdamDuke1956/DanBudget/releases) section.
2. Download `DanBudget-v1.6.0.apk`.
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
