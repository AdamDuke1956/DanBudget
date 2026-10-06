/// How the user earns their monthly income.
///
/// - [intern]: monthly allowance / stipend. Exempt from EPF, SOCSO, EIS & PCB.
/// - [fullTime]: salaried employee with statutory deductions.
enum EmploymentType {
  intern('intern', 'Internship', '🎓'),
  fullTime('fullTime', 'Full-Time', '💼');

  const EmploymentType(this.storageValue, this.label, this.emoji);

  /// Value persisted in the `user_profile.employment_type` column.
  final String storageValue;
  final String label;
  final String emoji;

  bool get isIntern => this == EmploymentType.intern;

  /// Label for the monthly income figure ("allowance" vs "salary").
  String get incomeLabel => isIntern ? 'Monthly Allowance' : 'Gross Monthly Salary';

  /// Parses a stored value, falling back to [fullTime] for unknown values so
  /// legacy rows keep their statutory deductions.
  static EmploymentType fromStorage(String? value) {
    return EmploymentType.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => EmploymentType.fullTime,
    );
  }
}
