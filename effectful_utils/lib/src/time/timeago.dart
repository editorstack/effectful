// ignore_for_file: public_member_api_docs, document_ignores

extension DateTimeTimeAgoExtension on DateTime {
  /// Returns a fuzzy time string like 'a moment ago' or '5 minutes ago'.
  ///
  /// If [clock] is passed, it will be used as the reference point instead of
  /// `DateTime.now()`.
  ///
  /// If [allowFromNow] is true, future dates will display as "X from now"
  /// instead of "X ago".
  String timeAgo({DateTime? clock, bool allowFromNow = false}) {
    final now = clock ?? DateTime.now();
    var elapsed = now.millisecondsSinceEpoch - millisecondsSinceEpoch;

    String prefix;
    String suffix;

    if (allowFromNow && elapsed < 0) {
      elapsed = elapsed.abs();
      prefix = '';
      suffix = 'from now';
    } else {
      prefix = '';
      suffix = 'ago';
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45) {
      result = 'a moment';
    } else if (seconds < 90) {
      result = 'a minute';
    } else if (minutes < 45) {
      result = '${minutes.round()} minutes';
    } else if (minutes < 90) {
      result = 'about an hour';
    } else if (hours < 24) {
      result = '${hours.round()} hours';
    } else if (hours < 48) {
      result = 'a day';
    } else if (days < 30) {
      result = '${days.round()} days';
    } else if (days < 60) {
      result = 'about a month';
    } else if (days < 365) {
      result = '${months.round()} months';
    } else if (years < 2) {
      result = 'about a year';
    } else {
      result = '${years.round()} years';
    }

    return [prefix, result, suffix].where((str) => str.isNotEmpty).join(' ');
  }

  /// Returns a short fuzzy time string like 'now', '5m', '2h', '3d'.
  ///
  /// If [clock] is passed, it will be used as the reference point instead of
  /// `DateTime.now()`.
  String timeAgoShort({DateTime? clock}) {
    final now = clock ?? DateTime.now();
    final elapsed = now.millisecondsSinceEpoch - millisecondsSinceEpoch;

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    if (seconds < 45) {
      return 'now';
    } else if (seconds < 90) {
      return '1m';
    } else if (minutes < 45) {
      return '${minutes.round()}m';
    } else if (minutes < 90) {
      return '~1h';
    } else if (hours < 24) {
      return '${hours.round()}h';
    } else if (hours < 48) {
      return '~1d';
    } else if (days < 30) {
      return '${days.round()}d';
    } else if (days < 60) {
      return '~1mo';
    } else if (days < 365) {
      return '${months.round()}mo';
    } else if (years < 2) {
      return '~1y';
    } else {
      return '${years.round()}y';
    }
  }
}
