import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asken_pos/app/core/features/checkout/data/AppProviders.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Cart.dart';
import 'package:asken_pos/app/core/features/checkout/domain/Product.dart';

final CheckoutControllerProvider = AsyncNotifierProvider.autoDispose
    .family<CheckoutController, CheckoutState, String>(CheckoutController.new);

class CheckoutState {
  final String CashierName;
  final List<ProductDisplayData> ProductData;
  final List<CartItem> CartItems;
  final String SearchQuery;

  const CheckoutState({
    required this.CashierName,
    required this.ProductData,
    required this.CartItems,
    required this.SearchQuery,
  });

  List<ProductDisplayData> get FilteredProducts {
    final Query = SearchQuery.trim().toLowerCase();

    if (Query.isEmpty) {
      return const [];
    }

    return ProductData.where((Product) {
      final SearchableText = [
        Product.ProductDisplayName,
        Product.ProductName,
        Product.Brand,
        Product.Color,
        Product.Size,
        Product.Unit,
      ].join(' ').toLowerCase();

      return SearchableText.contains(Query);
    }).toList(growable: false);
  }

  int get CartTotalInCents =>
      CartItems.fold(0, (Total, Item) => Total + Item.LineTotalInCents);

  CheckoutState copyWith({
    List<ProductDisplayData>? ProductData,
    List<CartItem>? CartItems,
    String? SearchQuery,
  }) {
    return CheckoutState(
      CashierName: CashierName,
      ProductData: ProductData ?? this.ProductData,
      CartItems: CartItems ?? this.CartItems,
      SearchQuery: SearchQuery ?? this.SearchQuery,
    );
  }
}

class CheckoutController extends AsyncNotifier<CheckoutState> {
  CheckoutController(this.CashierName);

  final String CashierName;
  Timer? _SessionSaveTimer;
  Future<void>? _SessionPersistenceTask;

  @override
  Future<CheckoutState> build() async {
    ref.onDispose(() {
      _SessionSaveTimer?.cancel();
    });

    final ProductData = await ref
        .read(ProductsServiceProvider)
        .GetProductData();
    final Session = await ref
        .read(CheckoutSessionServiceProvider)
        .LoadSession();

    return CheckoutState(
      CashierName: CashierName,
      ProductData: List.unmodifiable(ProductData),
      CartItems: List.unmodifiable(_RestoreCartItems(Session)),
      SearchQuery: '',
    );
  }

  void SetSearchQuery(String Query) {
    final CurrentState = state.asData?.value;
    if (CurrentState == null) {
      return;
    }

    state = AsyncData(CurrentState.copyWith(SearchQuery: Query));
  }

  void AddToCart(ProductDisplayData Product) {
    final CurrentState = state.asData?.value;
    if (CurrentState == null) {
      return;
    }

    final UpdatedCart = CurrentState.CartItems.map(
      (Item) => Item.CartProduct.ProductVariantID == Product.ProductVariantID
          ? CartItem(CartProduct: Item.CartProduct, quantity: Item.quantity + 1)
          : CartItem(CartProduct: Item.CartProduct, quantity: Item.quantity),
    ).toList();

    if (!CurrentState.CartItems.any(
      (Item) => Item.CartProduct.ProductVariantID == Product.ProductVariantID,
    )) {
      UpdatedCart.add(CartItem(CartProduct: Product));
    }

    _SetCart(CurrentState, UpdatedCart);
  }

  void ChangeQuantity(int Index, int Amount) {
    final CurrentState = state.asData?.value;
    if (CurrentState == null ||
        Index < 0 ||
        Index >= CurrentState.CartItems.length) {
      return;
    }

    final UpdatedCart = CurrentState.CartItems.asMap().entries
        .where(
          (Entry) => Entry.key != Index || Entry.value.quantity + Amount > 0,
        )
        .map((Entry) {
          final Item = Entry.value;
          return CartItem(
            CartProduct: Item.CartProduct,
            quantity: Entry.key == Index
                ? Item.quantity + Amount
                : Item.quantity,
          );
        })
        .toList();

    _SetCart(CurrentState, UpdatedCart);
  }

