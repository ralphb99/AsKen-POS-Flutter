import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/data/TransactionRecordsService.dart';

class TransactionRecordsPage extends ConsumerStatefulWidget {
  const TransactionRecordsPage({super.key});

  @override
  ConsumerState<TransactionRecordsPage> createState() =>
      _TransactionRecordsPageState();
}

class _TransactionRecordsPageState
    extends ConsumerState<TransactionRecordsPage> {
  final SearchController = TextEditingController();
  String SearchQuery = '';
  late TransactionRecordsDateRange SelectedRange;

  @override
  void initState() {
    super.initState();
    SelectedRange = _CurrentMonth();
  }

  TransactionRecordsDateRange _CurrentMonth() {
    final Now = DateTime.now();
    return TransactionRecordsDateRange(
      From: DateTime(Now.year, Now.month),
      To: DateTime(Now.year, Now.month + 1),
    );
  }

  TransactionRecordsDateRange _Today() {
    final Now = DateTime.now();
    final Start = DateTime(Now.year, Now.month, Now.day);
    return TransactionRecordsDateRange(
      From: Start,
      To: Start.add(const Duration(days: 1)),
    );
  }

  TransactionRecordsDateRange _PreviousMonth() {
    final Now = DateTime.now();
    return TransactionRecordsDateRange(
      From: DateTime(Now.year, Now.month - 1),
      To: DateTime(Now.year, Now.month),
    );
  }

  Future<void> _SelectCustomRange() async {
    final From = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: SelectedRange.From,
    );
    if (From == null || !mounted) return;

    final InitialTo = SelectedRange.To.subtract(const Duration(days: 1));
    final To = await showDatePicker(
      context: context,
      firstDate: From,
      lastDate: DateTime.now(),
      initialDate: InitialTo.isAfter(DateTime.now())
          ? DateTime.now()
          : InitialTo,
    );
    if (To == null || !mounted) return;

    setState(() {
      SelectedRange = TransactionRecordsDateRange(
        From: DateTime(From.year, From.month, From.day),
        To: DateTime(To.year, To.month, To.day).add(const Duration(days: 1)),
      );
    });
  }

  Future<void> _ShowExportOptions(List<TransactionRecord> Records) async {
    final ExportService = ref.read(TransactionExportServiceProvider);
    final ExportType = await showModalBottomSheet<String>(
      context: context,
      builder: (Context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: const Text('Save and open CSV file'),
              onTap: () => Navigator.pop(Context, 'csv_open'),
            ),

            ListTile(
              leading: const Icon(Icons.file_copy),
              title: const Text('Save and open TXT file'),
              onTap: () => Navigator.pop(Context, 'text_open'),
            ),
          ],
        ),
      ),
    );

    if (ExportType == null || !mounted) return;
    final DateLabel = DateFormat('yyyyMMdd').format(SelectedRange.From);
    final IsCsv = ExportType.startsWith('csv');
    final ShouldOpen = ExportType.endsWith('open');
    late final File ExportedFile;
    try {
      ExportedFile = IsCsv
          ? await ExportService.SaveCsv(
              Records: Records,
              FileName: 'asken_pos_transactions_$DateLabel.csv',
            )
          : await ExportService.SaveText(
              Records: Records,
              FileName: 'asken_pos_transactions_$DateLabel.txt',
            );
    } catch (Error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save file: $Error')),
      );
      return;
    }

    var Message = 'File saved: ${ExportedFile.path}';
    if (ShouldOpen) {
      try {
        await OpenFilex.open(ExportedFile.path);
        Message = 'File saved. Opening now...';
      } on MissingPluginException {
        Message =
            'File saved, but opening is unavailable until the app is fully restarted.';
      } on PlatformException {
        Message = 'File saved, but no compatible app could open the file.';
      } catch (_) {
        Message = 'File saved, but the file could not be opened.';
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Message)),
    );
  }

  @override
  void dispose() {
    SearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Records = ref.watch(OwnerTransactionRecordsProvider(SelectedRange));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
        actions: [
          Text('Filter Options'),
          PopupMenuButton<String>(
            tooltip: 'Date range',
            elevation: 4,
            onSelected: (Value) async {
              if (Value == 'today') {
                setState(() => SelectedRange = _Today());
              } else if (Value == 'month') {
                setState(() => SelectedRange = _CurrentMonth());
              } else if (Value == 'previous') {
                setState(() => SelectedRange = _PreviousMonth());
              } else {
                await _SelectCustomRange();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'today', child: Text('Today')),
              PopupMenuItem(value: 'month', child: Text('This Month')),
              PopupMenuItem(value: 'previous', child: Text('Previous Month')),
              PopupMenuItem(value: 'custom', child: Text('Custom Range')),
            ],
          ),
        ],
      ),
      body: Records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Error, StackTrace) =>
            Center(child: Text('Unable to load transaction records: $Error')),
        data: (Rows) {
          final Query = SearchQuery.trim().toLowerCase();
          final FilteredRows = Rows.where((Record) {
            if (Query.isEmpty) return true;
            final TransactionData = Record.TransactionData;
            return [
              TransactionData.ReceiptNumber,
              TransactionData.CashierName,
              TransactionData.PaymentMethod,
              TransactionData.Status,
              TransactionData.SyncStatus,
            ].join(' ').toLowerCase().contains(Query);
          }).toList(growable: false);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: SearchController,
                        onChanged: (Value) =>
                            setState(() => SearchQuery = Value),
                        decoration: const InputDecoration(
                          labelText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Export records',
                      onPressed: FilteredRows.isEmpty
                          ? null
                          : () => _ShowExportOptions(FilteredRows),
                      icon: const Icon(Icons.save),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Range: '
                    '${DateFormat('MMM d, yyyy').format(SelectedRange.From)} - '
                    '${DateFormat('MMM d, yyyy').format(SelectedRange.To.subtract(const Duration(days: 1)))}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FilteredRows.isEmpty
                    ? const Center(child: Text('No transactions found.'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: FilteredRows.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (Context, Index) {
                          final Record = FilteredRows[Index];
                          final TransactionData = Record.TransactionData;
                          return Card(
                            elevation: 7,
                            child: ListTile(
                              contentPadding: EdgeInsetsGeometry.fromLTRB(16, 10, 16, 10),
                              onTap: () => Navigator.push(
                                Context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionRecordDetailsPage(
                                    Record: Record,
                                  ),
                                ),
                              ),
                              title: Text(TransactionData.ReceiptNumber),
                              titleTextStyle: TextStyle(
                                height: 2,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              subtitle: Text(
                                'Cashier: ${TransactionData.CashierName}'
                                '\nDate: ${DateFormat('MMM d, yyyy h:mm a').format(TransactionData.CreatedAt)}\n'
                                'Sync Status: ${TransactionData.SyncStatus.toUpperCase()}',
                              ),
                              subtitleTextStyle: TextStyle(
                                  height: 2,
                                  fontWeight: FontWeight.w500,
                                   color: Colors.black,
                                ),
                              isThreeLine: true,
                              trailing: Text(
                                _FormatPeso(TransactionData.TotalInCents),
                              ),
                              leadingAndTrailingTextStyle: TextStyle(
                                  height: 2,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TransactionRecordDetailsPage extends StatelessWidget {
  final TransactionRecord Record;

  const TransactionRecordDetailsPage({required this.Record, super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionData = Record.TransactionData;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            TransactionData.ReceiptNumber,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Cashier: ${TransactionData.CashierName}'),
          Text('Payment: ${TransactionData.PaymentMethod}'),
          Text('Status: ${TransactionData.Status}'),
          Text('Sync: ${TransactionData.SyncStatus}'),
          const Divider(height: 32),
          ...Record.Items.map(
            (Item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(Item.ProductNameSnapshot),
              subtitle: Text('${Item.Quantity} ${Item.UnitSnapshot}'),
              trailing: Text(_FormatPeso(Item.LineTotalInCents)),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Total'),
            trailing: Text(
              _FormatPeso(TransactionData.TotalInCents),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

String _FormatPeso(int Cents) => '\u20B1${(Cents / 100).toStringAsFixed(2)}';
