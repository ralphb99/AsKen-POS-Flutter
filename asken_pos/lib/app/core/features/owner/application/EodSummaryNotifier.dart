import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

final EodDashboardProvider =
    AsyncNotifierProvider.autoDispose<EodDashboardNotifier, EodDashboardData>(
      EodDashboardNotifier.new,
    );

class EodDashboardNotifier extends AsyncNotifier<EodDashboardData> {
  @override
  Future<EodDashboardData> build() {
    return ref
        .read(EodSummaryServiceProvider)
        .GetDashboard(BusinessDate: DateTime.now());
  }
}

final EodSummaryRecordsProvider = AsyncNotifierProvider.autoDispose
    .family<
      EodSummaryRecordsNotifier,
      List<EodSummaryRecord>,
      EodSummaryDateRange
    >(EodSummaryRecordsNotifier.new);

class EodSummaryRecordsNotifier extends AsyncNotifier<List<EodSummaryRecord>> {
  EodSummaryRecordsNotifier(this.Range);

  final EodSummaryDateRange Range;

  @override
  Future<List<EodSummaryRecord>> build() {
    return ref
        .read(EodSummaryServiceProvider)
        .GetSummaries(From: Range.From, To: Range.To);
  }
}

final EodSummaryDetailsProvider = AsyncNotifierProvider.autoDispose
    .family<EodSummaryDetailsNotifier, EodSummaryDetails?, String>(
      EodSummaryDetailsNotifier.new,
    );

class EodSummaryDetailsNotifier extends AsyncNotifier<EodSummaryDetails?> {
  EodSummaryDetailsNotifier(this.BusinessDate);

  final String BusinessDate;

  @override
  Future<EodSummaryDetails?> build() {
    return ref
        .read(EodSummaryServiceProvider)
        .GetDetails(BusinessDate: BusinessDate);
  }
}
