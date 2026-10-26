import 'package:intl/intl.dart';

/// Money value stored as an integer number of **sen** (1 RM = 100 sen).
///
/// Using integers avoids floating-point rounding errors in budget maths.
extension type const Money(int sen) implements int {
  static const Money zero = Money(0);

  /// Creates a [Money] from a ringgit amount, rounding to the nearest sen.
  factory Money.fromRinggit(num ringgit) => Money((ringgit * 100).round());

  /// Parses a user-entered Ringgit string (e.g. "1,250.50" or "RM 100") into [Money].
  static Money? tryParse(String raw) {
    final cleaned = raw.replaceAll('RM', '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    final val = double.tryParse(cleaned);
    if (val == null || val < 0) return null;
    return Money.fromRinggit(val);
  }

  double get ringgit => sen / 100;

  Money operator +(Money other) => Money(sen + other.sen);
  Money operator -(Money other) => Money(sen - other.sen);

  /// Multiplies by a ratio (e.g. 0.4 for 40%), rounded to the nearest sen.
  Money scale(double ratio) => Money((sen * ratio).round());

  /// e.g. `RM 3,200.50`
  String format({bool withSymbol = true, bool showSen = true}) {
    final f = NumberFormat.currency(
      locale: 'en_MY',
      symbol: withSymbol ? 'RM ' : '',
      decimalDigits: showSen ? 2 : 0,
    );
    return f.format(ringgit);
  }

  String get formatted => format();

  /// Formats without `.00` when the amount is whole Ringgit, or with `.XX` when it has sen.
  String get formattedCompact => format(showSen: sen % 100 != 0);
}
