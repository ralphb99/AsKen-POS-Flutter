import 'package:asken_pos/app/core/features/printing/domain/ReceiptData.dart';

abstract interface class ThermalPrinterService {
  Future<void> PrintReceipt({required ReceiptData Receipt});
}

class ThermalPrinterUnavailableException implements Exception {
  final String Message;

  const ThermalPrinterUnavailableException(this.Message);

  @override
  String toString() => Message;
}

/// Placeholder adapter until the owner provides a tested printer model.
class PlaceholderThermalPrinterService implements ThermalPrinterService {
  const PlaceholderThermalPrinterService();

  @override
  Future<void> PrintReceipt({required ReceiptData Receipt}) async {
    throw const ThermalPrinterUnavailableException(
      'No thermal printer is configured for this device.',
    );
  }
}
