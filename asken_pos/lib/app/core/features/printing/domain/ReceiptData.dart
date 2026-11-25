class ReceiptData {
  final String StoreName;
  final String Address;
  final String? ContactNumber;
  final String? ReceiptFooter;
  final String ReceiptNumber;
  final String CashierName;
  final DateTime CreatedAt;
  final String PaymentMethod;
  final List<ReceiptLineItem> Items;
  final int TotalInCents;

  const ReceiptData({
    required this.StoreName,
    required this.Address,
    required this.ContactNumber,
    required this.ReceiptFooter,
    required this.ReceiptNumber,
    required this.CashierName,
    required this.CreatedAt,
    required this.PaymentMethod,
    required this.Items,
    required this.TotalInCents,
  });
}

class ReceiptLineItem {
  final String ProductName;
  final String Unit;
  final int Quantity;
  final int UnitPriceInCents;
  final int LineTotalInCents;

  const ReceiptLineItem({
    required this.ProductName,
    required this.Unit,
    required this.Quantity,
    required this.UnitPriceInCents,
    required this.LineTotalInCents,
  });
}

class TransactionPrintResult {
  final int TransactionID;
  final bool IsPrinted;
  final String? ErrorMessage;

  const TransactionPrintResult({
    required this.TransactionID,
    required this.IsPrinted,
    this.ErrorMessage,
  });
}

class PendingPrintJob {
  final int TransactionID;
  final String ReceiptNumber;
  final String Status;
  final int AttemptCount;
  final DateTime? LastAttemptAt;
  final String? LastError;

  const PendingPrintJob({
    required this.TransactionID,
    required this.ReceiptNumber,
    required this.Status,
    required this.AttemptCount,
    required this.LastAttemptAt,
    required this.LastError,
  });
}
