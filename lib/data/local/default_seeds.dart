import 'app_database.dart';

class DefaultSeeds {
  static const List<ExpenseCategoriesTableData> defaultCategories = [
    ExpenseCategoriesTableData(
      id: 'food',
      name: 'Food & Dining',
      icon: '🍜',
      colorHex: 0xFFFF9F43, // Amber/Orange
      bucket: 'needs',
      isCustom: false,
      sortOrder: 0,
    ),
    ExpenseCategoriesTableData(
      id: 'toll',
      name: 'Toll & RFID',
      icon: '🛣️',
      colorHex: 0xFF00CFDE, // Cyan
      bucket: 'needs',
      isCustom: false,
      sortOrder: 1,
    ),
    ExpenseCategoriesTableData(
      id: 'petrol',
      name: 'Petrol / Fuel',
      icon: '⛽',
      colorHex: 0xFFEA5455, // Red
      bucket: 'needs',
      isCustom: false,
      sortOrder: 2,
    ),
    ExpenseCategoriesTableData(
      id: 'transit',
      name: 'Public Transit (My50/MRT)',
      icon: '🚆',
      colorHex: 0xFF7367F0, // Indigo
      bucket: 'needs',
      isCustom: false,
      sortOrder: 3,
    ),
    ExpenseCategoriesTableData(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: '💡',
      colorHex: 0xFFFFC107, // Yellow
      bucket: 'needs',
      isCustom: false,
      sortOrder: 4,
    ),
    ExpenseCategoriesTableData(
      id: 'groceries',
      name: 'Groceries & Household',
      icon: '🛒',
      colorHex: 0xFF10AC84, // Mint Green
      bucket: 'needs',
      isCustom: false,
      sortOrder: 5,
    ),
    ExpenseCategoriesTableData(
      id: 'hangout',
      name: 'Cafe & Socializing',
      icon: '☕',
      colorHex: 0xFF9B51E0, // Purple
      bucket: 'wants',
      isCustom: false,
      sortOrder: 6,
    ),
    ExpenseCategoriesTableData(
      id: 'shopping',
      name: 'Shopping & Personal',
      icon: '🛍️',
      colorHex: 0xFFE056FD, // Pink
      bucket: 'wants',
      isCustom: false,
      sortOrder: 7,
    ),
    ExpenseCategoriesTableData(
      id: 'entertainment',
      name: 'Entertainment & Subs',
      icon: '🎬',
      colorHex: 0xFF3498DB, // Sky Blue
      bucket: 'wants',
      isCustom: false,
      sortOrder: 8,
    ),
    ExpenseCategoriesTableData(
      id: 'giving',
      name: 'Family & Giving (Mak Ayah)',
      icon: '🤲',
      colorHex: 0xFF2ECC71, // Green
      bucket: 'giving',
      isCustom: false,
      sortOrder: 9,
    ),
    ExpenseCategoriesTableData(
      id: 'savings',
      name: 'Emergency Savings / ASB',
      icon: '💰',
      colorHex: 0xFF28C76F, // Emerald
      bucket: 'savings',
      isCustom: false,
      sortOrder: 10,
    ),
    ExpenseCategoriesTableData(
      id: 'other',
      name: 'Other Expenses',
      icon: '📦',
      colorHex: 0xFF8395A7, // Slate
      bucket: 'wants',
      isCustom: false,
      sortOrder: 11,
    ),
  ];

  static const List<ChecklistItemsTableData> defaultChecklist = [
    ChecklistItemsTableData(
      id: 'epf_iakaun',
      title: 'Register EPF i-Akaun',
      description:
          'Download the KWSP i-Akaun app or visit a kiosk. Verify that your employer deposits the statutory 12%/13% contribution on time every month alongside your 11% deduction.',
      category: 'statutory',
      isCompleted: false,
      sortOrder: 0,
    ),
    ChecklistItemsTableData(
      id: 'lhdn_mytax',
      title: 'Register LHDN MyTax / e-Daftar',
      description:
          'Get your individual tax file number (Nombor Cukai Pendapatan) at mytax.hasil.gov.my. Required for PCB relief tracking and yearly e-Filing (Borang BE).',
      category: 'statutory',
      isCompleted: false,
      sortOrder: 1,
    ),
    ChecklistItemsTableData(
      id: 'separate_savings',
      title: 'Open a Dedicated Savings Account',
      description:
          'Open a separate bank or ASB account with NO debit card linked to your wallet. Keeping savings separate prevents accidental spending.',
      category: 'banking',
      isCompleted: false,
      sortOrder: 2,
    ),
    ChecklistItemsTableData(
      id: 'emergency_buffer',
      title: 'Build 1st RM 1,000 Safety Buffer',
      description:
          'Before spending on gadgets or wants, build an initial RM 1,000 liquid buffer to handle unexpected car repairs, clinic visits, or emergencies.',
      category: 'savings',
      isCompleted: false,
      sortOrder: 3,
    ),
    ChecklistItemsTableData(
      id: 'ptptn_direct_debit',
      title: 'Setup PTPTN / MARA Repayment',
      description:
          'Activate auto-debit on the PTPTN/MARA portal. This secures on-time payments, protects your CCRIS credit report, and qualifies for government discounts.',
      category: 'debt',
      isCompleted: false,
      sortOrder: 4,
    ),
    ChecklistItemsTableData(
      id: 'medical_takaful',
      title: 'Review Medical Card & Basic Takaful',
      description:
          'Check your employment offer letter for company medical coverage. If inadequate, look into an affordable standalone medical card while young and healthy.',
      category: 'protection',
      isCompleted: false,
      sortOrder: 5,
    ),
  ];

  static final List<AccountsTableData> defaultAccounts = [
    AccountsTableData(
      id: 1,
      name: 'Main Bank Account',
      type: 'bank',
      balanceSen: 0,
      icon: '🏦',
      colorHex: 0xFFFFC107,
      isDefault: true,
      isLiquidOnHand: true,
      updatedAt: DateTime(2025, 1, 1),
    ),
    AccountsTableData(
      id: 2,
      name: 'Touch \'n Go eWallet',
      type: 'ewallet',
      balanceSen: 0,
      icon: '📱',
      colorHex: 0xFF00CFDE,
      isDefault: false,
      isLiquidOnHand: true,
      updatedAt: DateTime(2025, 1, 1),
    ),
    AccountsTableData(
      id: 3,
      name: 'Cash in Wallet',
      type: 'cash',
      balanceSen: 0,
      icon: '💵',
      colorHex: 0xFF28C76F,
      isDefault: false,
      isLiquidOnHand: true,
      updatedAt: DateTime(2025, 1, 1),
    ),
  ];
}

