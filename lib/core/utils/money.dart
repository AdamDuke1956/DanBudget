import 'package:intl/intl.dart';

/// Money value stored as an integer number of **sen** (1 RM = 100 sen).
///
/// Using integers avoids floating-point rounding errors in budget maths.
extension type const Money(int sen) implements int {
  /// Creates a [Money] from a ringgit amount, rounding to the nearest sen.
  factory Money.fromRinggit(num ringgit) => Money((ringgit * 100).round());

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
}
