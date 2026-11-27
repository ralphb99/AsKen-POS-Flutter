import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/owner/application/EodSummaryNotifier.dart';
import 'package:asken_pos/app/core/features/owner/domain/EodSummary.dart';

class EodSummaryPage extends ConsumerStatefulWidget {
  const EodSummaryPage({super.key});

  @override
  ConsumerState<EodSummaryPage> createState() => _EodSummaryPageState();
}

class _EodSummaryPageState extends ConsumerState<EodSummaryPage> {
  late EodSummaryDateRange SelectedRange;

  @override
  void initState() {
    super.initState();
    SelectedRange = _CurrentMonth();
  }

  EodSummaryDateRange _Today() {
    final Now = DateTime.now();
    final Start = DateTime(Now.year, Now.month, Now.day);
    return EodSummaryDateRange(
      From: Start,
      To: Start.add(const Duration(days: 1)),
    );
  }

  EodSummaryDateRange _CurrentMonth() {
    final Now = DateTime.now();
    return EodSummaryDateRange(
      From: DateTime(Now.year, Now.month),
      To: DateTime(Now.year, Now.month + 1),
    );
  }

  EodSummaryDateRange _PreviousMonth() {
    final Now = DateTime.now();
    return EodSummaryDateRange(
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
    if (From == null || !mounted) {
      return;
    }

    final InitialTo = SelectedRange.To.subtract(const Duration(days: 1));
    final To = await showDatePicker(
      context: context,
      firstDate: From,
      lastDate: DateTime.now(),
      initialDate: InitialTo.isAfter(DateTime.now())
          ? DateTime.now()
          : InitialTo,
    );
    if (To == null || !mounted) {
      return;
    }

    setState(() {
      SelectedRange = EodSummaryDateRange(
        From: DateTime(From.year, From.month, From.day),
        To: DateTime(To.year, To.month, To.day).add(const Duration(days: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Summaries = ref.watch(EodSummaryRecordsProvider(SelectedRange));

    return Scaffold(
      appBar: AppBar(
        title: const Text('EOD Summaries'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Filter date',
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
      body: Summaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Error, StackTrace) =>
            Center(child: Text('Unable to load EOD summaries: $Error')),
        data: (Rows) => Rows.isEmpty
            ? const Center(child: Text('No EOD summaries found.'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: Rows.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (Context, Index) {
                  final Summary = Rows[Index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: const Icon(Icons.summarize_outlined),
                      title: Text(_FormatBusinessDate(Summary.BusinessDate)),
                      subtitle: Text(
                        '${Summary.TransactionCount} transaction(s) • '
                        '${Summary.SoldUnitCount} sold unit(s)',
                      ),
                      trailing: Text(
                        _FormatPeso(Summary.TotalSalesInCents),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () => Navigator.push(
                        Context,
                        MaterialPageRoute(
                          builder: (_) => EodSummaryDetailsPage(
                            BusinessDate: Summary.BusinessDate,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class EodSummaryDetailsPage extends ConsumerWidget {
  final String BusinessDate;

  const EodSummaryDetailsPage({required this.BusinessDate, super.key});

  Future<void> _ExportCsv(
    BuildContext Context,
    WidgetRef Ref,
    EodSummaryDetails Details,
  ) async {
    try {
      final File ExportedFile = await Ref.read(EodSummaryExportServiceProvider)
          .SaveCsv(
            Details: Details,
            FileName: 'asken_pos_eod_${Details.Summary.BusinessDate}.csv',
          );

      try {
        await OpenFilex.open(ExportedFile.path);
      } on MissingPluginException {
        // The file is still saved when the native open plugin is unavailable.
      } on PlatformException {
        // The file is still saved when no spreadsheet app is installed.
      }

      if (!Context.mounted) {
        return;
      }

      ScaffoldMessenger.of(Context).showSnackBar(
        SnackBar(content: Text('EOD CSV saved: ${ExportedFile.path}')),
      );
    } catch (Error) {
      if (!Context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        Context,
      ).showSnackBar(SnackBar(content: Text('Unable to export EOD: $Error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DetailsState = ref.watch(EodSummaryDetailsProvider(BusinessDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('EOD ${_FormatBusinessDate(BusinessDate)}'),
        actions: [
          if (DetailsState.value != null)
            IconButton(
              tooltip: 'Export spreadsheet CSV',
              onPressed: () => _ExportCsv(context, ref, DetailsState.value!),
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: DetailsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Error, StackTrace) =>
            Center(child: Text('Unable to load EOD details: $Error')),
        data: (Details) {
          if (Details == null) {
            return const Center(
              child: Text('This EOD summary no longer exists.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _SummaryHeader(Details: Details),
              const SizedBox(height: 16),
              Text(
                'Sold items',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...Details.Lines.map(
                (Line) => Card(
                  child: ListTile(
                    title: Text(Line.ProductName),
                    subtitle: Text(
                      '${Line.SoldUnits} ${Line.Unit} • '
                      '${_FormatPeso(Line.UnitPriceInCents)} each',
                    ),
                    trailing: Text(
                      _FormatPeso(Line.SoldTotalInCents),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sold total'),
                trailing: Text(
                  _FormatPeso(Details.Summary.TotalSalesInCents),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final EodSummaryDetails Details;

  const _SummaryHeader({required this.Details});

  @override
  Widget build(BuildContext context) {
    final Cashiers = Details.CashierNames.isEmpty
        ? 'Not available'
        : Details.CashierNames.join(', ');

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _FormatBusinessDate(Details.Summary.BusinessDate),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Transactions: ${Details.Summary.TransactionCount}'),
            Text('Sold units: ${Details.Summary.SoldUnitCount}'),
            Text('Cashier(s): $Cashiers'),
            const SizedBox(height: 8),
            Text(
              'Total sales: ${_FormatPeso(Details.Summary.TotalSalesInCents)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

String _FormatBusinessDate(String BusinessDate) {
  final Date = DateTime.tryParse(BusinessDate);
  return Date == null ? BusinessDate : DateFormat('MMM d, yyyy').format(Date);
}

String _FormatPeso(int Cents) => '\u20B1${(Cents / 100).toStringAsFixed(2)}';
