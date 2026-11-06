import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/database/AppDatabase.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';

const ProductUnits = <String>[
  'pc',
  'doz',
  'pack',
  'box',
  'ream',
  'set',
  'pair',
  'roll',
  'sheet',
  'bottle',
];

const ProductSizes = <String>[
  'Small',
  'Medium',
  'Large',
  'A4',
  'Short',
  'Long',
  'Legal',
  'Letter',
  '1/4',
  '1/2',
  'Custom',
];

final ManagedProductSearchProvider =
    NotifierProvider<ManagedProductSearchNotifier, String>(
      ManagedProductSearchNotifier.new,
    );

final ManagedProductStatusProvider =
    NotifierProvider<ManagedProductStatusNotifier, String>(
      ManagedProductStatusNotifier.new,
    );

class ManagedProductSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void SetSearchQuery(String Value) {
    state = Value;
  }
}

class ManagedProductStatusNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void SetStatusFilter(String Value) {
    state = Value;
  }
}

class ProductManagementPage extends ConsumerWidget {
  const ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Products = ref.watch(ManagedProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Filter product status',
            initialValue: ref.watch(ManagedProductStatusProvider),
            onSelected: (Value) => ref
                .read(ManagedProductStatusProvider.notifier)
                .SetStatusFilter(Value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'all', child: Text('All products')),
              PopupMenuItem(value: 'active', child: Text('Active only')),
              PopupMenuItem(value: 'inactive', child: Text('Inactive only')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (Value) => ref
                  .read(ManagedProductSearchProvider.notifier)
                  .SetSearchQuery(Value),
              decoration: InputDecoration(
                hintText: 'Search name, brand, color, size, or unit',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSellableItemPage()),
          );
          ref.invalidate(ManagedProductsProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: Products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Error, StackTrace) =>
            Center(child: Text('Unable to load products: $Error')),
        data: (Rows) {
          final Query = ref
              .watch(ManagedProductSearchProvider)
              .trim()
              .toLowerCase();
          final Status = ref.watch(ManagedProductStatusProvider);
          final FilteredRows = Rows.where((RowData) {
            final IsActive =
                RowData.StoreProduct.IsActive && RowData.Variant.IsActive;
            final MatchesStatus =
                Status == 'all' ||
                (Status == 'active' && IsActive) ||
                (Status == 'inactive' && !IsActive);
            if (!MatchesStatus) return false;
            if (Query.isEmpty) return true;
            final SearchableText = [
              RowData.StoreProduct.ProductName,
              RowData.StoreProduct.Brand ?? '',
              RowData.Variant.Color ?? '',
              RowData.Variant.Size ?? '',
              RowData.Variant.Unit,
            ].join(' ').toLowerCase();
            return SearchableText.contains(Query);
          }).toList(growable: false);

          if (FilteredRows.isEmpty) {
            return Center(
              child: Text(
                Rows.isEmpty
                    ? 'No products have been added.'
                    : 'No products match the current search or filter.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            itemCount: FilteredRows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, Index) {
              final RowData = FilteredRows[Index];
              final Product = RowData.StoreProduct;
              final Variant = RowData.Variant;
              final IsActive = Product.IsActive && Variant.IsActive;

              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Column 1: Product information
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditSellableItemPage(RowData: RowData),
                              ),
                            );
                            ref.invalidate(ManagedProductsProvider);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Product.ProductName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                [
                                      Product.Brand,
                                      Variant.Color,
                                      Variant.Size,
                                      Variant.Unit,
                                    ]
                                    .whereType<String>()
                                    .where((Value) => Value.isNotEmpty)
                                    .join(' • '),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Column 2: Price, status, and actions
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₱${(Variant.PriceInCents / 100).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  IsActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: IsActive
                                        ? Colors.green
                                        : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              onSelected: (Value) async {
                                if (Value == 'edit') {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditSellableItemPage(
                                        RowData: RowData,
                                      ),
                                    ),
                                  );
                                  ref.invalidate(ManagedProductsProvider);
                                  return;
                                }

                                await ref
                                    .read(ProductManagementServiceProvider)
                                    .SetProductVariantActive(
                                      ProductVariantID: Variant.ID,
                                      IsActive: !IsActive,
                                    );

                                ref.invalidate(ManagedProductsProvider);
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Text(
                                    IsActive ? 'Deactivate' : 'Activate',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditSellableItemPage extends ConsumerStatefulWidget {
  final ProductDataRow RowData;

  const EditSellableItemPage({required this.RowData, super.key});

  @override
  ConsumerState<EditSellableItemPage> createState() =>
      _EditSellableItemPageState();
}

class _EditSellableItemPageState extends ConsumerState<EditSellableItemPage> {
  final FormKey = GlobalKey<FormState>();
  late final TextEditingController ProductNameController;
  late final TextEditingController BrandController;
  late final TextEditingController ColorController;
  late final TextEditingController CustomSizeController;
  late final TextEditingController PriceController;
  late final List<String> UnitOptions;
  String? SelectedUnit;
  String? SelectedSize;
  bool IsSaving = false;

  @override
  void initState() {
    super.initState();
    final Product = widget.RowData.StoreProduct;
    final Variant = widget.RowData.Variant;
    ProductNameController = TextEditingController(text: Product.ProductName);
    BrandController = TextEditingController(text: Product.Brand ?? '');
    ColorController = TextEditingController(text: Variant.Color ?? '');
    CustomSizeController = TextEditingController();
    PriceController = TextEditingController(
      text: (Variant.PriceInCents / 100).toStringAsFixed(2),
    );
    UnitOptions = [...ProductUnits];
    if (!UnitOptions.contains(Variant.Unit)) UnitOptions.add(Variant.Unit);
    SelectedUnit = Variant.Unit;
    if (Variant.Size == null || Variant.Size!.isEmpty) {
      SelectedSize = null;
    } else if (ProductSizes.contains(Variant.Size)) {
      SelectedSize = Variant.Size;
    } else {
      SelectedSize = 'Custom';
      CustomSizeController.text = Variant.Size!;
    }
  }

  @override
  void dispose() {
    ProductNameController.dispose();
    BrandController.dispose();
    ColorController.dispose();
    CustomSizeController.dispose();
    PriceController.dispose();
    super.dispose();
  }

  Future<void> SaveChanges() async {
    if (IsSaving || !(FormKey.currentState?.validate() ?? false)) return;
    final Input = PriceController.text.trim().replaceAll(',', '.');
    final Price = double.tryParse(Input);
    if (Price == null || SelectedUnit == null) return;
    setState(() => IsSaving = true);
    try {
      final Size = SelectedSize == 'Custom'
          ? CustomSizeController.text.trim()
          : SelectedSize;
      final Service = ref.read(ProductManagementServiceProvider);
      final ExistingRows = await Service.SearchProducts(
        Query: ProductNameController.text,
        IncludeInactive: true,
      );
      final IsDuplicate = ExistingRows.any((RowData) {
        if (RowData.Variant.ID == widget.RowData.Variant.ID) return false;
        return RowData.StoreProduct.ProductName.trim().toLowerCase() ==
                ProductNameController.text.trim().toLowerCase() &&
            (RowData.StoreProduct.Brand ?? '').trim().toLowerCase() ==
                BrandController.text.trim().toLowerCase() &&
            (RowData.Variant.Color ?? '').trim().toLowerCase() ==
                ColorController.text.trim().toLowerCase() &&
            (RowData.Variant.Size ?? '').trim().toLowerCase() ==
                (Size ?? '').trim().toLowerCase() &&
            RowData.Variant.Unit == SelectedUnit;
      });
      if (IsDuplicate) {
        throw const FormatException(
          'A matching product variant already exists.',
        );
      }
      await Service.UpdateSellableItem(
        ProductID: widget.RowData.StoreProduct.ID,
        ProductVariantID: widget.RowData.Variant.ID,
        ProductName: ProductNameController.text,
        Brand: BrandController.text,
        Color: ColorController.text,
        Size: Size,
        Unit: SelectedUnit!,
        PriceInCents: (Price * 100).round(),
      );
      if (mounted) Navigator.pop(context);
    } catch (Error) {
      if (!mounted) return;
      setState(() => IsSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Error.toString().replaceFirst('FormatException: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final IsCustomSize = SelectedSize == 'Custom';
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Sellable Item')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Form(
              key: FormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TextField(
                    Controller: ProductNameController,
                    Label: 'Product name',
                    Validator: (Value) => Value == null || Value.trim().isEmpty
                        ? 'Product name is required.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: BrandController,
                    Label: 'Brand (optional)',
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: ColorController,
                    Label: 'Color (optional)',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: SelectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Size (optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductSizes.map(
                      (Size) =>
                          DropdownMenuItem(value: Size, child: Text(Size)),
                    ).toList(),
                    onChanged: (Value) => setState(() => SelectedSize = Value),
                  ),
                  if (IsCustomSize) ...[
                    const SizedBox(height: 16),
                    _TextField(
                      Controller: CustomSizeController,
                      Label: 'Custom size',
                      Validator: (Value) =>
                          Value == null || Value.trim().isEmpty
                          ? 'Enter the custom size.'
                          : null,
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: SelectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: UnitOptions.map(
                      (Unit) =>
                          DropdownMenuItem(value: Unit, child: Text(Unit)),
                    ).toList(),
                    onChanged: (Value) => setState(() => SelectedUnit = Value),
                    validator: (Value) =>
                        Value == null ? 'Select a unit.' : null,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: PriceController,
                    Label: 'Price',
                    KeyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    Validator: (Value) {
                      final Input = Value?.trim().replaceAll(',', '.');
                      return Input != null &&
                              RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(Input) &&
                              double.tryParse(Input) != null
                          ? null
                          : 'Enter a valid price with up to 2 decimals.';
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: IsSaving ? null : SaveChanges,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(IsSaving ? 'Saving...' : 'Save changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddSellableItemPage extends ConsumerStatefulWidget {
  const AddSellableItemPage({super.key});

  @override
  ConsumerState<AddSellableItemPage> createState() =>
      _AddSellableItemPageState();
}

class _AddSellableItemPageState extends ConsumerState<AddSellableItemPage> {
  final FormKey = GlobalKey<FormState>();
  final ProductNameController = TextEditingController();
  final BrandController = TextEditingController();
  final ColorController = TextEditingController();
  final CustomSizeController = TextEditingController();
  final PriceController = TextEditingController();

  String? SelectedUnit;
  String? SelectedSize;
  bool IsSaving = false;

  @override
  void dispose() {
    ProductNameController.dispose();
    BrandController.dispose();
    ColorController.dispose();
    CustomSizeController.dispose();
    PriceController.dispose();
    super.dispose();
  }

  Future<void> SaveItem() async {
    if (IsSaving || !(FormKey.currentState?.validate() ?? false)) {
      return;
    }

    final Price = double.tryParse(
      PriceController.text.trim().replaceAll(',', '.'),
    );
    if (Price == null) {
      return;
    }

    setState(() => IsSaving = true);

    try {
      final Size = SelectedSize == 'Custom'
          ? CustomSizeController.text.trim()
          : SelectedSize;

      final Service = ref.read(ProductManagementServiceProvider);
      final ExistingRows = await Service.SearchProducts(
        Query: ProductNameController.text.trim(),
        IncludeInactive: true,
      );

      final IsDuplicate = ExistingRows.any((RowData) {
        final Product = RowData.StoreProduct;
        final Variant = RowData.Variant;

        return Product.ProductName.trim().toLowerCase() ==
                ProductNameController.text.trim().toLowerCase() &&
            (Product.Brand ?? '').trim().toLowerCase() ==
                BrandController.text.trim().toLowerCase() &&
            (Variant.Color ?? '').trim().toLowerCase() ==
                ColorController.text.trim().toLowerCase() &&
            (Variant.Size ?? '').trim().toLowerCase() ==
                (Size ?? '').trim().toLowerCase() &&
            Variant.Unit == SelectedUnit;
      });

      if (IsDuplicate) {
        throw const FormatException(
          'A matching product variant already exists.',
        );
      }

      await Service.AddSellableItem(
        ProductName: ProductNameController.text,
        Brand: BrandController.text,
        Color: ColorController.text,
        Size: Size,
        Unit: SelectedUnit!,
        PriceInCents: (Price * 100).round(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully.')),
      );
      Navigator.pop(context);
    } catch (Error) {
      if (!mounted) {
        return;
      }

      setState(() => IsSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Error.toString().replaceFirst('FormatException: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final IsCustomSize = SelectedSize == 'Custom';

    return Scaffold(
      appBar: AppBar(title: const Text('Add Sellable Item')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Form(
              key: FormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TextField(
                    Controller: ProductNameController,
                    Label: 'Product name',
                    Validator: (Value) => Value == null || Value.trim().isEmpty
                        ? 'Product name is required.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: BrandController,
                    Label: 'Brand (optional)',
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: ColorController,
                    Label: 'Color (optional)',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: SelectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Size (optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductSizes.map(
                      (Size) =>
                          DropdownMenuItem(value: Size, child: Text(Size)),
                    ).toList(),
                    onChanged: (Value) => setState(() => SelectedSize = Value),
                  ),
                  if (IsCustomSize) ...[
                    const SizedBox(height: 16),
                    _TextField(
                      Controller: CustomSizeController,
                      Label: 'Custom size',
                      Validator: (Value) =>
                          IsCustomSize &&
                              (Value == null || Value.trim().isEmpty)
                          ? 'Enter the custom size.'
                          : null,
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: SelectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductUnits.map(
                      (Unit) =>
                          DropdownMenuItem(value: Unit, child: Text(Unit)),
                    ).toList(),
                    onChanged: (Value) => setState(() => SelectedUnit = Value),
                    validator: (Value) =>
                        Value == null ? 'Select a unit.' : null,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    Controller: PriceController,
                    Label: 'Price',
                    KeyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    Validator: (Value) {
                      final Input = Value?.trim().replaceAll(',', '.');
                      if (Input == null ||
                          !RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(Input)) {
                        return 'Enter a valid price with up to 2 decimals.';
                      }

                      return double.tryParse(Input) == null
                          ? 'Enter a valid price.'
                          : null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: IsSaving ? null : SaveItem,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(IsSaving ? 'Saving...' : 'Save sellable item'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController Controller;
  final String Label;
  final TextInputType KeyboardType;
  final String? Function(String?)? Validator;

  const _TextField({
    required this.Controller,
    required this.Label,
    this.KeyboardType = TextInputType.text,
    this.Validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Controller,
      keyboardType: KeyboardType,
      decoration: InputDecoration(
        labelText: Label,
        border: const OutlineInputBorder(),
      ),
      validator: Validator,
    );
  }
}