  void _SetCart(CheckoutState CurrentState, List<CartItem> CartItems) {
    state = AsyncData(
      CurrentState.copyWith(CartItems: List.unmodifiable(CartItems)),
    );
    _ScheduleSessionSave();
  }

  void _ScheduleSessionSave() {
    _SessionSaveTimer?.cancel();
    _SessionSaveTimer = Timer(
      const Duration(milliseconds: 400),
      _StartSessionPersistence,
    );
  }

  void _StartSessionPersistence() {
    final PersistenceTask = _PersistSession();
    _SessionPersistenceTask = PersistenceTask;

    unawaited(
      PersistenceTask.whenComplete(() {
        if (identical(_SessionPersistenceTask, PersistenceTask)) {
          _SessionPersistenceTask = null;
        }
      }),
    );
  }

  Future<void> ClearCheckoutSession() async {
    _SessionSaveTimer?.cancel();
    _SessionSaveTimer = null;

    final PersistenceTask = _SessionPersistenceTask;
    if (PersistenceTask != null) {
      await PersistenceTask;
    }

    await ref.read(CheckoutSessionServiceProvider).ClearSession();

    final CurrentState = state.asData?.value;
    if (CurrentState != null) {
      state = AsyncData(CurrentState.copyWith(CartItems: const <CartItem>[]));
    }
  }

  Future<void> _PersistSession() async {
    final CurrentState = state.asData?.value;
    if (CurrentState == null) {
      return;
    }

    try {
      final SessionService = ref.read(CheckoutSessionServiceProvider);

      if (CurrentState.CartItems.isEmpty) {
        await SessionService.ClearSession();
        return;
      }

      await SessionService.SaveSession(
        CashierName: CurrentState.CashierName,
        CartItems: CurrentState.CartItems,
      );
    } catch (Error) {
      // Session persistence must not interrupt the cashier's active checkout.
      // The next cart mutation will retry the save.
    }
  }

  List<CartItem> _RestoreCartItems(Map<String, dynamic>? Session) {
    if (Session == null || Session['items'] is! List) {
      return const [];
    }

    final RestoredItems = <CartItem>[];

    for (final RawItem in Session['items'] as List) {
      if (RawItem is! Map) {
        continue;
      }

      final ProductID = _ReadInt(RawItem['productId']);
      final ProductVariantID = _ReadInt(RawItem['productVariantId']);
      final ProductName = _ReadRequiredString(RawItem['productName']);
      final Unit = _ReadRequiredString(RawItem['unit']);
      final PriceInCents = _ReadInt(RawItem['priceInCents']);
      final Quantity = _ReadInt(RawItem['quantity']);

      if (ProductID == null ||
          ProductVariantID == null ||
          ProductName == null ||
          Unit == null ||
          PriceInCents == null ||
          Quantity == null ||
          Quantity <= 0) {
        continue;
      }

      RestoredItems.add(
        CartItem(
          CartProduct: ProductDisplayData(
            ProductID: ProductID,
            ProductVariantID: ProductVariantID,
            ProductName: ProductName,
            Brand: _ReadOptionalString(RawItem['brand']),
            Color: _ReadOptionalString(RawItem['color']),
            Size: _ReadOptionalString(RawItem['size']),
            Unit: Unit,
            PriceInCents: PriceInCents,
          ),
          quantity: Quantity,
        ),
      );
    }

    return RestoredItems;
  }

  int? _ReadInt(dynamic Value) {
    if (Value is int) {
      return Value;
    }

    if (Value is num) {
      return Value.toInt();
    }

    return int.tryParse(Value?.toString() ?? '');
  }

  String? _ReadRequiredString(dynamic Value) {
    if (Value is String && Value.trim().isNotEmpty) {
      return Value;
    }

    return null;
  }

  String? _ReadOptionalString(dynamic Value) {
    if (Value is String && Value.trim().isNotEmpty) {
      return Value;
    }

    return null;
  }
}
