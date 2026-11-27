class EodSaleLine {
  final int ProductVariantID;
  final String ProductName;
  final String Unit;
  final int UnitPriceInCents;
  final int Quantity;
  final int LineTotalInCents;

  const EodSaleLine({
    required this.ProductVariantID,
    required this.ProductName,
    required this.Unit,
    required this.UnitPriceInCents,
    required this.Quantity,
    required this.LineTotalInCents,
  });
}

class EodSummaryRecord {
  final int ID;
  final String BusinessDate;
  final int TransactionCount;
  final int SoldUnitCount;
  final int TotalSalesInCents;
  final DateTime CreatedAt;
  final DateTime UpdatedAt;

  const EodSummaryRecord({
    required this.ID,
    required this.BusinessDate,
    required this.TransactionCount,
    required this.SoldUnitCount,
    required this.TotalSalesInCents,
    required this.CreatedAt,
    required this.UpdatedAt,
  });
}

class EodSummaryLine {
  final int ID;
  final int EodSummaryID;
  final int ProductVariantID;
  final String ProductName;
  final String Unit;
  final int UnitPriceInCents;
  final int SoldUnits;
  final int SoldTotalInCents;

  const EodSummaryLine({
    required this.ID,
    required this.EodSummaryID,
    required this.ProductVariantID,
    required this.ProductName,
    required this.Unit,
    required this.UnitPriceInCents,
    required this.SoldUnits,
    required this.SoldTotalInCents,
  });
}

class EodSummaryDetails {
  final EodSummaryRecord Summary;
  final List<EodSummaryLine> Lines;
  final List<String> CashierNames;

  const EodSummaryDetails({
    required this.Summary,
    required this.Lines,
    required this.CashierNames,
  });
}

class EodDashboardData {
  final EodSummaryRecord? Summary;
  final List<String> CashierNames;

  const EodDashboardData({required this.Summary, required this.CashierNames});

  int get TransactionCount => Summary?.TransactionCount ?? 0;

  int get SoldUnitCount => Summary?.SoldUnitCount ?? 0;

  int get TotalSalesInCents => Summary?.TotalSalesInCents ?? 0;
}

class EodSummaryDateRange {
  final DateTime From;
  final DateTime To;

  const EodSummaryDateRange({required this.From, required this.To});

  @override
  bool operator ==(Object Other) =>
      Other is EodSummaryDateRange && Other.From == From && Other.To == To;

  @override
  int get hashCode => Object.hash(From, To);
}
