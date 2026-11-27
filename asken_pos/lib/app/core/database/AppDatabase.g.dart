// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ProductNameMeta = const VerificationMeta(
    'ProductName',
  );
  @override
  late final GeneratedColumn<String> ProductName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _BrandMeta = const VerificationMeta('Brand');
  @override
  late final GeneratedColumn<String> Brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _IsActiveMeta = const VerificationMeta(
    'IsActive',
  );
  @override
  late final GeneratedColumn<bool> IsActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _CreatedAtMeta = const VerificationMeta(
    'CreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> CreatedAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    ProductName,
    Brand,
    IsActive,
    CreatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _ProductNameMeta,
        ProductName.isAcceptableOrUnknown(
          data['product_name']!,
          _ProductNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ProductNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _BrandMeta,
        Brand.isAcceptableOrUnknown(data['brand']!, _BrandMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _IsActiveMeta,
        IsActive.isAcceptableOrUnknown(data['is_active']!, _IsActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _CreatedAtMeta,
        CreatedAt.isAcceptableOrUnknown(data['created_at']!, _CreatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ProductName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      Brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      IsActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      CreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int ID;
  final String ProductName;
  final String? Brand;
  final bool IsActive;
  final DateTime CreatedAt;
  const Product({
    required this.ID,
    required this.ProductName,
    this.Brand,
    required this.IsActive,
    required this.CreatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['product_name'] = Variable<String>(ProductName);
    if (!nullToAbsent || Brand != null) {
      map['brand'] = Variable<String>(Brand);
    }
    map['is_active'] = Variable<bool>(IsActive);
    map['created_at'] = Variable<DateTime>(CreatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      ID: Value(ID),
      ProductName: Value(ProductName),
      Brand: Brand == null && nullToAbsent
          ? const Value.absent()
          : Value(Brand),
      IsActive: Value(IsActive),
      CreatedAt: Value(CreatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      ID: serializer.fromJson<int>(json['ID']),
      ProductName: serializer.fromJson<String>(json['ProductName']),
      Brand: serializer.fromJson<String?>(json['Brand']),
      IsActive: serializer.fromJson<bool>(json['IsActive']),
      CreatedAt: serializer.fromJson<DateTime>(json['CreatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'ProductName': serializer.toJson<String>(ProductName),
      'Brand': serializer.toJson<String?>(Brand),
      'IsActive': serializer.toJson<bool>(IsActive),
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
    };
  }

  Product copyWith({
    int? ID,
    String? ProductName,
    Value<String?> Brand = const Value.absent(),
    bool? IsActive,
    DateTime? CreatedAt,
  }) => Product(
    ID: ID ?? this.ID,
    ProductName: ProductName ?? this.ProductName,
    Brand: Brand.present ? Brand.value : this.Brand,
    IsActive: IsActive ?? this.IsActive,
    CreatedAt: CreatedAt ?? this.CreatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      ID: data.ID.present ? data.ID.value : this.ID,
      ProductName: data.ProductName.present
          ? data.ProductName.value
          : this.ProductName,
      Brand: data.Brand.present ? data.Brand.value : this.Brand,
      IsActive: data.IsActive.present ? data.IsActive.value : this.IsActive,
      CreatedAt: data.CreatedAt.present ? data.CreatedAt.value : this.CreatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('ID: $ID, ')
          ..write('ProductName: $ProductName, ')
          ..write('Brand: $Brand, ')
          ..write('IsActive: $IsActive, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ID, ProductName, Brand, IsActive, CreatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.ID == this.ID &&
          other.ProductName == this.ProductName &&
          other.Brand == this.Brand &&
          other.IsActive == this.IsActive &&
          other.CreatedAt == this.CreatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> ID;
  final Value<String> ProductName;
  final Value<String?> Brand;
  final Value<bool> IsActive;
  final Value<DateTime> CreatedAt;
  const ProductsCompanion({
    this.ID = const Value.absent(),
    this.ProductName = const Value.absent(),
    this.Brand = const Value.absent(),
    this.IsActive = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.ID = const Value.absent(),
    required String ProductName,
    this.Brand = const Value.absent(),
    this.IsActive = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  }) : ProductName = Value(ProductName);
  static Insertable<Product> custom({
    Expression<int>? ID,
    Expression<String>? ProductName,
    Expression<String>? Brand,
    Expression<bool>? IsActive,
    Expression<DateTime>? CreatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (ProductName != null) 'product_name': ProductName,
      if (Brand != null) 'brand': Brand,
      if (IsActive != null) 'is_active': IsActive,
      if (CreatedAt != null) 'created_at': CreatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? ID,
    Value<String>? ProductName,
    Value<String?>? Brand,
    Value<bool>? IsActive,
    Value<DateTime>? CreatedAt,
  }) {
    return ProductsCompanion(
      ID: ID ?? this.ID,
      ProductName: ProductName ?? this.ProductName,
      Brand: Brand ?? this.Brand,
      IsActive: IsActive ?? this.IsActive,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (ProductName.present) {
      map['product_name'] = Variable<String>(ProductName.value);
    }
    if (Brand.present) {
      map['brand'] = Variable<String>(Brand.value);
    }
    if (IsActive.present) {
      map['is_active'] = Variable<bool>(IsActive.value);
    }
    if (CreatedAt.present) {
      map['created_at'] = Variable<DateTime>(CreatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('ID: $ID, ')
          ..write('ProductName: $ProductName, ')
          ..write('Brand: $Brand, ')
          ..write('IsActive: $IsActive, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ProductIDMeta = const VerificationMeta(
    'ProductID',
  );
  @override
  late final GeneratedColumn<int> ProductID = GeneratedColumn<int>(
    'product_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _ColorMeta = const VerificationMeta('Color');
  @override
  late final GeneratedColumn<String> Color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _SizeMeta = const VerificationMeta('Size');
  @override
  late final GeneratedColumn<String> Size = GeneratedColumn<String>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _UnitMeta = const VerificationMeta('Unit');
  @override
  late final GeneratedColumn<String> Unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _PriceInCentsMeta = const VerificationMeta(
    'PriceInCents',
  );
  @override
  late final GeneratedColumn<int> PriceInCents = GeneratedColumn<int>(
    'price_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _IsActiveMeta = const VerificationMeta(
    'IsActive',
  );
  @override
  late final GeneratedColumn<bool> IsActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    ProductID,
    Color,
    Size,
    Unit,
    PriceInCents,
    IsActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductVariant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('product_i_d')) {
      context.handle(
        _ProductIDMeta,
        ProductID.isAcceptableOrUnknown(data['product_i_d']!, _ProductIDMeta),
      );
    } else if (isInserting) {
      context.missing(_ProductIDMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _ColorMeta,
        Color.isAcceptableOrUnknown(data['color']!, _ColorMeta),
      );
    }
    if (data.containsKey('size')) {
      context.handle(
        _SizeMeta,
        Size.isAcceptableOrUnknown(data['size']!, _SizeMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _UnitMeta,
        Unit.isAcceptableOrUnknown(data['unit']!, _UnitMeta),
      );
    } else if (isInserting) {
      context.missing(_UnitMeta);
    }
    if (data.containsKey('price_in_cents')) {
      context.handle(
        _PriceInCentsMeta,
        PriceInCents.isAcceptableOrUnknown(
          data['price_in_cents']!,
          _PriceInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_PriceInCentsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _IsActiveMeta,
        IsActive.isAcceptableOrUnknown(data['is_active']!, _IsActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  ProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariant(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ProductID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_i_d'],
      )!,
      Color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      Size: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size'],
      ),
      Unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      PriceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_in_cents'],
      )!,
      IsActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}

class ProductVariant extends DataClass implements Insertable<ProductVariant> {
  final int ID;
  final int ProductID;
  final String? Color;
  final String? Size;
  final String Unit;
  final int PriceInCents;
  final bool IsActive;
  const ProductVariant({
    required this.ID,
    required this.ProductID,
    this.Color,
    this.Size,
    required this.Unit,
    required this.PriceInCents,
    required this.IsActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['product_i_d'] = Variable<int>(ProductID);
    if (!nullToAbsent || Color != null) {
      map['color'] = Variable<String>(Color);
    }
    if (!nullToAbsent || Size != null) {
      map['size'] = Variable<String>(Size);
    }
    map['unit'] = Variable<String>(Unit);
    map['price_in_cents'] = Variable<int>(PriceInCents);
    map['is_active'] = Variable<bool>(IsActive);
    return map;
  }

  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      ID: Value(ID),
      ProductID: Value(ProductID),
      Color: Color == null && nullToAbsent
          ? const Value.absent()
          : Value(Color),
      Size: Size == null && nullToAbsent ? const Value.absent() : Value(Size),
      Unit: Value(Unit),
      PriceInCents: Value(PriceInCents),
      IsActive: Value(IsActive),
    );
  }

  factory ProductVariant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariant(
      ID: serializer.fromJson<int>(json['ID']),
      ProductID: serializer.fromJson<int>(json['ProductID']),
      Color: serializer.fromJson<String?>(json['Color']),
      Size: serializer.fromJson<String?>(json['Size']),
      Unit: serializer.fromJson<String>(json['Unit']),
      PriceInCents: serializer.fromJson<int>(json['PriceInCents']),
      IsActive: serializer.fromJson<bool>(json['IsActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'ProductID': serializer.toJson<int>(ProductID),
      'Color': serializer.toJson<String?>(Color),
      'Size': serializer.toJson<String?>(Size),
      'Unit': serializer.toJson<String>(Unit),
      'PriceInCents': serializer.toJson<int>(PriceInCents),
      'IsActive': serializer.toJson<bool>(IsActive),
    };
  }

  ProductVariant copyWith({
    int? ID,
    int? ProductID,
    Value<String?> Color = const Value.absent(),
    Value<String?> Size = const Value.absent(),
    String? Unit,
    int? PriceInCents,
    bool? IsActive,
  }) => ProductVariant(
    ID: ID ?? this.ID,
    ProductID: ProductID ?? this.ProductID,
    Color: Color.present ? Color.value : this.Color,
    Size: Size.present ? Size.value : this.Size,
    Unit: Unit ?? this.Unit,
    PriceInCents: PriceInCents ?? this.PriceInCents,
    IsActive: IsActive ?? this.IsActive,
  );
  ProductVariant copyWithCompanion(ProductVariantsCompanion data) {
    return ProductVariant(
      ID: data.ID.present ? data.ID.value : this.ID,
      ProductID: data.ProductID.present ? data.ProductID.value : this.ProductID,
      Color: data.Color.present ? data.Color.value : this.Color,
      Size: data.Size.present ? data.Size.value : this.Size,
      Unit: data.Unit.present ? data.Unit.value : this.Unit,
      PriceInCents: data.PriceInCents.present
          ? data.PriceInCents.value
          : this.PriceInCents,
      IsActive: data.IsActive.present ? data.IsActive.value : this.IsActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariant(')
          ..write('ID: $ID, ')
          ..write('ProductID: $ProductID, ')
          ..write('Color: $Color, ')
          ..write('Size: $Size, ')
          ..write('Unit: $Unit, ')
          ..write('PriceInCents: $PriceInCents, ')
          ..write('IsActive: $IsActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(ID, ProductID, Color, Size, Unit, PriceInCents, IsActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductVariant &&
          other.ID == this.ID &&
          other.ProductID == this.ProductID &&
          other.Color == this.Color &&
          other.Size == this.Size &&
          other.Unit == this.Unit &&
          other.PriceInCents == this.PriceInCents &&
          other.IsActive == this.IsActive);
}

class ProductVariantsCompanion extends UpdateCompanion<ProductVariant> {
  final Value<int> ID;
  final Value<int> ProductID;
  final Value<String?> Color;
  final Value<String?> Size;
  final Value<String> Unit;
  final Value<int> PriceInCents;
  final Value<bool> IsActive;
  const ProductVariantsCompanion({
    this.ID = const Value.absent(),
    this.ProductID = const Value.absent(),
    this.Color = const Value.absent(),
    this.Size = const Value.absent(),
    this.Unit = const Value.absent(),
    this.PriceInCents = const Value.absent(),
    this.IsActive = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.ID = const Value.absent(),
    required int ProductID,
    this.Color = const Value.absent(),
    this.Size = const Value.absent(),
    required String Unit,
    required int PriceInCents,
    this.IsActive = const Value.absent(),
  }) : ProductID = Value(ProductID),
       Unit = Value(Unit),
       PriceInCents = Value(PriceInCents);
  static Insertable<ProductVariant> custom({
    Expression<int>? ID,
    Expression<int>? ProductID,
    Expression<String>? Color,
    Expression<String>? Size,
    Expression<String>? Unit,
    Expression<int>? PriceInCents,
    Expression<bool>? IsActive,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (ProductID != null) 'product_i_d': ProductID,
      if (Color != null) 'color': Color,
      if (Size != null) 'size': Size,
      if (Unit != null) 'unit': Unit,
      if (PriceInCents != null) 'price_in_cents': PriceInCents,
      if (IsActive != null) 'is_active': IsActive,
    });
  }

  ProductVariantsCompanion copyWith({
    Value<int>? ID,
    Value<int>? ProductID,
    Value<String?>? Color,
    Value<String?>? Size,
    Value<String>? Unit,
    Value<int>? PriceInCents,
    Value<bool>? IsActive,
  }) {
    return ProductVariantsCompanion(
      ID: ID ?? this.ID,
      ProductID: ProductID ?? this.ProductID,
      Color: Color ?? this.Color,
      Size: Size ?? this.Size,
      Unit: Unit ?? this.Unit,
      PriceInCents: PriceInCents ?? this.PriceInCents,
      IsActive: IsActive ?? this.IsActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (ProductID.present) {
      map['product_i_d'] = Variable<int>(ProductID.value);
    }
    if (Color.present) {
      map['color'] = Variable<String>(Color.value);
    }
    if (Size.present) {
      map['size'] = Variable<String>(Size.value);
    }
    if (Unit.present) {
      map['unit'] = Variable<String>(Unit.value);
    }
    if (PriceInCents.present) {
      map['price_in_cents'] = Variable<int>(PriceInCents.value);
    }
    if (IsActive.present) {
      map['is_active'] = Variable<bool>(IsActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('ID: $ID, ')
          ..write('ProductID: $ProductID, ')
          ..write('Color: $Color, ')
          ..write('Size: $Size, ')
          ..write('Unit: $Unit, ')
          ..write('PriceInCents: $PriceInCents, ')
          ..write('IsActive: $IsActive')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ReceiptNumberMeta = const VerificationMeta(
    'ReceiptNumber',
  );
  @override
  late final GeneratedColumn<String> ReceiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _CashierNameMeta = const VerificationMeta(
    'CashierName',
  );
  @override
  late final GeneratedColumn<String> CashierName = GeneratedColumn<String>(
    'cashier_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _TotalInCentsMeta = const VerificationMeta(
    'TotalInCents',
  );
  @override
  late final GeneratedColumn<int> TotalInCents = GeneratedColumn<int>(
    'total_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _StatusMeta = const VerificationMeta('Status');
  @override
  late final GeneratedColumn<String> Status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _PaymentMethodMeta = const VerificationMeta(
    'PaymentMethod',
  );
  @override
  late final GeneratedColumn<String> PaymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _SyncStatusMeta = const VerificationMeta(
    'SyncStatus',
  );
  @override
  late final GeneratedColumn<String> SyncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _SyncAttemptCountMeta = const VerificationMeta(
    'SyncAttemptCount',
  );
  @override
  late final GeneratedColumn<int> SyncAttemptCount = GeneratedColumn<int>(
    'sync_attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _LastSyncAttemptAtMeta = const VerificationMeta(
    'LastSyncAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> LastSyncAttemptAt =
      GeneratedColumn<DateTime>(
        'last_sync_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _SyncedAtMeta = const VerificationMeta(
    'SyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> SyncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _LastSyncErrorMeta = const VerificationMeta(
    'LastSyncError',
  );
  @override
  late final GeneratedColumn<String> LastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _SyncBatchIDMeta = const VerificationMeta(
    'SyncBatchID',
  );
  @override
  late final GeneratedColumn<String> SyncBatchID = GeneratedColumn<String>(
    'sync_batch_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _CreatedAtMeta = const VerificationMeta(
    'CreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> CreatedAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    ReceiptNumber,
    CashierName,
    TotalInCents,
    Status,
    PaymentMethod,
    SyncStatus,
    SyncAttemptCount,
    LastSyncAttemptAt,
    SyncedAt,
    LastSyncError,
    SyncBatchID,
    CreatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _ReceiptNumberMeta,
        ReceiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _ReceiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ReceiptNumberMeta);
    }
    if (data.containsKey('cashier_name')) {
      context.handle(
        _CashierNameMeta,
        CashierName.isAcceptableOrUnknown(
          data['cashier_name']!,
          _CashierNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_CashierNameMeta);
    }
    if (data.containsKey('total_in_cents')) {
      context.handle(
        _TotalInCentsMeta,
        TotalInCents.isAcceptableOrUnknown(
          data['total_in_cents']!,
          _TotalInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_TotalInCentsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _StatusMeta,
        Status.isAcceptableOrUnknown(data['status']!, _StatusMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _PaymentMethodMeta,
        PaymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _PaymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _SyncStatusMeta,
        SyncStatus.isAcceptableOrUnknown(data['sync_status']!, _SyncStatusMeta),
      );
    }
    if (data.containsKey('sync_attempt_count')) {
      context.handle(
        _SyncAttemptCountMeta,
        SyncAttemptCount.isAcceptableOrUnknown(
          data['sync_attempt_count']!,
          _SyncAttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_attempt_at')) {
      context.handle(
        _LastSyncAttemptAtMeta,
        LastSyncAttemptAt.isAcceptableOrUnknown(
          data['last_sync_attempt_at']!,
          _LastSyncAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _SyncedAtMeta,
        SyncedAt.isAcceptableOrUnknown(data['synced_at']!, _SyncedAtMeta),
      );
    }
    if (data.containsKey('last_sync_error')) {
      context.handle(
        _LastSyncErrorMeta,
        LastSyncError.isAcceptableOrUnknown(
          data['last_sync_error']!,
          _LastSyncErrorMeta,
        ),
      );
    }
    if (data.containsKey('sync_batch_i_d')) {
      context.handle(
        _SyncBatchIDMeta,
        SyncBatchID.isAcceptableOrUnknown(
          data['sync_batch_i_d']!,
          _SyncBatchIDMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _CreatedAtMeta,
        CreatedAt.isAcceptableOrUnknown(data['created_at']!, _CreatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ReceiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      CashierName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cashier_name'],
      )!,
      TotalInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_in_cents'],
      )!,
      Status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      PaymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      SyncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      SyncAttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_attempt_count'],
      )!,
      LastSyncAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_attempt_at'],
      ),
      SyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      LastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      SyncBatchID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_batch_i_d'],
      ),
      CreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int ID;
  final String ReceiptNumber;
  final String CashierName;
  final int TotalInCents;
  final String Status;
  final String PaymentMethod;

  /// pending, uploading, synced, or failed.
  final String SyncStatus;
  final int SyncAttemptCount;
  final DateTime? LastSyncAttemptAt;
  final DateTime? SyncedAt;
  final String? LastSyncError;
  final String? SyncBatchID;
  final DateTime CreatedAt;
  const Transaction({
    required this.ID,
    required this.ReceiptNumber,
    required this.CashierName,
    required this.TotalInCents,
    required this.Status,
    required this.PaymentMethod,
    required this.SyncStatus,
    required this.SyncAttemptCount,
    this.LastSyncAttemptAt,
    this.SyncedAt,
    this.LastSyncError,
    this.SyncBatchID,
    required this.CreatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['receipt_number'] = Variable<String>(ReceiptNumber);
    map['cashier_name'] = Variable<String>(CashierName);
    map['total_in_cents'] = Variable<int>(TotalInCents);
    map['status'] = Variable<String>(Status);
    map['payment_method'] = Variable<String>(PaymentMethod);
    map['sync_status'] = Variable<String>(SyncStatus);
    map['sync_attempt_count'] = Variable<int>(SyncAttemptCount);
    if (!nullToAbsent || LastSyncAttemptAt != null) {
      map['last_sync_attempt_at'] = Variable<DateTime>(LastSyncAttemptAt);
    }
    if (!nullToAbsent || SyncedAt != null) {
      map['synced_at'] = Variable<DateTime>(SyncedAt);
    }
    if (!nullToAbsent || LastSyncError != null) {
      map['last_sync_error'] = Variable<String>(LastSyncError);
    }
    if (!nullToAbsent || SyncBatchID != null) {
      map['sync_batch_i_d'] = Variable<String>(SyncBatchID);
    }
    map['created_at'] = Variable<DateTime>(CreatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      ID: Value(ID),
      ReceiptNumber: Value(ReceiptNumber),
      CashierName: Value(CashierName),
      TotalInCents: Value(TotalInCents),
      Status: Value(Status),
      PaymentMethod: Value(PaymentMethod),
      SyncStatus: Value(SyncStatus),
      SyncAttemptCount: Value(SyncAttemptCount),
      LastSyncAttemptAt: LastSyncAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(LastSyncAttemptAt),
      SyncedAt: SyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(SyncedAt),
      LastSyncError: LastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(LastSyncError),
      SyncBatchID: SyncBatchID == null && nullToAbsent
          ? const Value.absent()
          : Value(SyncBatchID),
      CreatedAt: Value(CreatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      ID: serializer.fromJson<int>(json['ID']),
      ReceiptNumber: serializer.fromJson<String>(json['ReceiptNumber']),
      CashierName: serializer.fromJson<String>(json['CashierName']),
      TotalInCents: serializer.fromJson<int>(json['TotalInCents']),
      Status: serializer.fromJson<String>(json['Status']),
      PaymentMethod: serializer.fromJson<String>(json['PaymentMethod']),
      SyncStatus: serializer.fromJson<String>(json['SyncStatus']),
      SyncAttemptCount: serializer.fromJson<int>(json['SyncAttemptCount']),
      LastSyncAttemptAt: serializer.fromJson<DateTime?>(
        json['LastSyncAttemptAt'],
      ),
      SyncedAt: serializer.fromJson<DateTime?>(json['SyncedAt']),
      LastSyncError: serializer.fromJson<String?>(json['LastSyncError']),
      SyncBatchID: serializer.fromJson<String?>(json['SyncBatchID']),
      CreatedAt: serializer.fromJson<DateTime>(json['CreatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'ReceiptNumber': serializer.toJson<String>(ReceiptNumber),
      'CashierName': serializer.toJson<String>(CashierName),
      'TotalInCents': serializer.toJson<int>(TotalInCents),
      'Status': serializer.toJson<String>(Status),
      'PaymentMethod': serializer.toJson<String>(PaymentMethod),
      'SyncStatus': serializer.toJson<String>(SyncStatus),
      'SyncAttemptCount': serializer.toJson<int>(SyncAttemptCount),
      'LastSyncAttemptAt': serializer.toJson<DateTime?>(LastSyncAttemptAt),
      'SyncedAt': serializer.toJson<DateTime?>(SyncedAt),
      'LastSyncError': serializer.toJson<String?>(LastSyncError),
      'SyncBatchID': serializer.toJson<String?>(SyncBatchID),
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
    };
  }

  Transaction copyWith({
    int? ID,
    String? ReceiptNumber,
    String? CashierName,
    int? TotalInCents,
    String? Status,
    String? PaymentMethod,
    String? SyncStatus,
    int? SyncAttemptCount,
    Value<DateTime?> LastSyncAttemptAt = const Value.absent(),
    Value<DateTime?> SyncedAt = const Value.absent(),
    Value<String?> LastSyncError = const Value.absent(),
    Value<String?> SyncBatchID = const Value.absent(),
    DateTime? CreatedAt,
  }) => Transaction(
    ID: ID ?? this.ID,
    ReceiptNumber: ReceiptNumber ?? this.ReceiptNumber,
    CashierName: CashierName ?? this.CashierName,
    TotalInCents: TotalInCents ?? this.TotalInCents,
    Status: Status ?? this.Status,
    PaymentMethod: PaymentMethod ?? this.PaymentMethod,
    SyncStatus: SyncStatus ?? this.SyncStatus,
    SyncAttemptCount: SyncAttemptCount ?? this.SyncAttemptCount,
    LastSyncAttemptAt: LastSyncAttemptAt.present
        ? LastSyncAttemptAt.value
        : this.LastSyncAttemptAt,
    SyncedAt: SyncedAt.present ? SyncedAt.value : this.SyncedAt,
    LastSyncError: LastSyncError.present
        ? LastSyncError.value
        : this.LastSyncError,
    SyncBatchID: SyncBatchID.present ? SyncBatchID.value : this.SyncBatchID,
    CreatedAt: CreatedAt ?? this.CreatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      ID: data.ID.present ? data.ID.value : this.ID,
      ReceiptNumber: data.ReceiptNumber.present
          ? data.ReceiptNumber.value
          : this.ReceiptNumber,
      CashierName: data.CashierName.present
          ? data.CashierName.value
          : this.CashierName,
      TotalInCents: data.TotalInCents.present
          ? data.TotalInCents.value
          : this.TotalInCents,
      Status: data.Status.present ? data.Status.value : this.Status,
      PaymentMethod: data.PaymentMethod.present
          ? data.PaymentMethod.value
          : this.PaymentMethod,
      SyncStatus: data.SyncStatus.present
          ? data.SyncStatus.value
          : this.SyncStatus,
      SyncAttemptCount: data.SyncAttemptCount.present
          ? data.SyncAttemptCount.value
          : this.SyncAttemptCount,
      LastSyncAttemptAt: data.LastSyncAttemptAt.present
          ? data.LastSyncAttemptAt.value
          : this.LastSyncAttemptAt,
      SyncedAt: data.SyncedAt.present ? data.SyncedAt.value : this.SyncedAt,
      LastSyncError: data.LastSyncError.present
          ? data.LastSyncError.value
          : this.LastSyncError,
      SyncBatchID: data.SyncBatchID.present
          ? data.SyncBatchID.value
          : this.SyncBatchID,
      CreatedAt: data.CreatedAt.present ? data.CreatedAt.value : this.CreatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('ID: $ID, ')
          ..write('ReceiptNumber: $ReceiptNumber, ')
          ..write('CashierName: $CashierName, ')
          ..write('TotalInCents: $TotalInCents, ')
          ..write('Status: $Status, ')
          ..write('PaymentMethod: $PaymentMethod, ')
          ..write('SyncStatus: $SyncStatus, ')
          ..write('SyncAttemptCount: $SyncAttemptCount, ')
          ..write('LastSyncAttemptAt: $LastSyncAttemptAt, ')
          ..write('SyncedAt: $SyncedAt, ')
          ..write('LastSyncError: $LastSyncError, ')
          ..write('SyncBatchID: $SyncBatchID, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    ReceiptNumber,
    CashierName,
    TotalInCents,
    Status,
    PaymentMethod,
    SyncStatus,
    SyncAttemptCount,
    LastSyncAttemptAt,
    SyncedAt,
    LastSyncError,
    SyncBatchID,
    CreatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.ID == this.ID &&
          other.ReceiptNumber == this.ReceiptNumber &&
          other.CashierName == this.CashierName &&
          other.TotalInCents == this.TotalInCents &&
          other.Status == this.Status &&
          other.PaymentMethod == this.PaymentMethod &&
          other.SyncStatus == this.SyncStatus &&
          other.SyncAttemptCount == this.SyncAttemptCount &&
          other.LastSyncAttemptAt == this.LastSyncAttemptAt &&
          other.SyncedAt == this.SyncedAt &&
          other.LastSyncError == this.LastSyncError &&
          other.SyncBatchID == this.SyncBatchID &&
          other.CreatedAt == this.CreatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> ID;
  final Value<String> ReceiptNumber;
  final Value<String> CashierName;
  final Value<int> TotalInCents;
  final Value<String> Status;
  final Value<String> PaymentMethod;
  final Value<String> SyncStatus;
  final Value<int> SyncAttemptCount;
  final Value<DateTime?> LastSyncAttemptAt;
  final Value<DateTime?> SyncedAt;
  final Value<String?> LastSyncError;
  final Value<String?> SyncBatchID;
  final Value<DateTime> CreatedAt;
  const TransactionsCompanion({
    this.ID = const Value.absent(),
    this.ReceiptNumber = const Value.absent(),
    this.CashierName = const Value.absent(),
    this.TotalInCents = const Value.absent(),
    this.Status = const Value.absent(),
    this.PaymentMethod = const Value.absent(),
    this.SyncStatus = const Value.absent(),
    this.SyncAttemptCount = const Value.absent(),
    this.LastSyncAttemptAt = const Value.absent(),
    this.SyncedAt = const Value.absent(),
    this.LastSyncError = const Value.absent(),
    this.SyncBatchID = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.ID = const Value.absent(),
    required String ReceiptNumber,
    required String CashierName,
    required int TotalInCents,
    this.Status = const Value.absent(),
    this.PaymentMethod = const Value.absent(),
    this.SyncStatus = const Value.absent(),
    this.SyncAttemptCount = const Value.absent(),
    this.LastSyncAttemptAt = const Value.absent(),
    this.SyncedAt = const Value.absent(),
    this.LastSyncError = const Value.absent(),
    this.SyncBatchID = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  }) : ReceiptNumber = Value(ReceiptNumber),
       CashierName = Value(CashierName),
       TotalInCents = Value(TotalInCents);
  static Insertable<Transaction> custom({
    Expression<int>? ID,
    Expression<String>? ReceiptNumber,
    Expression<String>? CashierName,
    Expression<int>? TotalInCents,
    Expression<String>? Status,
    Expression<String>? PaymentMethod,
    Expression<String>? SyncStatus,
    Expression<int>? SyncAttemptCount,
    Expression<DateTime>? LastSyncAttemptAt,
    Expression<DateTime>? SyncedAt,
    Expression<String>? LastSyncError,
    Expression<String>? SyncBatchID,
    Expression<DateTime>? CreatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (ReceiptNumber != null) 'receipt_number': ReceiptNumber,
      if (CashierName != null) 'cashier_name': CashierName,
      if (TotalInCents != null) 'total_in_cents': TotalInCents,
      if (Status != null) 'status': Status,
      if (PaymentMethod != null) 'payment_method': PaymentMethod,
      if (SyncStatus != null) 'sync_status': SyncStatus,
      if (SyncAttemptCount != null) 'sync_attempt_count': SyncAttemptCount,
      if (LastSyncAttemptAt != null) 'last_sync_attempt_at': LastSyncAttemptAt,
      if (SyncedAt != null) 'synced_at': SyncedAt,
      if (LastSyncError != null) 'last_sync_error': LastSyncError,
      if (SyncBatchID != null) 'sync_batch_i_d': SyncBatchID,
      if (CreatedAt != null) 'created_at': CreatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? ID,
    Value<String>? ReceiptNumber,
    Value<String>? CashierName,
    Value<int>? TotalInCents,
    Value<String>? Status,
    Value<String>? PaymentMethod,
    Value<String>? SyncStatus,
    Value<int>? SyncAttemptCount,
    Value<DateTime?>? LastSyncAttemptAt,
    Value<DateTime?>? SyncedAt,
    Value<String?>? LastSyncError,
    Value<String?>? SyncBatchID,
    Value<DateTime>? CreatedAt,
  }) {
    return TransactionsCompanion(
      ID: ID ?? this.ID,
      ReceiptNumber: ReceiptNumber ?? this.ReceiptNumber,
      CashierName: CashierName ?? this.CashierName,
      TotalInCents: TotalInCents ?? this.TotalInCents,
      Status: Status ?? this.Status,
      PaymentMethod: PaymentMethod ?? this.PaymentMethod,
      SyncStatus: SyncStatus ?? this.SyncStatus,
      SyncAttemptCount: SyncAttemptCount ?? this.SyncAttemptCount,
      LastSyncAttemptAt: LastSyncAttemptAt ?? this.LastSyncAttemptAt,
      SyncedAt: SyncedAt ?? this.SyncedAt,
      LastSyncError: LastSyncError ?? this.LastSyncError,
      SyncBatchID: SyncBatchID ?? this.SyncBatchID,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (ReceiptNumber.present) {
      map['receipt_number'] = Variable<String>(ReceiptNumber.value);
    }
    if (CashierName.present) {
      map['cashier_name'] = Variable<String>(CashierName.value);
    }
    if (TotalInCents.present) {
      map['total_in_cents'] = Variable<int>(TotalInCents.value);
    }
    if (Status.present) {
      map['status'] = Variable<String>(Status.value);
    }
    if (PaymentMethod.present) {
      map['payment_method'] = Variable<String>(PaymentMethod.value);
    }
    if (SyncStatus.present) {
      map['sync_status'] = Variable<String>(SyncStatus.value);
    }
    if (SyncAttemptCount.present) {
      map['sync_attempt_count'] = Variable<int>(SyncAttemptCount.value);
    }
    if (LastSyncAttemptAt.present) {
      map['last_sync_attempt_at'] = Variable<DateTime>(LastSyncAttemptAt.value);
    }
    if (SyncedAt.present) {
      map['synced_at'] = Variable<DateTime>(SyncedAt.value);
    }
    if (LastSyncError.present) {
      map['last_sync_error'] = Variable<String>(LastSyncError.value);
    }
    if (SyncBatchID.present) {
      map['sync_batch_i_d'] = Variable<String>(SyncBatchID.value);
    }
    if (CreatedAt.present) {
      map['created_at'] = Variable<DateTime>(CreatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('ID: $ID, ')
          ..write('ReceiptNumber: $ReceiptNumber, ')
          ..write('CashierName: $CashierName, ')
          ..write('TotalInCents: $TotalInCents, ')
          ..write('Status: $Status, ')
          ..write('PaymentMethod: $PaymentMethod, ')
          ..write('SyncStatus: $SyncStatus, ')
          ..write('SyncAttemptCount: $SyncAttemptCount, ')
          ..write('LastSyncAttemptAt: $LastSyncAttemptAt, ')
          ..write('SyncedAt: $SyncedAt, ')
          ..write('LastSyncError: $LastSyncError, ')
          ..write('SyncBatchID: $SyncBatchID, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _TransactionIDMeta = const VerificationMeta(
    'TransactionID',
  );
  @override
  late final GeneratedColumn<int> TransactionID = GeneratedColumn<int>(
    'transaction_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _ProductVariantIDMeta = const VerificationMeta(
    'ProductVariantID',
  );
  @override
  late final GeneratedColumn<int> ProductVariantID = GeneratedColumn<int>(
    'product_variant_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variants (id)',
    ),
  );
  static const VerificationMeta _ProductNameSnapshotMeta =
      const VerificationMeta('ProductNameSnapshot');
  @override
  late final GeneratedColumn<String> ProductNameSnapshot =
      GeneratedColumn<String>(
        'product_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _UnitSnapshotMeta = const VerificationMeta(
    'UnitSnapshot',
  );
  @override
  late final GeneratedColumn<String> UnitSnapshot = GeneratedColumn<String>(
    'unit_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _UnitPriceInCentsMeta = const VerificationMeta(
    'UnitPriceInCents',
  );
  @override
  late final GeneratedColumn<int> UnitPriceInCents = GeneratedColumn<int>(
    'unit_price_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _QuantityMeta = const VerificationMeta(
    'Quantity',
  );
  @override
  late final GeneratedColumn<int> Quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _LineTotalInCentsMeta = const VerificationMeta(
    'LineTotalInCents',
  );
  @override
  late final GeneratedColumn<int> LineTotalInCents = GeneratedColumn<int>(
    'line_total_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    TransactionID,
    ProductVariantID,
    ProductNameSnapshot,
    UnitSnapshot,
    UnitPriceInCents,
    Quantity,
    LineTotalInCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('transaction_i_d')) {
      context.handle(
        _TransactionIDMeta,
        TransactionID.isAcceptableOrUnknown(
          data['transaction_i_d']!,
          _TransactionIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_TransactionIDMeta);
    }
    if (data.containsKey('product_variant_i_d')) {
      context.handle(
        _ProductVariantIDMeta,
        ProductVariantID.isAcceptableOrUnknown(
          data['product_variant_i_d']!,
          _ProductVariantIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ProductVariantIDMeta);
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
        _ProductNameSnapshotMeta,
        ProductNameSnapshot.isAcceptableOrUnknown(
          data['product_name_snapshot']!,
          _ProductNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ProductNameSnapshotMeta);
    }
    if (data.containsKey('unit_snapshot')) {
      context.handle(
        _UnitSnapshotMeta,
        UnitSnapshot.isAcceptableOrUnknown(
          data['unit_snapshot']!,
          _UnitSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_UnitSnapshotMeta);
    }
    if (data.containsKey('unit_price_in_cents')) {
      context.handle(
        _UnitPriceInCentsMeta,
        UnitPriceInCents.isAcceptableOrUnknown(
          data['unit_price_in_cents']!,
          _UnitPriceInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_UnitPriceInCentsMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _QuantityMeta,
        Quantity.isAcceptableOrUnknown(data['quantity']!, _QuantityMeta),
      );
    } else if (isInserting) {
      context.missing(_QuantityMeta);
    }
    if (data.containsKey('line_total_in_cents')) {
      context.handle(
        _LineTotalInCentsMeta,
        LineTotalInCents.isAcceptableOrUnknown(
          data['line_total_in_cents']!,
          _LineTotalInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_LineTotalInCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      TransactionID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_i_d'],
      )!,
      ProductVariantID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_variant_i_d'],
      )!,
      ProductNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_snapshot'],
      )!,
      UnitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_snapshot'],
      )!,
      UnitPriceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_in_cents'],
      )!,
      Quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      LineTotalInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total_in_cents'],
      )!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int ID;
  final int TransactionID;
  final int ProductVariantID;
  final String ProductNameSnapshot;
  final String UnitSnapshot;
  final int UnitPriceInCents;
  final int Quantity;
  final int LineTotalInCents;
  const TransactionItem({
    required this.ID,
    required this.TransactionID,
    required this.ProductVariantID,
    required this.ProductNameSnapshot,
    required this.UnitSnapshot,
    required this.UnitPriceInCents,
    required this.Quantity,
    required this.LineTotalInCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['transaction_i_d'] = Variable<int>(TransactionID);
    map['product_variant_i_d'] = Variable<int>(ProductVariantID);
    map['product_name_snapshot'] = Variable<String>(ProductNameSnapshot);
    map['unit_snapshot'] = Variable<String>(UnitSnapshot);
    map['unit_price_in_cents'] = Variable<int>(UnitPriceInCents);
    map['quantity'] = Variable<int>(Quantity);
    map['line_total_in_cents'] = Variable<int>(LineTotalInCents);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      ID: Value(ID),
      TransactionID: Value(TransactionID),
      ProductVariantID: Value(ProductVariantID),
      ProductNameSnapshot: Value(ProductNameSnapshot),
      UnitSnapshot: Value(UnitSnapshot),
      UnitPriceInCents: Value(UnitPriceInCents),
      Quantity: Value(Quantity),
      LineTotalInCents: Value(LineTotalInCents),
    );
  }

  factory TransactionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      ID: serializer.fromJson<int>(json['ID']),
      TransactionID: serializer.fromJson<int>(json['TransactionID']),
      ProductVariantID: serializer.fromJson<int>(json['ProductVariantID']),
      ProductNameSnapshot: serializer.fromJson<String>(
        json['ProductNameSnapshot'],
      ),
      UnitSnapshot: serializer.fromJson<String>(json['UnitSnapshot']),
      UnitPriceInCents: serializer.fromJson<int>(json['UnitPriceInCents']),
      Quantity: serializer.fromJson<int>(json['Quantity']),
      LineTotalInCents: serializer.fromJson<int>(json['LineTotalInCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'TransactionID': serializer.toJson<int>(TransactionID),
      'ProductVariantID': serializer.toJson<int>(ProductVariantID),
      'ProductNameSnapshot': serializer.toJson<String>(ProductNameSnapshot),
      'UnitSnapshot': serializer.toJson<String>(UnitSnapshot),
      'UnitPriceInCents': serializer.toJson<int>(UnitPriceInCents),
      'Quantity': serializer.toJson<int>(Quantity),
      'LineTotalInCents': serializer.toJson<int>(LineTotalInCents),
    };
  }

  TransactionItem copyWith({
    int? ID,
    int? TransactionID,
    int? ProductVariantID,
    String? ProductNameSnapshot,
    String? UnitSnapshot,
    int? UnitPriceInCents,
    int? Quantity,
    int? LineTotalInCents,
  }) => TransactionItem(
    ID: ID ?? this.ID,
    TransactionID: TransactionID ?? this.TransactionID,
    ProductVariantID: ProductVariantID ?? this.ProductVariantID,
    ProductNameSnapshot: ProductNameSnapshot ?? this.ProductNameSnapshot,
    UnitSnapshot: UnitSnapshot ?? this.UnitSnapshot,
    UnitPriceInCents: UnitPriceInCents ?? this.UnitPriceInCents,
    Quantity: Quantity ?? this.Quantity,
    LineTotalInCents: LineTotalInCents ?? this.LineTotalInCents,
  );
  TransactionItem copyWithCompanion(TransactionItemsCompanion data) {
    return TransactionItem(
      ID: data.ID.present ? data.ID.value : this.ID,
      TransactionID: data.TransactionID.present
          ? data.TransactionID.value
          : this.TransactionID,
      ProductVariantID: data.ProductVariantID.present
          ? data.ProductVariantID.value
          : this.ProductVariantID,
      ProductNameSnapshot: data.ProductNameSnapshot.present
          ? data.ProductNameSnapshot.value
          : this.ProductNameSnapshot,
      UnitSnapshot: data.UnitSnapshot.present
          ? data.UnitSnapshot.value
          : this.UnitSnapshot,
      UnitPriceInCents: data.UnitPriceInCents.present
          ? data.UnitPriceInCents.value
          : this.UnitPriceInCents,
      Quantity: data.Quantity.present ? data.Quantity.value : this.Quantity,
      LineTotalInCents: data.LineTotalInCents.present
          ? data.LineTotalInCents.value
          : this.LineTotalInCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItem(')
          ..write('ID: $ID, ')
          ..write('TransactionID: $TransactionID, ')
          ..write('ProductVariantID: $ProductVariantID, ')
          ..write('ProductNameSnapshot: $ProductNameSnapshot, ')
          ..write('UnitSnapshot: $UnitSnapshot, ')
          ..write('UnitPriceInCents: $UnitPriceInCents, ')
          ..write('Quantity: $Quantity, ')
          ..write('LineTotalInCents: $LineTotalInCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    TransactionID,
    ProductVariantID,
    ProductNameSnapshot,
    UnitSnapshot,
    UnitPriceInCents,
    Quantity,
    LineTotalInCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItem &&
          other.ID == this.ID &&
          other.TransactionID == this.TransactionID &&
          other.ProductVariantID == this.ProductVariantID &&
          other.ProductNameSnapshot == this.ProductNameSnapshot &&
          other.UnitSnapshot == this.UnitSnapshot &&
          other.UnitPriceInCents == this.UnitPriceInCents &&
          other.Quantity == this.Quantity &&
          other.LineTotalInCents == this.LineTotalInCents);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> ID;
  final Value<int> TransactionID;
  final Value<int> ProductVariantID;
  final Value<String> ProductNameSnapshot;
  final Value<String> UnitSnapshot;
  final Value<int> UnitPriceInCents;
  final Value<int> Quantity;
  final Value<int> LineTotalInCents;
  const TransactionItemsCompanion({
    this.ID = const Value.absent(),
    this.TransactionID = const Value.absent(),
    this.ProductVariantID = const Value.absent(),
    this.ProductNameSnapshot = const Value.absent(),
    this.UnitSnapshot = const Value.absent(),
    this.UnitPriceInCents = const Value.absent(),
    this.Quantity = const Value.absent(),
    this.LineTotalInCents = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.ID = const Value.absent(),
    required int TransactionID,
    required int ProductVariantID,
    required String ProductNameSnapshot,
    required String UnitSnapshot,
    required int UnitPriceInCents,
    required int Quantity,
    required int LineTotalInCents,
  }) : TransactionID = Value(TransactionID),
       ProductVariantID = Value(ProductVariantID),
       ProductNameSnapshot = Value(ProductNameSnapshot),
       UnitSnapshot = Value(UnitSnapshot),
       UnitPriceInCents = Value(UnitPriceInCents),
       Quantity = Value(Quantity),
       LineTotalInCents = Value(LineTotalInCents);
  static Insertable<TransactionItem> custom({
    Expression<int>? ID,
    Expression<int>? TransactionID,
    Expression<int>? ProductVariantID,
    Expression<String>? ProductNameSnapshot,
    Expression<String>? UnitSnapshot,
    Expression<int>? UnitPriceInCents,
    Expression<int>? Quantity,
    Expression<int>? LineTotalInCents,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (TransactionID != null) 'transaction_i_d': TransactionID,
      if (ProductVariantID != null) 'product_variant_i_d': ProductVariantID,
      if (ProductNameSnapshot != null)
        'product_name_snapshot': ProductNameSnapshot,
      if (UnitSnapshot != null) 'unit_snapshot': UnitSnapshot,
      if (UnitPriceInCents != null) 'unit_price_in_cents': UnitPriceInCents,
      if (Quantity != null) 'quantity': Quantity,
      if (LineTotalInCents != null) 'line_total_in_cents': LineTotalInCents,
    });
  }

  TransactionItemsCompanion copyWith({
    Value<int>? ID,
    Value<int>? TransactionID,
    Value<int>? ProductVariantID,
    Value<String>? ProductNameSnapshot,
    Value<String>? UnitSnapshot,
    Value<int>? UnitPriceInCents,
    Value<int>? Quantity,
    Value<int>? LineTotalInCents,
  }) {
    return TransactionItemsCompanion(
      ID: ID ?? this.ID,
      TransactionID: TransactionID ?? this.TransactionID,
      ProductVariantID: ProductVariantID ?? this.ProductVariantID,
      ProductNameSnapshot: ProductNameSnapshot ?? this.ProductNameSnapshot,
      UnitSnapshot: UnitSnapshot ?? this.UnitSnapshot,
      UnitPriceInCents: UnitPriceInCents ?? this.UnitPriceInCents,
      Quantity: Quantity ?? this.Quantity,
      LineTotalInCents: LineTotalInCents ?? this.LineTotalInCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (TransactionID.present) {
      map['transaction_i_d'] = Variable<int>(TransactionID.value);
    }
    if (ProductVariantID.present) {
      map['product_variant_i_d'] = Variable<int>(ProductVariantID.value);
    }
    if (ProductNameSnapshot.present) {
      map['product_name_snapshot'] = Variable<String>(
        ProductNameSnapshot.value,
      );
    }
    if (UnitSnapshot.present) {
      map['unit_snapshot'] = Variable<String>(UnitSnapshot.value);
    }
    if (UnitPriceInCents.present) {
      map['unit_price_in_cents'] = Variable<int>(UnitPriceInCents.value);
    }
    if (Quantity.present) {
      map['quantity'] = Variable<int>(Quantity.value);
    }
    if (LineTotalInCents.present) {
      map['line_total_in_cents'] = Variable<int>(LineTotalInCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('ID: $ID, ')
          ..write('TransactionID: $TransactionID, ')
          ..write('ProductVariantID: $ProductVariantID, ')
          ..write('ProductNameSnapshot: $ProductNameSnapshot, ')
          ..write('UnitSnapshot: $UnitSnapshot, ')
          ..write('UnitPriceInCents: $UnitPriceInCents, ')
          ..write('Quantity: $Quantity, ')
          ..write('LineTotalInCents: $LineTotalInCents')
          ..write(')'))
        .toString();
  }
}

class $TransactionPrintJobsTable extends TransactionPrintJobs
    with TableInfo<$TransactionPrintJobsTable, TransactionPrintJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionPrintJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _TransactionIDMeta = const VerificationMeta(
    'TransactionID',
  );
  @override
  late final GeneratedColumn<int> TransactionID = GeneratedColumn<int>(
    'transaction_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES transactions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _StatusMeta = const VerificationMeta('Status');
  @override
  late final GeneratedColumn<String> Status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _AttemptCountMeta = const VerificationMeta(
    'AttemptCount',
  );
  @override
  late final GeneratedColumn<int> AttemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _LastAttemptAtMeta = const VerificationMeta(
    'LastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> LastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _PrintedAtMeta = const VerificationMeta(
    'PrintedAt',
  );
  @override
  late final GeneratedColumn<DateTime> PrintedAt = GeneratedColumn<DateTime>(
    'printed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _LastErrorMeta = const VerificationMeta(
    'LastError',
  );
  @override
  late final GeneratedColumn<String> LastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _CreatedAtMeta = const VerificationMeta(
    'CreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> CreatedAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    TransactionID,
    Status,
    AttemptCount,
    LastAttemptAt,
    PrintedAt,
    LastError,
    CreatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_print_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionPrintJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('transaction_i_d')) {
      context.handle(
        _TransactionIDMeta,
        TransactionID.isAcceptableOrUnknown(
          data['transaction_i_d']!,
          _TransactionIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_TransactionIDMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _StatusMeta,
        Status.isAcceptableOrUnknown(data['status']!, _StatusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _AttemptCountMeta,
        AttemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _AttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _LastAttemptAtMeta,
        LastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _LastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('printed_at')) {
      context.handle(
        _PrintedAtMeta,
        PrintedAt.isAcceptableOrUnknown(data['printed_at']!, _PrintedAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _LastErrorMeta,
        LastError.isAcceptableOrUnknown(data['last_error']!, _LastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _CreatedAtMeta,
        CreatedAt.isAcceptableOrUnknown(data['created_at']!, _CreatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  TransactionPrintJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionPrintJob(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      TransactionID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_i_d'],
      )!,
      Status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      AttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      LastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      PrintedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}printed_at'],
      ),
      LastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      CreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionPrintJobsTable createAlias(String alias) {
    return $TransactionPrintJobsTable(attachedDatabase, alias);
  }
}

class TransactionPrintJob extends DataClass
    implements Insertable<TransactionPrintJob> {
  final int ID;
  final int TransactionID;

  /// pending, printing, printed, or failed.
  final String Status;
  final int AttemptCount;
  final DateTime? LastAttemptAt;
  final DateTime? PrintedAt;
  final String? LastError;
  final DateTime CreatedAt;
  const TransactionPrintJob({
    required this.ID,
    required this.TransactionID,
    required this.Status,
    required this.AttemptCount,
    this.LastAttemptAt,
    this.PrintedAt,
    this.LastError,
    required this.CreatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['transaction_i_d'] = Variable<int>(TransactionID);
    map['status'] = Variable<String>(Status);
    map['attempt_count'] = Variable<int>(AttemptCount);
    if (!nullToAbsent || LastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(LastAttemptAt);
    }
    if (!nullToAbsent || PrintedAt != null) {
      map['printed_at'] = Variable<DateTime>(PrintedAt);
    }
    if (!nullToAbsent || LastError != null) {
      map['last_error'] = Variable<String>(LastError);
    }
    map['created_at'] = Variable<DateTime>(CreatedAt);
    return map;
  }

  TransactionPrintJobsCompanion toCompanion(bool nullToAbsent) {
    return TransactionPrintJobsCompanion(
      ID: Value(ID),
      TransactionID: Value(TransactionID),
      Status: Value(Status),
      AttemptCount: Value(AttemptCount),
      LastAttemptAt: LastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(LastAttemptAt),
      PrintedAt: PrintedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(PrintedAt),
      LastError: LastError == null && nullToAbsent
          ? const Value.absent()
          : Value(LastError),
      CreatedAt: Value(CreatedAt),
    );
  }

  factory TransactionPrintJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionPrintJob(
      ID: serializer.fromJson<int>(json['ID']),
      TransactionID: serializer.fromJson<int>(json['TransactionID']),
      Status: serializer.fromJson<String>(json['Status']),
      AttemptCount: serializer.fromJson<int>(json['AttemptCount']),
      LastAttemptAt: serializer.fromJson<DateTime?>(json['LastAttemptAt']),
      PrintedAt: serializer.fromJson<DateTime?>(json['PrintedAt']),
      LastError: serializer.fromJson<String?>(json['LastError']),
      CreatedAt: serializer.fromJson<DateTime>(json['CreatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'TransactionID': serializer.toJson<int>(TransactionID),
      'Status': serializer.toJson<String>(Status),
      'AttemptCount': serializer.toJson<int>(AttemptCount),
      'LastAttemptAt': serializer.toJson<DateTime?>(LastAttemptAt),
      'PrintedAt': serializer.toJson<DateTime?>(PrintedAt),
      'LastError': serializer.toJson<String?>(LastError),
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
    };
  }

  TransactionPrintJob copyWith({
    int? ID,
    int? TransactionID,
    String? Status,
    int? AttemptCount,
    Value<DateTime?> LastAttemptAt = const Value.absent(),
    Value<DateTime?> PrintedAt = const Value.absent(),
    Value<String?> LastError = const Value.absent(),
    DateTime? CreatedAt,
  }) => TransactionPrintJob(
    ID: ID ?? this.ID,
    TransactionID: TransactionID ?? this.TransactionID,
    Status: Status ?? this.Status,
    AttemptCount: AttemptCount ?? this.AttemptCount,
    LastAttemptAt: LastAttemptAt.present
        ? LastAttemptAt.value
        : this.LastAttemptAt,
    PrintedAt: PrintedAt.present ? PrintedAt.value : this.PrintedAt,
    LastError: LastError.present ? LastError.value : this.LastError,
    CreatedAt: CreatedAt ?? this.CreatedAt,
  );
  TransactionPrintJob copyWithCompanion(TransactionPrintJobsCompanion data) {
    return TransactionPrintJob(
      ID: data.ID.present ? data.ID.value : this.ID,
      TransactionID: data.TransactionID.present
          ? data.TransactionID.value
          : this.TransactionID,
      Status: data.Status.present ? data.Status.value : this.Status,
      AttemptCount: data.AttemptCount.present
          ? data.AttemptCount.value
          : this.AttemptCount,
      LastAttemptAt: data.LastAttemptAt.present
          ? data.LastAttemptAt.value
          : this.LastAttemptAt,
      PrintedAt: data.PrintedAt.present ? data.PrintedAt.value : this.PrintedAt,
      LastError: data.LastError.present ? data.LastError.value : this.LastError,
      CreatedAt: data.CreatedAt.present ? data.CreatedAt.value : this.CreatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionPrintJob(')
          ..write('ID: $ID, ')
          ..write('TransactionID: $TransactionID, ')
          ..write('Status: $Status, ')
          ..write('AttemptCount: $AttemptCount, ')
          ..write('LastAttemptAt: $LastAttemptAt, ')
          ..write('PrintedAt: $PrintedAt, ')
          ..write('LastError: $LastError, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    TransactionID,
    Status,
    AttemptCount,
    LastAttemptAt,
    PrintedAt,
    LastError,
    CreatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionPrintJob &&
          other.ID == this.ID &&
          other.TransactionID == this.TransactionID &&
          other.Status == this.Status &&
          other.AttemptCount == this.AttemptCount &&
          other.LastAttemptAt == this.LastAttemptAt &&
          other.PrintedAt == this.PrintedAt &&
          other.LastError == this.LastError &&
          other.CreatedAt == this.CreatedAt);
}

class TransactionPrintJobsCompanion
    extends UpdateCompanion<TransactionPrintJob> {
  final Value<int> ID;
  final Value<int> TransactionID;
  final Value<String> Status;
  final Value<int> AttemptCount;
  final Value<DateTime?> LastAttemptAt;
  final Value<DateTime?> PrintedAt;
  final Value<String?> LastError;
  final Value<DateTime> CreatedAt;
  const TransactionPrintJobsCompanion({
    this.ID = const Value.absent(),
    this.TransactionID = const Value.absent(),
    this.Status = const Value.absent(),
    this.AttemptCount = const Value.absent(),
    this.LastAttemptAt = const Value.absent(),
    this.PrintedAt = const Value.absent(),
    this.LastError = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  });
  TransactionPrintJobsCompanion.insert({
    this.ID = const Value.absent(),
    required int TransactionID,
    this.Status = const Value.absent(),
    this.AttemptCount = const Value.absent(),
    this.LastAttemptAt = const Value.absent(),
    this.PrintedAt = const Value.absent(),
    this.LastError = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  }) : TransactionID = Value(TransactionID);
  static Insertable<TransactionPrintJob> custom({
    Expression<int>? ID,
    Expression<int>? TransactionID,
    Expression<String>? Status,
    Expression<int>? AttemptCount,
    Expression<DateTime>? LastAttemptAt,
    Expression<DateTime>? PrintedAt,
    Expression<String>? LastError,
    Expression<DateTime>? CreatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (TransactionID != null) 'transaction_i_d': TransactionID,
      if (Status != null) 'status': Status,
      if (AttemptCount != null) 'attempt_count': AttemptCount,
      if (LastAttemptAt != null) 'last_attempt_at': LastAttemptAt,
      if (PrintedAt != null) 'printed_at': PrintedAt,
      if (LastError != null) 'last_error': LastError,
      if (CreatedAt != null) 'created_at': CreatedAt,
    });
  }

  TransactionPrintJobsCompanion copyWith({
    Value<int>? ID,
    Value<int>? TransactionID,
    Value<String>? Status,
    Value<int>? AttemptCount,
    Value<DateTime?>? LastAttemptAt,
    Value<DateTime?>? PrintedAt,
    Value<String?>? LastError,
    Value<DateTime>? CreatedAt,
  }) {
    return TransactionPrintJobsCompanion(
      ID: ID ?? this.ID,
      TransactionID: TransactionID ?? this.TransactionID,
      Status: Status ?? this.Status,
      AttemptCount: AttemptCount ?? this.AttemptCount,
      LastAttemptAt: LastAttemptAt ?? this.LastAttemptAt,
      PrintedAt: PrintedAt ?? this.PrintedAt,
      LastError: LastError ?? this.LastError,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (TransactionID.present) {
      map['transaction_i_d'] = Variable<int>(TransactionID.value);
    }
    if (Status.present) {
      map['status'] = Variable<String>(Status.value);
    }
    if (AttemptCount.present) {
      map['attempt_count'] = Variable<int>(AttemptCount.value);
    }
    if (LastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(LastAttemptAt.value);
    }
    if (PrintedAt.present) {
      map['printed_at'] = Variable<DateTime>(PrintedAt.value);
    }
    if (LastError.present) {
      map['last_error'] = Variable<String>(LastError.value);
    }
    if (CreatedAt.present) {
      map['created_at'] = Variable<DateTime>(CreatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionPrintJobsCompanion(')
          ..write('ID: $ID, ')
          ..write('TransactionID: $TransactionID, ')
          ..write('Status: $Status, ')
          ..write('AttemptCount: $AttemptCount, ')
          ..write('LastAttemptAt: $LastAttemptAt, ')
          ..write('PrintedAt: $PrintedAt, ')
          ..write('LastError: $LastError, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionSyncBatchesTable extends TransactionSyncBatches
    with TableInfo<$TransactionSyncBatchesTable, TransactionSyncBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSyncBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _BusinessDateMeta = const VerificationMeta(
    'BusinessDate',
  );
  @override
  late final GeneratedColumn<String> BusinessDate = GeneratedColumn<String>(
    'business_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _FileNameMeta = const VerificationMeta(
    'FileName',
  );
  @override
  late final GeneratedColumn<String> FileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _TextFileNameMeta = const VerificationMeta(
    'TextFileName',
  );
  @override
  late final GeneratedColumn<String> TextFileName = GeneratedColumn<String>(
    'text_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _LocalFilePathMeta = const VerificationMeta(
    'LocalFilePath',
  );
  @override
  late final GeneratedColumn<String> LocalFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _TextLocalFilePathMeta = const VerificationMeta(
    'TextLocalFilePath',
  );
  @override
  late final GeneratedColumn<String> TextLocalFilePath =
      GeneratedColumn<String>(
        'text_local_file_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _RemoteFileIDMeta = const VerificationMeta(
    'RemoteFileID',
  );
  @override
  late final GeneratedColumn<String> RemoteFileID = GeneratedColumn<String>(
    'remote_file_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _RemoteTextFileIDMeta = const VerificationMeta(
    'RemoteTextFileID',
  );
  @override
  late final GeneratedColumn<String> RemoteTextFileID = GeneratedColumn<String>(
    'remote_text_file_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ChecksumMeta = const VerificationMeta(
    'Checksum',
  );
  @override
  late final GeneratedColumn<String> Checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _TextChecksumMeta = const VerificationMeta(
    'TextChecksum',
  );
  @override
  late final GeneratedColumn<String> TextChecksum = GeneratedColumn<String>(
    'text_checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodFileNameMeta = const VerificationMeta(
    'EodFileName',
  );
  @override
  late final GeneratedColumn<String> EodFileName = GeneratedColumn<String>(
    'eod_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodTextFileNameMeta = const VerificationMeta(
    'EodTextFileName',
  );
  @override
  late final GeneratedColumn<String> EodTextFileName = GeneratedColumn<String>(
    'eod_text_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodLocalFilePathMeta = const VerificationMeta(
    'EodLocalFilePath',
  );
  @override
  late final GeneratedColumn<String> EodLocalFilePath = GeneratedColumn<String>(
    'eod_local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodTextLocalFilePathMeta =
      const VerificationMeta('EodTextLocalFilePath');
  @override
  late final GeneratedColumn<String> EodTextLocalFilePath =
      GeneratedColumn<String>(
        'eod_text_local_file_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _EodRemoteFileIDMeta = const VerificationMeta(
    'EodRemoteFileID',
  );
  @override
  late final GeneratedColumn<String> EodRemoteFileID = GeneratedColumn<String>(
    'eod_remote_file_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodRemoteTextFileIDMeta =
      const VerificationMeta('EodRemoteTextFileID');
  @override
  late final GeneratedColumn<String> EodRemoteTextFileID =
      GeneratedColumn<String>(
        'eod_remote_text_file_i_d',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _EodChecksumMeta = const VerificationMeta(
    'EodChecksum',
  );
  @override
  late final GeneratedColumn<String> EodChecksum = GeneratedColumn<String>(
    'eod_checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _EodTextChecksumMeta = const VerificationMeta(
    'EodTextChecksum',
  );
  @override
  late final GeneratedColumn<String> EodTextChecksum = GeneratedColumn<String>(
    'eod_text_checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _TransactionLogsFolderIDMeta =
      const VerificationMeta('TransactionLogsFolderID');
  @override
  late final GeneratedColumn<String> TransactionLogsFolderID =
      GeneratedColumn<String>(
        'transaction_logs_folder_i_d',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _EodLogsFolderIDMeta = const VerificationMeta(
    'EodLogsFolderID',
  );
  @override
  late final GeneratedColumn<String> EodLogsFolderID = GeneratedColumn<String>(
    'eod_logs_folder_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _RecordCountMeta = const VerificationMeta(
    'RecordCount',
  );
  @override
  late final GeneratedColumn<int> RecordCount = GeneratedColumn<int>(
    'record_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _StatusMeta = const VerificationMeta('Status');
  @override
  late final GeneratedColumn<String> Status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _AttemptCountMeta = const VerificationMeta(
    'AttemptCount',
  );
  @override
  late final GeneratedColumn<int> AttemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _LastAttemptAtMeta = const VerificationMeta(
    'LastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> LastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _LastErrorMeta = const VerificationMeta(
    'LastError',
  );
  @override
  late final GeneratedColumn<String> LastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _UploadedAtMeta = const VerificationMeta(
    'UploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> UploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _CreatedAtMeta = const VerificationMeta(
    'CreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> CreatedAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    BusinessDate,
    FileName,
    TextFileName,
    LocalFilePath,
    TextLocalFilePath,
    RemoteFileID,
    RemoteTextFileID,
    Checksum,
    TextChecksum,
    EodFileName,
    EodTextFileName,
    EodLocalFilePath,
    EodTextLocalFilePath,
    EodRemoteFileID,
    EodRemoteTextFileID,
    EodChecksum,
    EodTextChecksum,
    TransactionLogsFolderID,
    EodLogsFolderID,
    RecordCount,
    Status,
    AttemptCount,
    LastAttemptAt,
    LastError,
    UploadedAt,
    CreatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_sync_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSyncBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('business_date')) {
      context.handle(
        _BusinessDateMeta,
        BusinessDate.isAcceptableOrUnknown(
          data['business_date']!,
          _BusinessDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_BusinessDateMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _FileNameMeta,
        FileName.isAcceptableOrUnknown(data['file_name']!, _FileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_FileNameMeta);
    }
    if (data.containsKey('text_file_name')) {
      context.handle(
        _TextFileNameMeta,
        TextFileName.isAcceptableOrUnknown(
          data['text_file_name']!,
          _TextFileNameMeta,
        ),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _LocalFilePathMeta,
        LocalFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _LocalFilePathMeta,
        ),
      );
    }
    if (data.containsKey('text_local_file_path')) {
      context.handle(
        _TextLocalFilePathMeta,
        TextLocalFilePath.isAcceptableOrUnknown(
          data['text_local_file_path']!,
          _TextLocalFilePathMeta,
        ),
      );
    }
    if (data.containsKey('remote_file_i_d')) {
      context.handle(
        _RemoteFileIDMeta,
        RemoteFileID.isAcceptableOrUnknown(
          data['remote_file_i_d']!,
          _RemoteFileIDMeta,
        ),
      );
    }
    if (data.containsKey('remote_text_file_i_d')) {
      context.handle(
        _RemoteTextFileIDMeta,
        RemoteTextFileID.isAcceptableOrUnknown(
          data['remote_text_file_i_d']!,
          _RemoteTextFileIDMeta,
        ),
      );
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _ChecksumMeta,
        Checksum.isAcceptableOrUnknown(data['checksum']!, _ChecksumMeta),
      );
    }
    if (data.containsKey('text_checksum')) {
      context.handle(
        _TextChecksumMeta,
        TextChecksum.isAcceptableOrUnknown(
          data['text_checksum']!,
          _TextChecksumMeta,
        ),
      );
    }
    if (data.containsKey('eod_file_name')) {
      context.handle(
        _EodFileNameMeta,
        EodFileName.isAcceptableOrUnknown(
          data['eod_file_name']!,
          _EodFileNameMeta,
        ),
      );
    }
    if (data.containsKey('eod_text_file_name')) {
      context.handle(
        _EodTextFileNameMeta,
        EodTextFileName.isAcceptableOrUnknown(
          data['eod_text_file_name']!,
          _EodTextFileNameMeta,
        ),
      );
    }
    if (data.containsKey('eod_local_file_path')) {
      context.handle(
        _EodLocalFilePathMeta,
        EodLocalFilePath.isAcceptableOrUnknown(
          data['eod_local_file_path']!,
          _EodLocalFilePathMeta,
        ),
      );
    }
    if (data.containsKey('eod_text_local_file_path')) {
      context.handle(
        _EodTextLocalFilePathMeta,
        EodTextLocalFilePath.isAcceptableOrUnknown(
          data['eod_text_local_file_path']!,
          _EodTextLocalFilePathMeta,
        ),
      );
    }
    if (data.containsKey('eod_remote_file_i_d')) {
      context.handle(
        _EodRemoteFileIDMeta,
        EodRemoteFileID.isAcceptableOrUnknown(
          data['eod_remote_file_i_d']!,
          _EodRemoteFileIDMeta,
        ),
      );
    }
    if (data.containsKey('eod_remote_text_file_i_d')) {
      context.handle(
        _EodRemoteTextFileIDMeta,
        EodRemoteTextFileID.isAcceptableOrUnknown(
          data['eod_remote_text_file_i_d']!,
          _EodRemoteTextFileIDMeta,
        ),
      );
    }
    if (data.containsKey('eod_checksum')) {
      context.handle(
        _EodChecksumMeta,
        EodChecksum.isAcceptableOrUnknown(
          data['eod_checksum']!,
          _EodChecksumMeta,
        ),
      );
    }
    if (data.containsKey('eod_text_checksum')) {
      context.handle(
        _EodTextChecksumMeta,
        EodTextChecksum.isAcceptableOrUnknown(
          data['eod_text_checksum']!,
          _EodTextChecksumMeta,
        ),
      );
    }
    if (data.containsKey('transaction_logs_folder_i_d')) {
      context.handle(
        _TransactionLogsFolderIDMeta,
        TransactionLogsFolderID.isAcceptableOrUnknown(
          data['transaction_logs_folder_i_d']!,
          _TransactionLogsFolderIDMeta,
        ),
      );
    }
    if (data.containsKey('eod_logs_folder_i_d')) {
      context.handle(
        _EodLogsFolderIDMeta,
        EodLogsFolderID.isAcceptableOrUnknown(
          data['eod_logs_folder_i_d']!,
          _EodLogsFolderIDMeta,
        ),
      );
    }
    if (data.containsKey('record_count')) {
      context.handle(
        _RecordCountMeta,
        RecordCount.isAcceptableOrUnknown(
          data['record_count']!,
          _RecordCountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _StatusMeta,
        Status.isAcceptableOrUnknown(data['status']!, _StatusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _AttemptCountMeta,
        AttemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _AttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _LastAttemptAtMeta,
        LastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _LastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _LastErrorMeta,
        LastError.isAcceptableOrUnknown(data['last_error']!, _LastErrorMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _UploadedAtMeta,
        UploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _UploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _CreatedAtMeta,
        CreatedAt.isAcceptableOrUnknown(data['created_at']!, _CreatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  TransactionSyncBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSyncBatche(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      BusinessDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_date'],
      )!,
      FileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      TextFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_file_name'],
      ),
      LocalFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      ),
      TextLocalFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_local_file_path'],
      ),
      RemoteFileID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_file_i_d'],
      ),
      RemoteTextFileID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_text_file_i_d'],
      ),
      Checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      ),
      TextChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_checksum'],
      ),
      EodFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_file_name'],
      ),
      EodTextFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_text_file_name'],
      ),
      EodLocalFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_local_file_path'],
      ),
      EodTextLocalFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_text_local_file_path'],
      ),
      EodRemoteFileID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_remote_file_i_d'],
      ),
      EodRemoteTextFileID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_remote_text_file_i_d'],
      ),
      EodChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_checksum'],
      ),
      EodTextChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_text_checksum'],
      ),
      TransactionLogsFolderID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_logs_folder_i_d'],
      ),
      EodLogsFolderID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_logs_folder_i_d'],
      ),
      RecordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_count'],
      )!,
      Status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      AttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      LastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      LastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      UploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      ),
      CreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionSyncBatchesTable createAlias(String alias) {
    return $TransactionSyncBatchesTable(attachedDatabase, alias);
  }
}

class TransactionSyncBatche extends DataClass
    implements Insertable<TransactionSyncBatche> {
  final int ID;

  /// One stable key per local business date, formatted as YYYY-MM-DD.
  final String BusinessDate;
  final String FileName;
  final String? TextFileName;
  final String? LocalFilePath;
  final String? TextLocalFilePath;
  final String? RemoteFileID;
  final String? RemoteTextFileID;
  final String? Checksum;
  final String? TextChecksum;
  final String? EodFileName;
  final String? EodTextFileName;
  final String? EodLocalFilePath;
  final String? EodTextLocalFilePath;
  final String? EodRemoteFileID;
  final String? EodRemoteTextFileID;
  final String? EodChecksum;
  final String? EodTextChecksum;
  final String? TransactionLogsFolderID;
  final String? EodLogsFolderID;
  final int RecordCount;

  /// pending, uploading, synced, or failed.
  final String Status;
  final int AttemptCount;
  final DateTime? LastAttemptAt;
  final String? LastError;
  final DateTime? UploadedAt;
  final DateTime CreatedAt;
  const TransactionSyncBatche({
    required this.ID,
    required this.BusinessDate,
    required this.FileName,
    this.TextFileName,
    this.LocalFilePath,
    this.TextLocalFilePath,
    this.RemoteFileID,
    this.RemoteTextFileID,
    this.Checksum,
    this.TextChecksum,
    this.EodFileName,
    this.EodTextFileName,
    this.EodLocalFilePath,
    this.EodTextLocalFilePath,
    this.EodRemoteFileID,
    this.EodRemoteTextFileID,
    this.EodChecksum,
    this.EodTextChecksum,
    this.TransactionLogsFolderID,
    this.EodLogsFolderID,
    required this.RecordCount,
    required this.Status,
    required this.AttemptCount,
    this.LastAttemptAt,
    this.LastError,
    this.UploadedAt,
    required this.CreatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['business_date'] = Variable<String>(BusinessDate);
    map['file_name'] = Variable<String>(FileName);
    if (!nullToAbsent || TextFileName != null) {
      map['text_file_name'] = Variable<String>(TextFileName);
    }
    if (!nullToAbsent || LocalFilePath != null) {
      map['local_file_path'] = Variable<String>(LocalFilePath);
    }
    if (!nullToAbsent || TextLocalFilePath != null) {
      map['text_local_file_path'] = Variable<String>(TextLocalFilePath);
    }
    if (!nullToAbsent || RemoteFileID != null) {
      map['remote_file_i_d'] = Variable<String>(RemoteFileID);
    }
    if (!nullToAbsent || RemoteTextFileID != null) {
      map['remote_text_file_i_d'] = Variable<String>(RemoteTextFileID);
    }
    if (!nullToAbsent || Checksum != null) {
      map['checksum'] = Variable<String>(Checksum);
    }
    if (!nullToAbsent || TextChecksum != null) {
      map['text_checksum'] = Variable<String>(TextChecksum);
    }
    if (!nullToAbsent || EodFileName != null) {
      map['eod_file_name'] = Variable<String>(EodFileName);
    }
    if (!nullToAbsent || EodTextFileName != null) {
      map['eod_text_file_name'] = Variable<String>(EodTextFileName);
    }
    if (!nullToAbsent || EodLocalFilePath != null) {
      map['eod_local_file_path'] = Variable<String>(EodLocalFilePath);
    }
    if (!nullToAbsent || EodTextLocalFilePath != null) {
      map['eod_text_local_file_path'] = Variable<String>(EodTextLocalFilePath);
    }
    if (!nullToAbsent || EodRemoteFileID != null) {
      map['eod_remote_file_i_d'] = Variable<String>(EodRemoteFileID);
    }
    if (!nullToAbsent || EodRemoteTextFileID != null) {
      map['eod_remote_text_file_i_d'] = Variable<String>(EodRemoteTextFileID);
    }
    if (!nullToAbsent || EodChecksum != null) {
      map['eod_checksum'] = Variable<String>(EodChecksum);
    }
    if (!nullToAbsent || EodTextChecksum != null) {
      map['eod_text_checksum'] = Variable<String>(EodTextChecksum);
    }
    if (!nullToAbsent || TransactionLogsFolderID != null) {
      map['transaction_logs_folder_i_d'] = Variable<String>(
        TransactionLogsFolderID,
      );
    }
    if (!nullToAbsent || EodLogsFolderID != null) {
      map['eod_logs_folder_i_d'] = Variable<String>(EodLogsFolderID);
    }
    map['record_count'] = Variable<int>(RecordCount);
    map['status'] = Variable<String>(Status);
    map['attempt_count'] = Variable<int>(AttemptCount);
    if (!nullToAbsent || LastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(LastAttemptAt);
    }
    if (!nullToAbsent || LastError != null) {
      map['last_error'] = Variable<String>(LastError);
    }
    if (!nullToAbsent || UploadedAt != null) {
      map['uploaded_at'] = Variable<DateTime>(UploadedAt);
    }
    map['created_at'] = Variable<DateTime>(CreatedAt);
    return map;
  }

  TransactionSyncBatchesCompanion toCompanion(bool nullToAbsent) {
    return TransactionSyncBatchesCompanion(
      ID: Value(ID),
      BusinessDate: Value(BusinessDate),
      FileName: Value(FileName),
      TextFileName: TextFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(TextFileName),
      LocalFilePath: LocalFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(LocalFilePath),
      TextLocalFilePath: TextLocalFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(TextLocalFilePath),
      RemoteFileID: RemoteFileID == null && nullToAbsent
          ? const Value.absent()
          : Value(RemoteFileID),
      RemoteTextFileID: RemoteTextFileID == null && nullToAbsent
          ? const Value.absent()
          : Value(RemoteTextFileID),
      Checksum: Checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(Checksum),
      TextChecksum: TextChecksum == null && nullToAbsent
          ? const Value.absent()
          : Value(TextChecksum),
      EodFileName: EodFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(EodFileName),
      EodTextFileName: EodTextFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(EodTextFileName),
      EodLocalFilePath: EodLocalFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(EodLocalFilePath),
      EodTextLocalFilePath: EodTextLocalFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(EodTextLocalFilePath),
      EodRemoteFileID: EodRemoteFileID == null && nullToAbsent
          ? const Value.absent()
          : Value(EodRemoteFileID),
      EodRemoteTextFileID: EodRemoteTextFileID == null && nullToAbsent
          ? const Value.absent()
          : Value(EodRemoteTextFileID),
      EodChecksum: EodChecksum == null && nullToAbsent
          ? const Value.absent()
          : Value(EodChecksum),
      EodTextChecksum: EodTextChecksum == null && nullToAbsent
          ? const Value.absent()
          : Value(EodTextChecksum),
      TransactionLogsFolderID: TransactionLogsFolderID == null && nullToAbsent
          ? const Value.absent()
          : Value(TransactionLogsFolderID),
      EodLogsFolderID: EodLogsFolderID == null && nullToAbsent
          ? const Value.absent()
          : Value(EodLogsFolderID),
      RecordCount: Value(RecordCount),
      Status: Value(Status),
      AttemptCount: Value(AttemptCount),
      LastAttemptAt: LastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(LastAttemptAt),
      LastError: LastError == null && nullToAbsent
          ? const Value.absent()
          : Value(LastError),
      UploadedAt: UploadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(UploadedAt),
      CreatedAt: Value(CreatedAt),
    );
  }

  factory TransactionSyncBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSyncBatche(
      ID: serializer.fromJson<int>(json['ID']),
      BusinessDate: serializer.fromJson<String>(json['BusinessDate']),
      FileName: serializer.fromJson<String>(json['FileName']),
      TextFileName: serializer.fromJson<String?>(json['TextFileName']),
      LocalFilePath: serializer.fromJson<String?>(json['LocalFilePath']),
      TextLocalFilePath: serializer.fromJson<String?>(
        json['TextLocalFilePath'],
      ),
      RemoteFileID: serializer.fromJson<String?>(json['RemoteFileID']),
      RemoteTextFileID: serializer.fromJson<String?>(json['RemoteTextFileID']),
      Checksum: serializer.fromJson<String?>(json['Checksum']),
      TextChecksum: serializer.fromJson<String?>(json['TextChecksum']),
      EodFileName: serializer.fromJson<String?>(json['EodFileName']),
      EodTextFileName: serializer.fromJson<String?>(json['EodTextFileName']),
      EodLocalFilePath: serializer.fromJson<String?>(json['EodLocalFilePath']),
      EodTextLocalFilePath: serializer.fromJson<String?>(
        json['EodTextLocalFilePath'],
      ),
      EodRemoteFileID: serializer.fromJson<String?>(json['EodRemoteFileID']),
      EodRemoteTextFileID: serializer.fromJson<String?>(
        json['EodRemoteTextFileID'],
      ),
      EodChecksum: serializer.fromJson<String?>(json['EodChecksum']),
      EodTextChecksum: serializer.fromJson<String?>(json['EodTextChecksum']),
      TransactionLogsFolderID: serializer.fromJson<String?>(
        json['TransactionLogsFolderID'],
      ),
      EodLogsFolderID: serializer.fromJson<String?>(json['EodLogsFolderID']),
      RecordCount: serializer.fromJson<int>(json['RecordCount']),
      Status: serializer.fromJson<String>(json['Status']),
      AttemptCount: serializer.fromJson<int>(json['AttemptCount']),
      LastAttemptAt: serializer.fromJson<DateTime?>(json['LastAttemptAt']),
      LastError: serializer.fromJson<String?>(json['LastError']),
      UploadedAt: serializer.fromJson<DateTime?>(json['UploadedAt']),
      CreatedAt: serializer.fromJson<DateTime>(json['CreatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'BusinessDate': serializer.toJson<String>(BusinessDate),
      'FileName': serializer.toJson<String>(FileName),
      'TextFileName': serializer.toJson<String?>(TextFileName),
      'LocalFilePath': serializer.toJson<String?>(LocalFilePath),
      'TextLocalFilePath': serializer.toJson<String?>(TextLocalFilePath),
      'RemoteFileID': serializer.toJson<String?>(RemoteFileID),
      'RemoteTextFileID': serializer.toJson<String?>(RemoteTextFileID),
      'Checksum': serializer.toJson<String?>(Checksum),
      'TextChecksum': serializer.toJson<String?>(TextChecksum),
      'EodFileName': serializer.toJson<String?>(EodFileName),
      'EodTextFileName': serializer.toJson<String?>(EodTextFileName),
      'EodLocalFilePath': serializer.toJson<String?>(EodLocalFilePath),
      'EodTextLocalFilePath': serializer.toJson<String?>(EodTextLocalFilePath),
      'EodRemoteFileID': serializer.toJson<String?>(EodRemoteFileID),
      'EodRemoteTextFileID': serializer.toJson<String?>(EodRemoteTextFileID),
      'EodChecksum': serializer.toJson<String?>(EodChecksum),
      'EodTextChecksum': serializer.toJson<String?>(EodTextChecksum),
      'TransactionLogsFolderID': serializer.toJson<String?>(
        TransactionLogsFolderID,
      ),
      'EodLogsFolderID': serializer.toJson<String?>(EodLogsFolderID),
      'RecordCount': serializer.toJson<int>(RecordCount),
      'Status': serializer.toJson<String>(Status),
      'AttemptCount': serializer.toJson<int>(AttemptCount),
      'LastAttemptAt': serializer.toJson<DateTime?>(LastAttemptAt),
      'LastError': serializer.toJson<String?>(LastError),
      'UploadedAt': serializer.toJson<DateTime?>(UploadedAt),
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
    };
  }

  TransactionSyncBatche copyWith({
    int? ID,
    String? BusinessDate,
    String? FileName,
    Value<String?> TextFileName = const Value.absent(),
    Value<String?> LocalFilePath = const Value.absent(),
    Value<String?> TextLocalFilePath = const Value.absent(),
    Value<String?> RemoteFileID = const Value.absent(),
    Value<String?> RemoteTextFileID = const Value.absent(),
    Value<String?> Checksum = const Value.absent(),
    Value<String?> TextChecksum = const Value.absent(),
    Value<String?> EodFileName = const Value.absent(),
    Value<String?> EodTextFileName = const Value.absent(),
    Value<String?> EodLocalFilePath = const Value.absent(),
    Value<String?> EodTextLocalFilePath = const Value.absent(),
    Value<String?> EodRemoteFileID = const Value.absent(),
    Value<String?> EodRemoteTextFileID = const Value.absent(),
    Value<String?> EodChecksum = const Value.absent(),
    Value<String?> EodTextChecksum = const Value.absent(),
    Value<String?> TransactionLogsFolderID = const Value.absent(),
    Value<String?> EodLogsFolderID = const Value.absent(),
    int? RecordCount,
    String? Status,
    int? AttemptCount,
    Value<DateTime?> LastAttemptAt = const Value.absent(),
    Value<String?> LastError = const Value.absent(),
    Value<DateTime?> UploadedAt = const Value.absent(),
    DateTime? CreatedAt,
  }) => TransactionSyncBatche(
    ID: ID ?? this.ID,
    BusinessDate: BusinessDate ?? this.BusinessDate,
    FileName: FileName ?? this.FileName,
    TextFileName: TextFileName.present ? TextFileName.value : this.TextFileName,
    LocalFilePath: LocalFilePath.present
        ? LocalFilePath.value
        : this.LocalFilePath,
    TextLocalFilePath: TextLocalFilePath.present
        ? TextLocalFilePath.value
        : this.TextLocalFilePath,
    RemoteFileID: RemoteFileID.present ? RemoteFileID.value : this.RemoteFileID,
    RemoteTextFileID: RemoteTextFileID.present
        ? RemoteTextFileID.value
        : this.RemoteTextFileID,
    Checksum: Checksum.present ? Checksum.value : this.Checksum,
    TextChecksum: TextChecksum.present ? TextChecksum.value : this.TextChecksum,
    EodFileName: EodFileName.present ? EodFileName.value : this.EodFileName,
    EodTextFileName: EodTextFileName.present
        ? EodTextFileName.value
        : this.EodTextFileName,
    EodLocalFilePath: EodLocalFilePath.present
        ? EodLocalFilePath.value
        : this.EodLocalFilePath,
    EodTextLocalFilePath: EodTextLocalFilePath.present
        ? EodTextLocalFilePath.value
        : this.EodTextLocalFilePath,
    EodRemoteFileID: EodRemoteFileID.present
        ? EodRemoteFileID.value
        : this.EodRemoteFileID,
    EodRemoteTextFileID: EodRemoteTextFileID.present
        ? EodRemoteTextFileID.value
        : this.EodRemoteTextFileID,
    EodChecksum: EodChecksum.present ? EodChecksum.value : this.EodChecksum,
    EodTextChecksum: EodTextChecksum.present
        ? EodTextChecksum.value
        : this.EodTextChecksum,
    TransactionLogsFolderID: TransactionLogsFolderID.present
        ? TransactionLogsFolderID.value
        : this.TransactionLogsFolderID,
    EodLogsFolderID: EodLogsFolderID.present
        ? EodLogsFolderID.value
        : this.EodLogsFolderID,
    RecordCount: RecordCount ?? this.RecordCount,
    Status: Status ?? this.Status,
    AttemptCount: AttemptCount ?? this.AttemptCount,
    LastAttemptAt: LastAttemptAt.present
        ? LastAttemptAt.value
        : this.LastAttemptAt,
    LastError: LastError.present ? LastError.value : this.LastError,
    UploadedAt: UploadedAt.present ? UploadedAt.value : this.UploadedAt,
    CreatedAt: CreatedAt ?? this.CreatedAt,
  );
  TransactionSyncBatche copyWithCompanion(
    TransactionSyncBatchesCompanion data,
  ) {
    return TransactionSyncBatche(
      ID: data.ID.present ? data.ID.value : this.ID,
      BusinessDate: data.BusinessDate.present
          ? data.BusinessDate.value
          : this.BusinessDate,
      FileName: data.FileName.present ? data.FileName.value : this.FileName,
      TextFileName: data.TextFileName.present
          ? data.TextFileName.value
          : this.TextFileName,
      LocalFilePath: data.LocalFilePath.present
          ? data.LocalFilePath.value
          : this.LocalFilePath,
      TextLocalFilePath: data.TextLocalFilePath.present
          ? data.TextLocalFilePath.value
          : this.TextLocalFilePath,
      RemoteFileID: data.RemoteFileID.present
          ? data.RemoteFileID.value
          : this.RemoteFileID,
      RemoteTextFileID: data.RemoteTextFileID.present
          ? data.RemoteTextFileID.value
          : this.RemoteTextFileID,
      Checksum: data.Checksum.present ? data.Checksum.value : this.Checksum,
      TextChecksum: data.TextChecksum.present
          ? data.TextChecksum.value
          : this.TextChecksum,
      EodFileName: data.EodFileName.present
          ? data.EodFileName.value
          : this.EodFileName,
      EodTextFileName: data.EodTextFileName.present
          ? data.EodTextFileName.value
          : this.EodTextFileName,
      EodLocalFilePath: data.EodLocalFilePath.present
          ? data.EodLocalFilePath.value
          : this.EodLocalFilePath,
      EodTextLocalFilePath: data.EodTextLocalFilePath.present
          ? data.EodTextLocalFilePath.value
          : this.EodTextLocalFilePath,
      EodRemoteFileID: data.EodRemoteFileID.present
          ? data.EodRemoteFileID.value
          : this.EodRemoteFileID,
      EodRemoteTextFileID: data.EodRemoteTextFileID.present
          ? data.EodRemoteTextFileID.value
          : this.EodRemoteTextFileID,
      EodChecksum: data.EodChecksum.present
          ? data.EodChecksum.value
          : this.EodChecksum,
      EodTextChecksum: data.EodTextChecksum.present
          ? data.EodTextChecksum.value
          : this.EodTextChecksum,
      TransactionLogsFolderID: data.TransactionLogsFolderID.present
          ? data.TransactionLogsFolderID.value
          : this.TransactionLogsFolderID,
      EodLogsFolderID: data.EodLogsFolderID.present
          ? data.EodLogsFolderID.value
          : this.EodLogsFolderID,
      RecordCount: data.RecordCount.present
          ? data.RecordCount.value
          : this.RecordCount,
      Status: data.Status.present ? data.Status.value : this.Status,
      AttemptCount: data.AttemptCount.present
          ? data.AttemptCount.value
          : this.AttemptCount,
      LastAttemptAt: data.LastAttemptAt.present
          ? data.LastAttemptAt.value
          : this.LastAttemptAt,
      LastError: data.LastError.present ? data.LastError.value : this.LastError,
      UploadedAt: data.UploadedAt.present
          ? data.UploadedAt.value
          : this.UploadedAt,
      CreatedAt: data.CreatedAt.present ? data.CreatedAt.value : this.CreatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSyncBatche(')
          ..write('ID: $ID, ')
          ..write('BusinessDate: $BusinessDate, ')
          ..write('FileName: $FileName, ')
          ..write('TextFileName: $TextFileName, ')
          ..write('LocalFilePath: $LocalFilePath, ')
          ..write('TextLocalFilePath: $TextLocalFilePath, ')
          ..write('RemoteFileID: $RemoteFileID, ')
          ..write('RemoteTextFileID: $RemoteTextFileID, ')
          ..write('Checksum: $Checksum, ')
          ..write('TextChecksum: $TextChecksum, ')
          ..write('EodFileName: $EodFileName, ')
          ..write('EodTextFileName: $EodTextFileName, ')
          ..write('EodLocalFilePath: $EodLocalFilePath, ')
          ..write('EodTextLocalFilePath: $EodTextLocalFilePath, ')
          ..write('EodRemoteFileID: $EodRemoteFileID, ')
          ..write('EodRemoteTextFileID: $EodRemoteTextFileID, ')
          ..write('EodChecksum: $EodChecksum, ')
          ..write('EodTextChecksum: $EodTextChecksum, ')
          ..write('TransactionLogsFolderID: $TransactionLogsFolderID, ')
          ..write('EodLogsFolderID: $EodLogsFolderID, ')
          ..write('RecordCount: $RecordCount, ')
          ..write('Status: $Status, ')
          ..write('AttemptCount: $AttemptCount, ')
          ..write('LastAttemptAt: $LastAttemptAt, ')
          ..write('LastError: $LastError, ')
          ..write('UploadedAt: $UploadedAt, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    ID,
    BusinessDate,
    FileName,
    TextFileName,
    LocalFilePath,
    TextLocalFilePath,
    RemoteFileID,
    RemoteTextFileID,
    Checksum,
    TextChecksum,
    EodFileName,
    EodTextFileName,
    EodLocalFilePath,
    EodTextLocalFilePath,
    EodRemoteFileID,
    EodRemoteTextFileID,
    EodChecksum,
    EodTextChecksum,
    TransactionLogsFolderID,
    EodLogsFolderID,
    RecordCount,
    Status,
    AttemptCount,
    LastAttemptAt,
    LastError,
    UploadedAt,
    CreatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSyncBatche &&
          other.ID == this.ID &&
          other.BusinessDate == this.BusinessDate &&
          other.FileName == this.FileName &&
          other.TextFileName == this.TextFileName &&
          other.LocalFilePath == this.LocalFilePath &&
          other.TextLocalFilePath == this.TextLocalFilePath &&
          other.RemoteFileID == this.RemoteFileID &&
          other.RemoteTextFileID == this.RemoteTextFileID &&
          other.Checksum == this.Checksum &&
          other.TextChecksum == this.TextChecksum &&
          other.EodFileName == this.EodFileName &&
          other.EodTextFileName == this.EodTextFileName &&
          other.EodLocalFilePath == this.EodLocalFilePath &&
          other.EodTextLocalFilePath == this.EodTextLocalFilePath &&
          other.EodRemoteFileID == this.EodRemoteFileID &&
          other.EodRemoteTextFileID == this.EodRemoteTextFileID &&
          other.EodChecksum == this.EodChecksum &&
          other.EodTextChecksum == this.EodTextChecksum &&
          other.TransactionLogsFolderID == this.TransactionLogsFolderID &&
          other.EodLogsFolderID == this.EodLogsFolderID &&
          other.RecordCount == this.RecordCount &&
          other.Status == this.Status &&
          other.AttemptCount == this.AttemptCount &&
          other.LastAttemptAt == this.LastAttemptAt &&
          other.LastError == this.LastError &&
          other.UploadedAt == this.UploadedAt &&
          other.CreatedAt == this.CreatedAt);
}

class TransactionSyncBatchesCompanion
    extends UpdateCompanion<TransactionSyncBatche> {
  final Value<int> ID;
  final Value<String> BusinessDate;
  final Value<String> FileName;
  final Value<String?> TextFileName;
  final Value<String?> LocalFilePath;
  final Value<String?> TextLocalFilePath;
  final Value<String?> RemoteFileID;
  final Value<String?> RemoteTextFileID;
  final Value<String?> Checksum;
  final Value<String?> TextChecksum;
  final Value<String?> EodFileName;
  final Value<String?> EodTextFileName;
  final Value<String?> EodLocalFilePath;
  final Value<String?> EodTextLocalFilePath;
  final Value<String?> EodRemoteFileID;
  final Value<String?> EodRemoteTextFileID;
  final Value<String?> EodChecksum;
  final Value<String?> EodTextChecksum;
  final Value<String?> TransactionLogsFolderID;
  final Value<String?> EodLogsFolderID;
  final Value<int> RecordCount;
  final Value<String> Status;
  final Value<int> AttemptCount;
  final Value<DateTime?> LastAttemptAt;
  final Value<String?> LastError;
  final Value<DateTime?> UploadedAt;
  final Value<DateTime> CreatedAt;
  const TransactionSyncBatchesCompanion({
    this.ID = const Value.absent(),
    this.BusinessDate = const Value.absent(),
    this.FileName = const Value.absent(),
    this.TextFileName = const Value.absent(),
    this.LocalFilePath = const Value.absent(),
    this.TextLocalFilePath = const Value.absent(),
    this.RemoteFileID = const Value.absent(),
    this.RemoteTextFileID = const Value.absent(),
    this.Checksum = const Value.absent(),
    this.TextChecksum = const Value.absent(),
    this.EodFileName = const Value.absent(),
    this.EodTextFileName = const Value.absent(),
    this.EodLocalFilePath = const Value.absent(),
    this.EodTextLocalFilePath = const Value.absent(),
    this.EodRemoteFileID = const Value.absent(),
    this.EodRemoteTextFileID = const Value.absent(),
    this.EodChecksum = const Value.absent(),
    this.EodTextChecksum = const Value.absent(),
    this.TransactionLogsFolderID = const Value.absent(),
    this.EodLogsFolderID = const Value.absent(),
    this.RecordCount = const Value.absent(),
    this.Status = const Value.absent(),
    this.AttemptCount = const Value.absent(),
    this.LastAttemptAt = const Value.absent(),
    this.LastError = const Value.absent(),
    this.UploadedAt = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  });
  TransactionSyncBatchesCompanion.insert({
    this.ID = const Value.absent(),
    required String BusinessDate,
    required String FileName,
    this.TextFileName = const Value.absent(),
    this.LocalFilePath = const Value.absent(),
    this.TextLocalFilePath = const Value.absent(),
    this.RemoteFileID = const Value.absent(),
    this.RemoteTextFileID = const Value.absent(),
    this.Checksum = const Value.absent(),
    this.TextChecksum = const Value.absent(),
    this.EodFileName = const Value.absent(),
    this.EodTextFileName = const Value.absent(),
    this.EodLocalFilePath = const Value.absent(),
    this.EodTextLocalFilePath = const Value.absent(),
    this.EodRemoteFileID = const Value.absent(),
    this.EodRemoteTextFileID = const Value.absent(),
    this.EodChecksum = const Value.absent(),
    this.EodTextChecksum = const Value.absent(),
    this.TransactionLogsFolderID = const Value.absent(),
    this.EodLogsFolderID = const Value.absent(),
    this.RecordCount = const Value.absent(),
    this.Status = const Value.absent(),
    this.AttemptCount = const Value.absent(),
    this.LastAttemptAt = const Value.absent(),
    this.LastError = const Value.absent(),
    this.UploadedAt = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  }) : BusinessDate = Value(BusinessDate),
       FileName = Value(FileName);
  static Insertable<TransactionSyncBatche> custom({
    Expression<int>? ID,
    Expression<String>? BusinessDate,
    Expression<String>? FileName,
    Expression<String>? TextFileName,
    Expression<String>? LocalFilePath,
    Expression<String>? TextLocalFilePath,
    Expression<String>? RemoteFileID,
    Expression<String>? RemoteTextFileID,
    Expression<String>? Checksum,
    Expression<String>? TextChecksum,
    Expression<String>? EodFileName,
    Expression<String>? EodTextFileName,
    Expression<String>? EodLocalFilePath,
    Expression<String>? EodTextLocalFilePath,
    Expression<String>? EodRemoteFileID,
    Expression<String>? EodRemoteTextFileID,
    Expression<String>? EodChecksum,
    Expression<String>? EodTextChecksum,
    Expression<String>? TransactionLogsFolderID,
    Expression<String>? EodLogsFolderID,
    Expression<int>? RecordCount,
    Expression<String>? Status,
    Expression<int>? AttemptCount,
    Expression<DateTime>? LastAttemptAt,
    Expression<String>? LastError,
    Expression<DateTime>? UploadedAt,
    Expression<DateTime>? CreatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (BusinessDate != null) 'business_date': BusinessDate,
      if (FileName != null) 'file_name': FileName,
      if (TextFileName != null) 'text_file_name': TextFileName,
      if (LocalFilePath != null) 'local_file_path': LocalFilePath,
      if (TextLocalFilePath != null) 'text_local_file_path': TextLocalFilePath,
      if (RemoteFileID != null) 'remote_file_i_d': RemoteFileID,
      if (RemoteTextFileID != null) 'remote_text_file_i_d': RemoteTextFileID,
      if (Checksum != null) 'checksum': Checksum,
      if (TextChecksum != null) 'text_checksum': TextChecksum,
      if (EodFileName != null) 'eod_file_name': EodFileName,
      if (EodTextFileName != null) 'eod_text_file_name': EodTextFileName,
      if (EodLocalFilePath != null) 'eod_local_file_path': EodLocalFilePath,
      if (EodTextLocalFilePath != null)
        'eod_text_local_file_path': EodTextLocalFilePath,
      if (EodRemoteFileID != null) 'eod_remote_file_i_d': EodRemoteFileID,
      if (EodRemoteTextFileID != null)
        'eod_remote_text_file_i_d': EodRemoteTextFileID,
      if (EodChecksum != null) 'eod_checksum': EodChecksum,
      if (EodTextChecksum != null) 'eod_text_checksum': EodTextChecksum,
      if (TransactionLogsFolderID != null)
        'transaction_logs_folder_i_d': TransactionLogsFolderID,
      if (EodLogsFolderID != null) 'eod_logs_folder_i_d': EodLogsFolderID,
      if (RecordCount != null) 'record_count': RecordCount,
      if (Status != null) 'status': Status,
      if (AttemptCount != null) 'attempt_count': AttemptCount,
      if (LastAttemptAt != null) 'last_attempt_at': LastAttemptAt,
      if (LastError != null) 'last_error': LastError,
      if (UploadedAt != null) 'uploaded_at': UploadedAt,
      if (CreatedAt != null) 'created_at': CreatedAt,
    });
  }

  TransactionSyncBatchesCompanion copyWith({
    Value<int>? ID,
    Value<String>? BusinessDate,
    Value<String>? FileName,
    Value<String?>? TextFileName,
    Value<String?>? LocalFilePath,
    Value<String?>? TextLocalFilePath,
    Value<String?>? RemoteFileID,
    Value<String?>? RemoteTextFileID,
    Value<String?>? Checksum,
    Value<String?>? TextChecksum,
    Value<String?>? EodFileName,
    Value<String?>? EodTextFileName,
    Value<String?>? EodLocalFilePath,
    Value<String?>? EodTextLocalFilePath,
    Value<String?>? EodRemoteFileID,
    Value<String?>? EodRemoteTextFileID,
    Value<String?>? EodChecksum,
    Value<String?>? EodTextChecksum,
    Value<String?>? TransactionLogsFolderID,
    Value<String?>? EodLogsFolderID,
    Value<int>? RecordCount,
    Value<String>? Status,
    Value<int>? AttemptCount,
    Value<DateTime?>? LastAttemptAt,
    Value<String?>? LastError,
    Value<DateTime?>? UploadedAt,
    Value<DateTime>? CreatedAt,
  }) {
    return TransactionSyncBatchesCompanion(
      ID: ID ?? this.ID,
      BusinessDate: BusinessDate ?? this.BusinessDate,
      FileName: FileName ?? this.FileName,
      TextFileName: TextFileName ?? this.TextFileName,
      LocalFilePath: LocalFilePath ?? this.LocalFilePath,
      TextLocalFilePath: TextLocalFilePath ?? this.TextLocalFilePath,
      RemoteFileID: RemoteFileID ?? this.RemoteFileID,
      RemoteTextFileID: RemoteTextFileID ?? this.RemoteTextFileID,
      Checksum: Checksum ?? this.Checksum,
      TextChecksum: TextChecksum ?? this.TextChecksum,
      EodFileName: EodFileName ?? this.EodFileName,
      EodTextFileName: EodTextFileName ?? this.EodTextFileName,
      EodLocalFilePath: EodLocalFilePath ?? this.EodLocalFilePath,
      EodTextLocalFilePath: EodTextLocalFilePath ?? this.EodTextLocalFilePath,
      EodRemoteFileID: EodRemoteFileID ?? this.EodRemoteFileID,
      EodRemoteTextFileID: EodRemoteTextFileID ?? this.EodRemoteTextFileID,
      EodChecksum: EodChecksum ?? this.EodChecksum,
      EodTextChecksum: EodTextChecksum ?? this.EodTextChecksum,
      TransactionLogsFolderID:
          TransactionLogsFolderID ?? this.TransactionLogsFolderID,
      EodLogsFolderID: EodLogsFolderID ?? this.EodLogsFolderID,
      RecordCount: RecordCount ?? this.RecordCount,
      Status: Status ?? this.Status,
      AttemptCount: AttemptCount ?? this.AttemptCount,
      LastAttemptAt: LastAttemptAt ?? this.LastAttemptAt,
      LastError: LastError ?? this.LastError,
      UploadedAt: UploadedAt ?? this.UploadedAt,
      CreatedAt: CreatedAt ?? this.CreatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (BusinessDate.present) {
      map['business_date'] = Variable<String>(BusinessDate.value);
    }
    if (FileName.present) {
      map['file_name'] = Variable<String>(FileName.value);
    }
    if (TextFileName.present) {
      map['text_file_name'] = Variable<String>(TextFileName.value);
    }
    if (LocalFilePath.present) {
      map['local_file_path'] = Variable<String>(LocalFilePath.value);
    }
    if (TextLocalFilePath.present) {
      map['text_local_file_path'] = Variable<String>(TextLocalFilePath.value);
    }
    if (RemoteFileID.present) {
      map['remote_file_i_d'] = Variable<String>(RemoteFileID.value);
    }
    if (RemoteTextFileID.present) {
      map['remote_text_file_i_d'] = Variable<String>(RemoteTextFileID.value);
    }
    if (Checksum.present) {
      map['checksum'] = Variable<String>(Checksum.value);
    }
    if (TextChecksum.present) {
      map['text_checksum'] = Variable<String>(TextChecksum.value);
    }
    if (EodFileName.present) {
      map['eod_file_name'] = Variable<String>(EodFileName.value);
    }
    if (EodTextFileName.present) {
      map['eod_text_file_name'] = Variable<String>(EodTextFileName.value);
    }
    if (EodLocalFilePath.present) {
      map['eod_local_file_path'] = Variable<String>(EodLocalFilePath.value);
    }
    if (EodTextLocalFilePath.present) {
      map['eod_text_local_file_path'] = Variable<String>(
        EodTextLocalFilePath.value,
      );
    }
    if (EodRemoteFileID.present) {
      map['eod_remote_file_i_d'] = Variable<String>(EodRemoteFileID.value);
    }
    if (EodRemoteTextFileID.present) {
      map['eod_remote_text_file_i_d'] = Variable<String>(
        EodRemoteTextFileID.value,
      );
    }
    if (EodChecksum.present) {
      map['eod_checksum'] = Variable<String>(EodChecksum.value);
    }
    if (EodTextChecksum.present) {
      map['eod_text_checksum'] = Variable<String>(EodTextChecksum.value);
    }
    if (TransactionLogsFolderID.present) {
      map['transaction_logs_folder_i_d'] = Variable<String>(
        TransactionLogsFolderID.value,
      );
    }
    if (EodLogsFolderID.present) {
      map['eod_logs_folder_i_d'] = Variable<String>(EodLogsFolderID.value);
    }
    if (RecordCount.present) {
      map['record_count'] = Variable<int>(RecordCount.value);
    }
    if (Status.present) {
      map['status'] = Variable<String>(Status.value);
    }
    if (AttemptCount.present) {
      map['attempt_count'] = Variable<int>(AttemptCount.value);
    }
    if (LastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(LastAttemptAt.value);
    }
    if (LastError.present) {
      map['last_error'] = Variable<String>(LastError.value);
    }
    if (UploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(UploadedAt.value);
    }
    if (CreatedAt.present) {
      map['created_at'] = Variable<DateTime>(CreatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSyncBatchesCompanion(')
          ..write('ID: $ID, ')
          ..write('BusinessDate: $BusinessDate, ')
          ..write('FileName: $FileName, ')
          ..write('TextFileName: $TextFileName, ')
          ..write('LocalFilePath: $LocalFilePath, ')
          ..write('TextLocalFilePath: $TextLocalFilePath, ')
          ..write('RemoteFileID: $RemoteFileID, ')
          ..write('RemoteTextFileID: $RemoteTextFileID, ')
          ..write('Checksum: $Checksum, ')
          ..write('TextChecksum: $TextChecksum, ')
          ..write('EodFileName: $EodFileName, ')
          ..write('EodTextFileName: $EodTextFileName, ')
          ..write('EodLocalFilePath: $EodLocalFilePath, ')
          ..write('EodTextLocalFilePath: $EodTextLocalFilePath, ')
          ..write('EodRemoteFileID: $EodRemoteFileID, ')
          ..write('EodRemoteTextFileID: $EodRemoteTextFileID, ')
          ..write('EodChecksum: $EodChecksum, ')
          ..write('EodTextChecksum: $EodTextChecksum, ')
          ..write('TransactionLogsFolderID: $TransactionLogsFolderID, ')
          ..write('EodLogsFolderID: $EodLogsFolderID, ')
          ..write('RecordCount: $RecordCount, ')
          ..write('Status: $Status, ')
          ..write('AttemptCount: $AttemptCount, ')
          ..write('LastAttemptAt: $LastAttemptAt, ')
          ..write('LastError: $LastError, ')
          ..write('UploadedAt: $UploadedAt, ')
          ..write('CreatedAt: $CreatedAt')
          ..write(')'))
        .toString();
  }
}

class $EodSummariesTable extends EodSummaries
    with TableInfo<$EodSummariesTable, EodSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EodSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _BusinessDateMeta = const VerificationMeta(
    'BusinessDate',
  );
  @override
  late final GeneratedColumn<String> BusinessDate = GeneratedColumn<String>(
    'business_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _TransactionCountMeta = const VerificationMeta(
    'TransactionCount',
  );
  @override
  late final GeneratedColumn<int> TransactionCount = GeneratedColumn<int>(
    'transaction_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _SoldUnitCountMeta = const VerificationMeta(
    'SoldUnitCount',
  );
  @override
  late final GeneratedColumn<int> SoldUnitCount = GeneratedColumn<int>(
    'sold_unit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _TotalSalesInCentsMeta = const VerificationMeta(
    'TotalSalesInCents',
  );
  @override
  late final GeneratedColumn<int> TotalSalesInCents = GeneratedColumn<int>(
    'total_sales_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _CreatedAtMeta = const VerificationMeta(
    'CreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> CreatedAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _UpdatedAtMeta = const VerificationMeta(
    'UpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> UpdatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    BusinessDate,
    TransactionCount,
    SoldUnitCount,
    TotalSalesInCents,
    CreatedAt,
    UpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'eod_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<EodSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('business_date')) {
      context.handle(
        _BusinessDateMeta,
        BusinessDate.isAcceptableOrUnknown(
          data['business_date']!,
          _BusinessDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_BusinessDateMeta);
    }
    if (data.containsKey('transaction_count')) {
      context.handle(
        _TransactionCountMeta,
        TransactionCount.isAcceptableOrUnknown(
          data['transaction_count']!,
          _TransactionCountMeta,
        ),
      );
    }
    if (data.containsKey('sold_unit_count')) {
      context.handle(
        _SoldUnitCountMeta,
        SoldUnitCount.isAcceptableOrUnknown(
          data['sold_unit_count']!,
          _SoldUnitCountMeta,
        ),
      );
    }
    if (data.containsKey('total_sales_in_cents')) {
      context.handle(
        _TotalSalesInCentsMeta,
        TotalSalesInCents.isAcceptableOrUnknown(
          data['total_sales_in_cents']!,
          _TotalSalesInCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _CreatedAtMeta,
        CreatedAt.isAcceptableOrUnknown(data['created_at']!, _CreatedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _UpdatedAtMeta,
        UpdatedAt.isAcceptableOrUnknown(data['updated_at']!, _UpdatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  EodSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EodSummary(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      BusinessDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_date'],
      )!,
      TransactionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_count'],
      )!,
      SoldUnitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sold_unit_count'],
      )!,
      TotalSalesInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sales_in_cents'],
      )!,
      CreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      UpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EodSummariesTable createAlias(String alias) {
    return $EodSummariesTable(attachedDatabase, alias);
  }
}

class EodSummary extends DataClass implements Insertable<EodSummary> {
  final int ID;

  /// One stable key per local business date, formatted as YYYY-MM-DD.
  final String BusinessDate;
  final int TransactionCount;
  final int SoldUnitCount;
  final int TotalSalesInCents;
  final DateTime CreatedAt;
  final DateTime UpdatedAt;
  const EodSummary({
    required this.ID,
    required this.BusinessDate,
    required this.TransactionCount,
    required this.SoldUnitCount,
    required this.TotalSalesInCents,
    required this.CreatedAt,
    required this.UpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['business_date'] = Variable<String>(BusinessDate);
    map['transaction_count'] = Variable<int>(TransactionCount);
    map['sold_unit_count'] = Variable<int>(SoldUnitCount);
    map['total_sales_in_cents'] = Variable<int>(TotalSalesInCents);
    map['created_at'] = Variable<DateTime>(CreatedAt);
    map['updated_at'] = Variable<DateTime>(UpdatedAt);
    return map;
  }

  EodSummariesCompanion toCompanion(bool nullToAbsent) {
    return EodSummariesCompanion(
      ID: Value(ID),
      BusinessDate: Value(BusinessDate),
      TransactionCount: Value(TransactionCount),
      SoldUnitCount: Value(SoldUnitCount),
      TotalSalesInCents: Value(TotalSalesInCents),
      CreatedAt: Value(CreatedAt),
      UpdatedAt: Value(UpdatedAt),
    );
  }

  factory EodSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EodSummary(
      ID: serializer.fromJson<int>(json['ID']),
      BusinessDate: serializer.fromJson<String>(json['BusinessDate']),
      TransactionCount: serializer.fromJson<int>(json['TransactionCount']),
      SoldUnitCount: serializer.fromJson<int>(json['SoldUnitCount']),
      TotalSalesInCents: serializer.fromJson<int>(json['TotalSalesInCents']),
      CreatedAt: serializer.fromJson<DateTime>(json['CreatedAt']),
      UpdatedAt: serializer.fromJson<DateTime>(json['UpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'BusinessDate': serializer.toJson<String>(BusinessDate),
      'TransactionCount': serializer.toJson<int>(TransactionCount),
      'SoldUnitCount': serializer.toJson<int>(SoldUnitCount),
      'TotalSalesInCents': serializer.toJson<int>(TotalSalesInCents),
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
      'UpdatedAt': serializer.toJson<DateTime>(UpdatedAt),
    };
  }

  EodSummary copyWith({
    int? ID,
    String? BusinessDate,
    int? TransactionCount,
    int? SoldUnitCount,
    int? TotalSalesInCents,
    DateTime? CreatedAt,
    DateTime? UpdatedAt,
  }) => EodSummary(
    ID: ID ?? this.ID,
    BusinessDate: BusinessDate ?? this.BusinessDate,
    TransactionCount: TransactionCount ?? this.TransactionCount,
    SoldUnitCount: SoldUnitCount ?? this.SoldUnitCount,
    TotalSalesInCents: TotalSalesInCents ?? this.TotalSalesInCents,
    CreatedAt: CreatedAt ?? this.CreatedAt,
    UpdatedAt: UpdatedAt ?? this.UpdatedAt,
  );
  EodSummary copyWithCompanion(EodSummariesCompanion data) {
    return EodSummary(
      ID: data.ID.present ? data.ID.value : this.ID,
      BusinessDate: data.BusinessDate.present
          ? data.BusinessDate.value
          : this.BusinessDate,
      TransactionCount: data.TransactionCount.present
          ? data.TransactionCount.value
          : this.TransactionCount,
      SoldUnitCount: data.SoldUnitCount.present
          ? data.SoldUnitCount.value
          : this.SoldUnitCount,
      TotalSalesInCents: data.TotalSalesInCents.present
          ? data.TotalSalesInCents.value
          : this.TotalSalesInCents,
      CreatedAt: data.CreatedAt.present ? data.CreatedAt.value : this.CreatedAt,
      UpdatedAt: data.UpdatedAt.present ? data.UpdatedAt.value : this.UpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EodSummary(')
          ..write('ID: $ID, ')
          ..write('BusinessDate: $BusinessDate, ')
          ..write('TransactionCount: $TransactionCount, ')
          ..write('SoldUnitCount: $SoldUnitCount, ')
          ..write('TotalSalesInCents: $TotalSalesInCents, ')
          ..write('CreatedAt: $CreatedAt, ')
          ..write('UpdatedAt: $UpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    BusinessDate,
    TransactionCount,
    SoldUnitCount,
    TotalSalesInCents,
    CreatedAt,
    UpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EodSummary &&
          other.ID == this.ID &&
          other.BusinessDate == this.BusinessDate &&
          other.TransactionCount == this.TransactionCount &&
          other.SoldUnitCount == this.SoldUnitCount &&
          other.TotalSalesInCents == this.TotalSalesInCents &&
          other.CreatedAt == this.CreatedAt &&
          other.UpdatedAt == this.UpdatedAt);
}

class EodSummariesCompanion extends UpdateCompanion<EodSummary> {
  final Value<int> ID;
  final Value<String> BusinessDate;
  final Value<int> TransactionCount;
  final Value<int> SoldUnitCount;
  final Value<int> TotalSalesInCents;
  final Value<DateTime> CreatedAt;
  final Value<DateTime> UpdatedAt;
  const EodSummariesCompanion({
    this.ID = const Value.absent(),
    this.BusinessDate = const Value.absent(),
    this.TransactionCount = const Value.absent(),
    this.SoldUnitCount = const Value.absent(),
    this.TotalSalesInCents = const Value.absent(),
    this.CreatedAt = const Value.absent(),
    this.UpdatedAt = const Value.absent(),
  });
  EodSummariesCompanion.insert({
    this.ID = const Value.absent(),
    required String BusinessDate,
    this.TransactionCount = const Value.absent(),
    this.SoldUnitCount = const Value.absent(),
    this.TotalSalesInCents = const Value.absent(),
    this.CreatedAt = const Value.absent(),
    this.UpdatedAt = const Value.absent(),
  }) : BusinessDate = Value(BusinessDate);
  static Insertable<EodSummary> custom({
    Expression<int>? ID,
    Expression<String>? BusinessDate,
    Expression<int>? TransactionCount,
    Expression<int>? SoldUnitCount,
    Expression<int>? TotalSalesInCents,
    Expression<DateTime>? CreatedAt,
    Expression<DateTime>? UpdatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (BusinessDate != null) 'business_date': BusinessDate,
      if (TransactionCount != null) 'transaction_count': TransactionCount,
      if (SoldUnitCount != null) 'sold_unit_count': SoldUnitCount,
      if (TotalSalesInCents != null) 'total_sales_in_cents': TotalSalesInCents,
      if (CreatedAt != null) 'created_at': CreatedAt,
      if (UpdatedAt != null) 'updated_at': UpdatedAt,
    });
  }

  EodSummariesCompanion copyWith({
    Value<int>? ID,
    Value<String>? BusinessDate,
    Value<int>? TransactionCount,
    Value<int>? SoldUnitCount,
    Value<int>? TotalSalesInCents,
    Value<DateTime>? CreatedAt,
    Value<DateTime>? UpdatedAt,
  }) {
    return EodSummariesCompanion(
      ID: ID ?? this.ID,
      BusinessDate: BusinessDate ?? this.BusinessDate,
      TransactionCount: TransactionCount ?? this.TransactionCount,
      SoldUnitCount: SoldUnitCount ?? this.SoldUnitCount,
      TotalSalesInCents: TotalSalesInCents ?? this.TotalSalesInCents,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (BusinessDate.present) {
      map['business_date'] = Variable<String>(BusinessDate.value);
    }
    if (TransactionCount.present) {
      map['transaction_count'] = Variable<int>(TransactionCount.value);
    }
    if (SoldUnitCount.present) {
      map['sold_unit_count'] = Variable<int>(SoldUnitCount.value);
    }
    if (TotalSalesInCents.present) {
      map['total_sales_in_cents'] = Variable<int>(TotalSalesInCents.value);
    }
    if (CreatedAt.present) {
      map['created_at'] = Variable<DateTime>(CreatedAt.value);
    }
    if (UpdatedAt.present) {
      map['updated_at'] = Variable<DateTime>(UpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EodSummariesCompanion(')
          ..write('ID: $ID, ')
          ..write('BusinessDate: $BusinessDate, ')
          ..write('TransactionCount: $TransactionCount, ')
          ..write('SoldUnitCount: $SoldUnitCount, ')
          ..write('TotalSalesInCents: $TotalSalesInCents, ')
          ..write('CreatedAt: $CreatedAt, ')
          ..write('UpdatedAt: $UpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $EodSummaryItemsTable extends EodSummaryItems
    with TableInfo<$EodSummaryItemsTable, EodSummaryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EodSummaryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _EodSummaryIDMeta = const VerificationMeta(
    'EodSummaryID',
  );
  @override
  late final GeneratedColumn<int> EodSummaryID = GeneratedColumn<int>(
    'eod_summary_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES eod_summaries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ProductVariantIDMeta = const VerificationMeta(
    'ProductVariantID',
  );
  @override
  late final GeneratedColumn<int> ProductVariantID = GeneratedColumn<int>(
    'product_variant_i_d',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES product_variants (id)',
    ),
  );
  static const VerificationMeta _ProductNameSnapshotMeta =
      const VerificationMeta('ProductNameSnapshot');
  @override
  late final GeneratedColumn<String> ProductNameSnapshot =
      GeneratedColumn<String>(
        'product_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _UnitSnapshotMeta = const VerificationMeta(
    'UnitSnapshot',
  );
  @override
  late final GeneratedColumn<String> UnitSnapshot = GeneratedColumn<String>(
    'unit_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _UnitPriceInCentsMeta = const VerificationMeta(
    'UnitPriceInCents',
  );
  @override
  late final GeneratedColumn<int> UnitPriceInCents = GeneratedColumn<int>(
    'unit_price_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _SoldUnitsMeta = const VerificationMeta(
    'SoldUnits',
  );
  @override
  late final GeneratedColumn<int> SoldUnits = GeneratedColumn<int>(
    'sold_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _SoldTotalInCentsMeta = const VerificationMeta(
    'SoldTotalInCents',
  );
  @override
  late final GeneratedColumn<int> SoldTotalInCents = GeneratedColumn<int>(
    'sold_total_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    EodSummaryID,
    ProductVariantID,
    ProductNameSnapshot,
    UnitSnapshot,
    UnitPriceInCents,
    SoldUnits,
    SoldTotalInCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'eod_summary_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<EodSummaryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('eod_summary_i_d')) {
      context.handle(
        _EodSummaryIDMeta,
        EodSummaryID.isAcceptableOrUnknown(
          data['eod_summary_i_d']!,
          _EodSummaryIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_EodSummaryIDMeta);
    }
    if (data.containsKey('product_variant_i_d')) {
      context.handle(
        _ProductVariantIDMeta,
        ProductVariantID.isAcceptableOrUnknown(
          data['product_variant_i_d']!,
          _ProductVariantIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ProductVariantIDMeta);
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
        _ProductNameSnapshotMeta,
        ProductNameSnapshot.isAcceptableOrUnknown(
          data['product_name_snapshot']!,
          _ProductNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ProductNameSnapshotMeta);
    }
    if (data.containsKey('unit_snapshot')) {
      context.handle(
        _UnitSnapshotMeta,
        UnitSnapshot.isAcceptableOrUnknown(
          data['unit_snapshot']!,
          _UnitSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_UnitSnapshotMeta);
    }
    if (data.containsKey('unit_price_in_cents')) {
      context.handle(
        _UnitPriceInCentsMeta,
        UnitPriceInCents.isAcceptableOrUnknown(
          data['unit_price_in_cents']!,
          _UnitPriceInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_UnitPriceInCentsMeta);
    }
    if (data.containsKey('sold_units')) {
      context.handle(
        _SoldUnitsMeta,
        SoldUnits.isAcceptableOrUnknown(data['sold_units']!, _SoldUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_SoldUnitsMeta);
    }
    if (data.containsKey('sold_total_in_cents')) {
      context.handle(
        _SoldTotalInCentsMeta,
        SoldTotalInCents.isAcceptableOrUnknown(
          data['sold_total_in_cents']!,
          _SoldTotalInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_SoldTotalInCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  EodSummaryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EodSummaryItem(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      EodSummaryID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eod_summary_i_d'],
      )!,
      ProductVariantID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_variant_i_d'],
      )!,
      ProductNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_snapshot'],
      )!,
      UnitSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_snapshot'],
      )!,
      UnitPriceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_in_cents'],
      )!,
      SoldUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sold_units'],
      )!,
      SoldTotalInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sold_total_in_cents'],
      )!,
    );
  }

  @override
  $EodSummaryItemsTable createAlias(String alias) {
    return $EodSummaryItemsTable(attachedDatabase, alias);
  }
}

class EodSummaryItem extends DataClass implements Insertable<EodSummaryItem> {
  final int ID;
  final int EodSummaryID;
  final int ProductVariantID;
  final String ProductNameSnapshot;
  final String UnitSnapshot;
  final int UnitPriceInCents;
  final int SoldUnits;
  final int SoldTotalInCents;
  const EodSummaryItem({
    required this.ID,
    required this.EodSummaryID,
    required this.ProductVariantID,
    required this.ProductNameSnapshot,
    required this.UnitSnapshot,
    required this.UnitPriceInCents,
    required this.SoldUnits,
    required this.SoldTotalInCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['eod_summary_i_d'] = Variable<int>(EodSummaryID);
    map['product_variant_i_d'] = Variable<int>(ProductVariantID);
    map['product_name_snapshot'] = Variable<String>(ProductNameSnapshot);
    map['unit_snapshot'] = Variable<String>(UnitSnapshot);
    map['unit_price_in_cents'] = Variable<int>(UnitPriceInCents);
    map['sold_units'] = Variable<int>(SoldUnits);
    map['sold_total_in_cents'] = Variable<int>(SoldTotalInCents);
    return map;
  }

  EodSummaryItemsCompanion toCompanion(bool nullToAbsent) {
    return EodSummaryItemsCompanion(
      ID: Value(ID),
      EodSummaryID: Value(EodSummaryID),
      ProductVariantID: Value(ProductVariantID),
      ProductNameSnapshot: Value(ProductNameSnapshot),
      UnitSnapshot: Value(UnitSnapshot),
      UnitPriceInCents: Value(UnitPriceInCents),
      SoldUnits: Value(SoldUnits),
      SoldTotalInCents: Value(SoldTotalInCents),
    );
  }

  factory EodSummaryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EodSummaryItem(
      ID: serializer.fromJson<int>(json['ID']),
      EodSummaryID: serializer.fromJson<int>(json['EodSummaryID']),
      ProductVariantID: serializer.fromJson<int>(json['ProductVariantID']),
      ProductNameSnapshot: serializer.fromJson<String>(
        json['ProductNameSnapshot'],
      ),
      UnitSnapshot: serializer.fromJson<String>(json['UnitSnapshot']),
      UnitPriceInCents: serializer.fromJson<int>(json['UnitPriceInCents']),
      SoldUnits: serializer.fromJson<int>(json['SoldUnits']),
      SoldTotalInCents: serializer.fromJson<int>(json['SoldTotalInCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'EodSummaryID': serializer.toJson<int>(EodSummaryID),
      'ProductVariantID': serializer.toJson<int>(ProductVariantID),
      'ProductNameSnapshot': serializer.toJson<String>(ProductNameSnapshot),
      'UnitSnapshot': serializer.toJson<String>(UnitSnapshot),
      'UnitPriceInCents': serializer.toJson<int>(UnitPriceInCents),
      'SoldUnits': serializer.toJson<int>(SoldUnits),
      'SoldTotalInCents': serializer.toJson<int>(SoldTotalInCents),
    };
  }

  EodSummaryItem copyWith({
    int? ID,
    int? EodSummaryID,
    int? ProductVariantID,
    String? ProductNameSnapshot,
    String? UnitSnapshot,
    int? UnitPriceInCents,
    int? SoldUnits,
    int? SoldTotalInCents,
  }) => EodSummaryItem(
    ID: ID ?? this.ID,
    EodSummaryID: EodSummaryID ?? this.EodSummaryID,
    ProductVariantID: ProductVariantID ?? this.ProductVariantID,
    ProductNameSnapshot: ProductNameSnapshot ?? this.ProductNameSnapshot,
    UnitSnapshot: UnitSnapshot ?? this.UnitSnapshot,
    UnitPriceInCents: UnitPriceInCents ?? this.UnitPriceInCents,
    SoldUnits: SoldUnits ?? this.SoldUnits,
    SoldTotalInCents: SoldTotalInCents ?? this.SoldTotalInCents,
  );
  EodSummaryItem copyWithCompanion(EodSummaryItemsCompanion data) {
    return EodSummaryItem(
      ID: data.ID.present ? data.ID.value : this.ID,
      EodSummaryID: data.EodSummaryID.present
          ? data.EodSummaryID.value
          : this.EodSummaryID,
      ProductVariantID: data.ProductVariantID.present
          ? data.ProductVariantID.value
          : this.ProductVariantID,
      ProductNameSnapshot: data.ProductNameSnapshot.present
          ? data.ProductNameSnapshot.value
          : this.ProductNameSnapshot,
      UnitSnapshot: data.UnitSnapshot.present
          ? data.UnitSnapshot.value
          : this.UnitSnapshot,
      UnitPriceInCents: data.UnitPriceInCents.present
          ? data.UnitPriceInCents.value
          : this.UnitPriceInCents,
      SoldUnits: data.SoldUnits.present ? data.SoldUnits.value : this.SoldUnits,
      SoldTotalInCents: data.SoldTotalInCents.present
          ? data.SoldTotalInCents.value
          : this.SoldTotalInCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EodSummaryItem(')
          ..write('ID: $ID, ')
          ..write('EodSummaryID: $EodSummaryID, ')
          ..write('ProductVariantID: $ProductVariantID, ')
          ..write('ProductNameSnapshot: $ProductNameSnapshot, ')
          ..write('UnitSnapshot: $UnitSnapshot, ')
          ..write('UnitPriceInCents: $UnitPriceInCents, ')
          ..write('SoldUnits: $SoldUnits, ')
          ..write('SoldTotalInCents: $SoldTotalInCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    EodSummaryID,
    ProductVariantID,
    ProductNameSnapshot,
    UnitSnapshot,
    UnitPriceInCents,
    SoldUnits,
    SoldTotalInCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EodSummaryItem &&
          other.ID == this.ID &&
          other.EodSummaryID == this.EodSummaryID &&
          other.ProductVariantID == this.ProductVariantID &&
          other.ProductNameSnapshot == this.ProductNameSnapshot &&
          other.UnitSnapshot == this.UnitSnapshot &&
          other.UnitPriceInCents == this.UnitPriceInCents &&
          other.SoldUnits == this.SoldUnits &&
          other.SoldTotalInCents == this.SoldTotalInCents);
}

class EodSummaryItemsCompanion extends UpdateCompanion<EodSummaryItem> {
  final Value<int> ID;
  final Value<int> EodSummaryID;
  final Value<int> ProductVariantID;
  final Value<String> ProductNameSnapshot;
  final Value<String> UnitSnapshot;
  final Value<int> UnitPriceInCents;
  final Value<int> SoldUnits;
  final Value<int> SoldTotalInCents;
  const EodSummaryItemsCompanion({
    this.ID = const Value.absent(),
    this.EodSummaryID = const Value.absent(),
    this.ProductVariantID = const Value.absent(),
    this.ProductNameSnapshot = const Value.absent(),
    this.UnitSnapshot = const Value.absent(),
    this.UnitPriceInCents = const Value.absent(),
    this.SoldUnits = const Value.absent(),
    this.SoldTotalInCents = const Value.absent(),
  });
  EodSummaryItemsCompanion.insert({
    this.ID = const Value.absent(),
    required int EodSummaryID,
    required int ProductVariantID,
    required String ProductNameSnapshot,
    required String UnitSnapshot,
    required int UnitPriceInCents,
    required int SoldUnits,
    required int SoldTotalInCents,
  }) : EodSummaryID = Value(EodSummaryID),
       ProductVariantID = Value(ProductVariantID),
       ProductNameSnapshot = Value(ProductNameSnapshot),
       UnitSnapshot = Value(UnitSnapshot),
       UnitPriceInCents = Value(UnitPriceInCents),
       SoldUnits = Value(SoldUnits),
       SoldTotalInCents = Value(SoldTotalInCents);
  static Insertable<EodSummaryItem> custom({
    Expression<int>? ID,
    Expression<int>? EodSummaryID,
    Expression<int>? ProductVariantID,
    Expression<String>? ProductNameSnapshot,
    Expression<String>? UnitSnapshot,
    Expression<int>? UnitPriceInCents,
    Expression<int>? SoldUnits,
    Expression<int>? SoldTotalInCents,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (EodSummaryID != null) 'eod_summary_i_d': EodSummaryID,
      if (ProductVariantID != null) 'product_variant_i_d': ProductVariantID,
      if (ProductNameSnapshot != null)
        'product_name_snapshot': ProductNameSnapshot,
      if (UnitSnapshot != null) 'unit_snapshot': UnitSnapshot,
      if (UnitPriceInCents != null) 'unit_price_in_cents': UnitPriceInCents,
      if (SoldUnits != null) 'sold_units': SoldUnits,
      if (SoldTotalInCents != null) 'sold_total_in_cents': SoldTotalInCents,
    });
  }

  EodSummaryItemsCompanion copyWith({
    Value<int>? ID,
    Value<int>? EodSummaryID,
    Value<int>? ProductVariantID,
    Value<String>? ProductNameSnapshot,
    Value<String>? UnitSnapshot,
    Value<int>? UnitPriceInCents,
    Value<int>? SoldUnits,
    Value<int>? SoldTotalInCents,
  }) {
    return EodSummaryItemsCompanion(
      ID: ID ?? this.ID,
      EodSummaryID: EodSummaryID ?? this.EodSummaryID,
      ProductVariantID: ProductVariantID ?? this.ProductVariantID,
      ProductNameSnapshot: ProductNameSnapshot ?? this.ProductNameSnapshot,
      UnitSnapshot: UnitSnapshot ?? this.UnitSnapshot,
      UnitPriceInCents: UnitPriceInCents ?? this.UnitPriceInCents,
      SoldUnits: SoldUnits ?? this.SoldUnits,
      SoldTotalInCents: SoldTotalInCents ?? this.SoldTotalInCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (EodSummaryID.present) {
      map['eod_summary_i_d'] = Variable<int>(EodSummaryID.value);
    }
    if (ProductVariantID.present) {
      map['product_variant_i_d'] = Variable<int>(ProductVariantID.value);
    }
    if (ProductNameSnapshot.present) {
      map['product_name_snapshot'] = Variable<String>(
        ProductNameSnapshot.value,
      );
    }
    if (UnitSnapshot.present) {
      map['unit_snapshot'] = Variable<String>(UnitSnapshot.value);
    }
    if (UnitPriceInCents.present) {
      map['unit_price_in_cents'] = Variable<int>(UnitPriceInCents.value);
    }
    if (SoldUnits.present) {
      map['sold_units'] = Variable<int>(SoldUnits.value);
    }
    if (SoldTotalInCents.present) {
      map['sold_total_in_cents'] = Variable<int>(SoldTotalInCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EodSummaryItemsCompanion(')
          ..write('ID: $ID, ')
          ..write('EodSummaryID: $EodSummaryID, ')
          ..write('ProductVariantID: $ProductVariantID, ')
          ..write('ProductNameSnapshot: $ProductNameSnapshot, ')
          ..write('UnitSnapshot: $UnitSnapshot, ')
          ..write('UnitPriceInCents: $UnitPriceInCents, ')
          ..write('SoldUnits: $SoldUnits, ')
          ..write('SoldTotalInCents: $SoldTotalInCents')
          ..write(')'))
        .toString();
  }
}

class $StoreSettingsTable extends StoreSettings
    with TableInfo<$StoreSettingsTable, StoreSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _StoreNameMeta = const VerificationMeta(
    'StoreName',
  );
  @override
  late final GeneratedColumn<String> StoreName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _AddressMeta = const VerificationMeta(
    'Address',
  );
  @override
  late final GeneratedColumn<String> Address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ContactNumberMeta = const VerificationMeta(
    'ContactNumber',
  );
  @override
  late final GeneratedColumn<String> ContactNumber = GeneratedColumn<String>(
    'contact_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ReceiptFooterMeta = const VerificationMeta(
    'ReceiptFooter',
  );
  @override
  late final GeneratedColumn<String> ReceiptFooter = GeneratedColumn<String>(
    'receipt_footer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    StoreName,
    Address,
    ContactNumber,
    ReceiptFooter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _StoreNameMeta,
        StoreName.isAcceptableOrUnknown(data['store_name']!, _StoreNameMeta),
      );
    } else if (isInserting) {
      context.missing(_StoreNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _AddressMeta,
        Address.isAcceptableOrUnknown(data['address']!, _AddressMeta),
      );
    } else if (isInserting) {
      context.missing(_AddressMeta);
    }
    if (data.containsKey('contact_number')) {
      context.handle(
        _ContactNumberMeta,
        ContactNumber.isAcceptableOrUnknown(
          data['contact_number']!,
          _ContactNumberMeta,
        ),
      );
    }
    if (data.containsKey('receipt_footer')) {
      context.handle(
        _ReceiptFooterMeta,
        ReceiptFooter.isAcceptableOrUnknown(
          data['receipt_footer']!,
          _ReceiptFooterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  StoreSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreSetting(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      StoreName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      )!,
      Address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      ContactNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_number'],
      ),
      ReceiptFooter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_footer'],
      ),
    );
  }

  @override
  $StoreSettingsTable createAlias(String alias) {
    return $StoreSettingsTable(attachedDatabase, alias);
  }
}

class StoreSetting extends DataClass implements Insertable<StoreSetting> {
  final int ID;
  final String StoreName;
  final String Address;
  final String? ContactNumber;
  final String? ReceiptFooter;
  const StoreSetting({
    required this.ID,
    required this.StoreName,
    required this.Address,
    this.ContactNumber,
    this.ReceiptFooter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    map['store_name'] = Variable<String>(StoreName);
    map['address'] = Variable<String>(Address);
    if (!nullToAbsent || ContactNumber != null) {
      map['contact_number'] = Variable<String>(ContactNumber);
    }
    if (!nullToAbsent || ReceiptFooter != null) {
      map['receipt_footer'] = Variable<String>(ReceiptFooter);
    }
    return map;
  }

  StoreSettingsCompanion toCompanion(bool nullToAbsent) {
    return StoreSettingsCompanion(
      ID: Value(ID),
      StoreName: Value(StoreName),
      Address: Value(Address),
      ContactNumber: ContactNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(ContactNumber),
      ReceiptFooter: ReceiptFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(ReceiptFooter),
    );
  }

  factory StoreSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreSetting(
      ID: serializer.fromJson<int>(json['ID']),
      StoreName: serializer.fromJson<String>(json['StoreName']),
      Address: serializer.fromJson<String>(json['Address']),
      ContactNumber: serializer.fromJson<String?>(json['ContactNumber']),
      ReceiptFooter: serializer.fromJson<String?>(json['ReceiptFooter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'StoreName': serializer.toJson<String>(StoreName),
      'Address': serializer.toJson<String>(Address),
      'ContactNumber': serializer.toJson<String?>(ContactNumber),
      'ReceiptFooter': serializer.toJson<String?>(ReceiptFooter),
    };
  }

  StoreSetting copyWith({
    int? ID,
    String? StoreName,
    String? Address,
    Value<String?> ContactNumber = const Value.absent(),
    Value<String?> ReceiptFooter = const Value.absent(),
  }) => StoreSetting(
    ID: ID ?? this.ID,
    StoreName: StoreName ?? this.StoreName,
    Address: Address ?? this.Address,
    ContactNumber: ContactNumber.present
        ? ContactNumber.value
        : this.ContactNumber,
    ReceiptFooter: ReceiptFooter.present
        ? ReceiptFooter.value
        : this.ReceiptFooter,
  );
  StoreSetting copyWithCompanion(StoreSettingsCompanion data) {
    return StoreSetting(
      ID: data.ID.present ? data.ID.value : this.ID,
      StoreName: data.StoreName.present ? data.StoreName.value : this.StoreName,
      Address: data.Address.present ? data.Address.value : this.Address,
      ContactNumber: data.ContactNumber.present
          ? data.ContactNumber.value
          : this.ContactNumber,
      ReceiptFooter: data.ReceiptFooter.present
          ? data.ReceiptFooter.value
          : this.ReceiptFooter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreSetting(')
          ..write('ID: $ID, ')
          ..write('StoreName: $StoreName, ')
          ..write('Address: $Address, ')
          ..write('ContactNumber: $ContactNumber, ')
          ..write('ReceiptFooter: $ReceiptFooter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(ID, StoreName, Address, ContactNumber, ReceiptFooter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreSetting &&
          other.ID == this.ID &&
          other.StoreName == this.StoreName &&
          other.Address == this.Address &&
          other.ContactNumber == this.ContactNumber &&
          other.ReceiptFooter == this.ReceiptFooter);
}

class StoreSettingsCompanion extends UpdateCompanion<StoreSetting> {
  final Value<int> ID;
  final Value<String> StoreName;
  final Value<String> Address;
  final Value<String?> ContactNumber;
  final Value<String?> ReceiptFooter;
  const StoreSettingsCompanion({
    this.ID = const Value.absent(),
    this.StoreName = const Value.absent(),
    this.Address = const Value.absent(),
    this.ContactNumber = const Value.absent(),
    this.ReceiptFooter = const Value.absent(),
  });
  StoreSettingsCompanion.insert({
    this.ID = const Value.absent(),
    required String StoreName,
    required String Address,
    this.ContactNumber = const Value.absent(),
    this.ReceiptFooter = const Value.absent(),
  }) : StoreName = Value(StoreName),
       Address = Value(Address);
  static Insertable<StoreSetting> custom({
    Expression<int>? ID,
    Expression<String>? StoreName,
    Expression<String>? Address,
    Expression<String>? ContactNumber,
    Expression<String>? ReceiptFooter,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (StoreName != null) 'store_name': StoreName,
      if (Address != null) 'address': Address,
      if (ContactNumber != null) 'contact_number': ContactNumber,
      if (ReceiptFooter != null) 'receipt_footer': ReceiptFooter,
    });
  }

  StoreSettingsCompanion copyWith({
    Value<int>? ID,
    Value<String>? StoreName,
    Value<String>? Address,
    Value<String?>? ContactNumber,
    Value<String?>? ReceiptFooter,
  }) {
    return StoreSettingsCompanion(
      ID: ID ?? this.ID,
      StoreName: StoreName ?? this.StoreName,
      Address: Address ?? this.Address,
      ContactNumber: ContactNumber ?? this.ContactNumber,
      ReceiptFooter: ReceiptFooter ?? this.ReceiptFooter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (StoreName.present) {
      map['store_name'] = Variable<String>(StoreName.value);
    }
    if (Address.present) {
      map['address'] = Variable<String>(Address.value);
    }
    if (ContactNumber.present) {
      map['contact_number'] = Variable<String>(ContactNumber.value);
    }
    if (ReceiptFooter.present) {
      map['receipt_footer'] = Variable<String>(ReceiptFooter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreSettingsCompanion(')
          ..write('ID: $ID, ')
          ..write('StoreName: $StoreName, ')
          ..write('Address: $Address, ')
          ..write('ContactNumber: $ContactNumber, ')
          ..write('ReceiptFooter: $ReceiptFooter')
          ..write(')'))
        .toString();
  }
}

class $CloudSyncSettingsTable extends CloudSyncSettings
    with TableInfo<$CloudSyncSettingsTable, CloudSyncSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CloudSyncSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _IDMeta = const VerificationMeta('ID');
  @override
  late final GeneratedColumn<int> ID = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _RootFolderIDMeta = const VerificationMeta(
    'RootFolderID',
  );
  @override
  late final GeneratedColumn<String> RootFolderID = GeneratedColumn<String>(
    'root_folder_i_d',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _TransactionLogsFolderIDMeta =
      const VerificationMeta('TransactionLogsFolderID');
  @override
  late final GeneratedColumn<String> TransactionLogsFolderID =
      GeneratedColumn<String>(
        'transaction_logs_folder_i_d',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _EodLogsFolderIDMeta = const VerificationMeta(
    'EodLogsFolderID',
  );
  @override
  late final GeneratedColumn<String> EodLogsFolderID = GeneratedColumn<String>(
    'eod_logs_folder_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _InstallationIDMeta = const VerificationMeta(
    'InstallationID',
  );
  @override
  late final GeneratedColumn<String> InstallationID = GeneratedColumn<String>(
    'installation_i_d',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _FolderOwnerEmailMeta = const VerificationMeta(
    'FolderOwnerEmail',
  );
  @override
  late final GeneratedColumn<String> FolderOwnerEmail = GeneratedColumn<String>(
    'folder_owner_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ProvisioningStatusMeta =
      const VerificationMeta('ProvisioningStatus');
  @override
  late final GeneratedColumn<String> ProvisioningStatus =
      GeneratedColumn<String>(
        'provisioning_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unprovisioned'),
      );
  static const VerificationMeta _IsAppOwnedMeta = const VerificationMeta(
    'IsAppOwned',
  );
  @override
  late final GeneratedColumn<bool> IsAppOwned = GeneratedColumn<bool>(
    'is_app_owned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_app_owned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _LastValidatedAtMeta = const VerificationMeta(
    'LastValidatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> LastValidatedAt =
      GeneratedColumn<DateTime>(
        'last_validated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _UpdatedAtMeta = const VerificationMeta(
    'UpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> UpdatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ID,
    RootFolderID,
    TransactionLogsFolderID,
    EodLogsFolderID,
    InstallationID,
    FolderOwnerEmail,
    ProvisioningStatus,
    IsAppOwned,
    LastValidatedAt,
    UpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cloud_sync_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CloudSyncSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_IDMeta, ID.isAcceptableOrUnknown(data['id']!, _IDMeta));
    }
    if (data.containsKey('root_folder_i_d')) {
      context.handle(
        _RootFolderIDMeta,
        RootFolderID.isAcceptableOrUnknown(
          data['root_folder_i_d']!,
          _RootFolderIDMeta,
        ),
      );
    }
    if (data.containsKey('transaction_logs_folder_i_d')) {
      context.handle(
        _TransactionLogsFolderIDMeta,
        TransactionLogsFolderID.isAcceptableOrUnknown(
          data['transaction_logs_folder_i_d']!,
          _TransactionLogsFolderIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_TransactionLogsFolderIDMeta);
    }
    if (data.containsKey('eod_logs_folder_i_d')) {
      context.handle(
        _EodLogsFolderIDMeta,
        EodLogsFolderID.isAcceptableOrUnknown(
          data['eod_logs_folder_i_d']!,
          _EodLogsFolderIDMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_EodLogsFolderIDMeta);
    }
    if (data.containsKey('installation_i_d')) {
      context.handle(
        _InstallationIDMeta,
        InstallationID.isAcceptableOrUnknown(
          data['installation_i_d']!,
          _InstallationIDMeta,
        ),
      );
    }
    if (data.containsKey('folder_owner_email')) {
      context.handle(
        _FolderOwnerEmailMeta,
        FolderOwnerEmail.isAcceptableOrUnknown(
          data['folder_owner_email']!,
          _FolderOwnerEmailMeta,
        ),
      );
    }
    if (data.containsKey('provisioning_status')) {
      context.handle(
        _ProvisioningStatusMeta,
        ProvisioningStatus.isAcceptableOrUnknown(
          data['provisioning_status']!,
          _ProvisioningStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_app_owned')) {
      context.handle(
        _IsAppOwnedMeta,
        IsAppOwned.isAcceptableOrUnknown(
          data['is_app_owned']!,
          _IsAppOwnedMeta,
        ),
      );
    }
    if (data.containsKey('last_validated_at')) {
      context.handle(
        _LastValidatedAtMeta,
        LastValidatedAt.isAcceptableOrUnknown(
          data['last_validated_at']!,
          _LastValidatedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _UpdatedAtMeta,
        UpdatedAt.isAcceptableOrUnknown(data['updated_at']!, _UpdatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ID};
  @override
  CloudSyncSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CloudSyncSetting(
      ID: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      RootFolderID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_folder_i_d'],
      ),
      TransactionLogsFolderID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_logs_folder_i_d'],
      )!,
      EodLogsFolderID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eod_logs_folder_i_d'],
      )!,
      InstallationID: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installation_i_d'],
      )!,
      FolderOwnerEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_owner_email'],
      ),
      ProvisioningStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provisioning_status'],
      )!,
      IsAppOwned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_app_owned'],
      )!,
      LastValidatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_validated_at'],
      ),
      UpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CloudSyncSettingsTable createAlias(String alias) {
    return $CloudSyncSettingsTable(attachedDatabase, alias);
  }
}

class CloudSyncSetting extends DataClass
    implements Insertable<CloudSyncSetting> {
  final int ID;
  final String? RootFolderID;
  final String TransactionLogsFolderID;
  final String EodLogsFolderID;
  final String InstallationID;
  final String? FolderOwnerEmail;
  final String ProvisioningStatus;
  final bool IsAppOwned;
  final DateTime? LastValidatedAt;
  final DateTime UpdatedAt;
  const CloudSyncSetting({
    required this.ID,
    this.RootFolderID,
    required this.TransactionLogsFolderID,
    required this.EodLogsFolderID,
    required this.InstallationID,
    this.FolderOwnerEmail,
    required this.ProvisioningStatus,
    required this.IsAppOwned,
    this.LastValidatedAt,
    required this.UpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(ID);
    if (!nullToAbsent || RootFolderID != null) {
      map['root_folder_i_d'] = Variable<String>(RootFolderID);
    }
    map['transaction_logs_folder_i_d'] = Variable<String>(
      TransactionLogsFolderID,
    );
    map['eod_logs_folder_i_d'] = Variable<String>(EodLogsFolderID);
    map['installation_i_d'] = Variable<String>(InstallationID);
    if (!nullToAbsent || FolderOwnerEmail != null) {
      map['folder_owner_email'] = Variable<String>(FolderOwnerEmail);
    }
    map['provisioning_status'] = Variable<String>(ProvisioningStatus);
    map['is_app_owned'] = Variable<bool>(IsAppOwned);
    if (!nullToAbsent || LastValidatedAt != null) {
      map['last_validated_at'] = Variable<DateTime>(LastValidatedAt);
    }
    map['updated_at'] = Variable<DateTime>(UpdatedAt);
    return map;
  }

  CloudSyncSettingsCompanion toCompanion(bool nullToAbsent) {
    return CloudSyncSettingsCompanion(
      ID: Value(ID),
      RootFolderID: RootFolderID == null && nullToAbsent
          ? const Value.absent()
          : Value(RootFolderID),
      TransactionLogsFolderID: Value(TransactionLogsFolderID),
      EodLogsFolderID: Value(EodLogsFolderID),
      InstallationID: Value(InstallationID),
      FolderOwnerEmail: FolderOwnerEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(FolderOwnerEmail),
      ProvisioningStatus: Value(ProvisioningStatus),
      IsAppOwned: Value(IsAppOwned),
      LastValidatedAt: LastValidatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(LastValidatedAt),
      UpdatedAt: Value(UpdatedAt),
    );
  }

  factory CloudSyncSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CloudSyncSetting(
      ID: serializer.fromJson<int>(json['ID']),
      RootFolderID: serializer.fromJson<String?>(json['RootFolderID']),
      TransactionLogsFolderID: serializer.fromJson<String>(
        json['TransactionLogsFolderID'],
      ),
      EodLogsFolderID: serializer.fromJson<String>(json['EodLogsFolderID']),
      InstallationID: serializer.fromJson<String>(json['InstallationID']),
      FolderOwnerEmail: serializer.fromJson<String?>(json['FolderOwnerEmail']),
      ProvisioningStatus: serializer.fromJson<String>(
        json['ProvisioningStatus'],
      ),
      IsAppOwned: serializer.fromJson<bool>(json['IsAppOwned']),
      LastValidatedAt: serializer.fromJson<DateTime?>(json['LastValidatedAt']),
      UpdatedAt: serializer.fromJson<DateTime>(json['UpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ID': serializer.toJson<int>(ID),
      'RootFolderID': serializer.toJson<String?>(RootFolderID),
      'TransactionLogsFolderID': serializer.toJson<String>(
        TransactionLogsFolderID,
      ),
      'EodLogsFolderID': serializer.toJson<String>(EodLogsFolderID),
      'InstallationID': serializer.toJson<String>(InstallationID),
      'FolderOwnerEmail': serializer.toJson<String?>(FolderOwnerEmail),
      'ProvisioningStatus': serializer.toJson<String>(ProvisioningStatus),
      'IsAppOwned': serializer.toJson<bool>(IsAppOwned),
      'LastValidatedAt': serializer.toJson<DateTime?>(LastValidatedAt),
      'UpdatedAt': serializer.toJson<DateTime>(UpdatedAt),
    };
  }

  CloudSyncSetting copyWith({
    int? ID,
    Value<String?> RootFolderID = const Value.absent(),
    String? TransactionLogsFolderID,
    String? EodLogsFolderID,
    String? InstallationID,
    Value<String?> FolderOwnerEmail = const Value.absent(),
    String? ProvisioningStatus,
    bool? IsAppOwned,
    Value<DateTime?> LastValidatedAt = const Value.absent(),
    DateTime? UpdatedAt,
  }) => CloudSyncSetting(
    ID: ID ?? this.ID,
    RootFolderID: RootFolderID.present ? RootFolderID.value : this.RootFolderID,
    TransactionLogsFolderID:
        TransactionLogsFolderID ?? this.TransactionLogsFolderID,
    EodLogsFolderID: EodLogsFolderID ?? this.EodLogsFolderID,
    InstallationID: InstallationID ?? this.InstallationID,
    FolderOwnerEmail: FolderOwnerEmail.present
        ? FolderOwnerEmail.value
        : this.FolderOwnerEmail,
    ProvisioningStatus: ProvisioningStatus ?? this.ProvisioningStatus,
    IsAppOwned: IsAppOwned ?? this.IsAppOwned,
    LastValidatedAt: LastValidatedAt.present
        ? LastValidatedAt.value
        : this.LastValidatedAt,
    UpdatedAt: UpdatedAt ?? this.UpdatedAt,
  );
  CloudSyncSetting copyWithCompanion(CloudSyncSettingsCompanion data) {
    return CloudSyncSetting(
      ID: data.ID.present ? data.ID.value : this.ID,
      RootFolderID: data.RootFolderID.present
          ? data.RootFolderID.value
          : this.RootFolderID,
      TransactionLogsFolderID: data.TransactionLogsFolderID.present
          ? data.TransactionLogsFolderID.value
          : this.TransactionLogsFolderID,
      EodLogsFolderID: data.EodLogsFolderID.present
          ? data.EodLogsFolderID.value
          : this.EodLogsFolderID,
      InstallationID: data.InstallationID.present
          ? data.InstallationID.value
          : this.InstallationID,
      FolderOwnerEmail: data.FolderOwnerEmail.present
          ? data.FolderOwnerEmail.value
          : this.FolderOwnerEmail,
      ProvisioningStatus: data.ProvisioningStatus.present
          ? data.ProvisioningStatus.value
          : this.ProvisioningStatus,
      IsAppOwned: data.IsAppOwned.present
          ? data.IsAppOwned.value
          : this.IsAppOwned,
      LastValidatedAt: data.LastValidatedAt.present
          ? data.LastValidatedAt.value
          : this.LastValidatedAt,
      UpdatedAt: data.UpdatedAt.present ? data.UpdatedAt.value : this.UpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CloudSyncSetting(')
          ..write('ID: $ID, ')
          ..write('RootFolderID: $RootFolderID, ')
          ..write('TransactionLogsFolderID: $TransactionLogsFolderID, ')
          ..write('EodLogsFolderID: $EodLogsFolderID, ')
          ..write('InstallationID: $InstallationID, ')
          ..write('FolderOwnerEmail: $FolderOwnerEmail, ')
          ..write('ProvisioningStatus: $ProvisioningStatus, ')
          ..write('IsAppOwned: $IsAppOwned, ')
          ..write('LastValidatedAt: $LastValidatedAt, ')
          ..write('UpdatedAt: $UpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ID,
    RootFolderID,
    TransactionLogsFolderID,
    EodLogsFolderID,
    InstallationID,
    FolderOwnerEmail,
    ProvisioningStatus,
    IsAppOwned,
    LastValidatedAt,
    UpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CloudSyncSetting &&
          other.ID == this.ID &&
          other.RootFolderID == this.RootFolderID &&
          other.TransactionLogsFolderID == this.TransactionLogsFolderID &&
          other.EodLogsFolderID == this.EodLogsFolderID &&
          other.InstallationID == this.InstallationID &&
          other.FolderOwnerEmail == this.FolderOwnerEmail &&
          other.ProvisioningStatus == this.ProvisioningStatus &&
          other.IsAppOwned == this.IsAppOwned &&
          other.LastValidatedAt == this.LastValidatedAt &&
          other.UpdatedAt == this.UpdatedAt);
}

class CloudSyncSettingsCompanion extends UpdateCompanion<CloudSyncSetting> {
  final Value<int> ID;
  final Value<String?> RootFolderID;
  final Value<String> TransactionLogsFolderID;
  final Value<String> EodLogsFolderID;
  final Value<String> InstallationID;
  final Value<String?> FolderOwnerEmail;
  final Value<String> ProvisioningStatus;
  final Value<bool> IsAppOwned;
  final Value<DateTime?> LastValidatedAt;
  final Value<DateTime> UpdatedAt;
  const CloudSyncSettingsCompanion({
    this.ID = const Value.absent(),
    this.RootFolderID = const Value.absent(),
    this.TransactionLogsFolderID = const Value.absent(),
    this.EodLogsFolderID = const Value.absent(),
    this.InstallationID = const Value.absent(),
    this.FolderOwnerEmail = const Value.absent(),
    this.ProvisioningStatus = const Value.absent(),
    this.IsAppOwned = const Value.absent(),
    this.LastValidatedAt = const Value.absent(),
    this.UpdatedAt = const Value.absent(),
  });
  CloudSyncSettingsCompanion.insert({
    this.ID = const Value.absent(),
    this.RootFolderID = const Value.absent(),
    required String TransactionLogsFolderID,
    required String EodLogsFolderID,
    this.InstallationID = const Value.absent(),
    this.FolderOwnerEmail = const Value.absent(),
    this.ProvisioningStatus = const Value.absent(),
    this.IsAppOwned = const Value.absent(),
    this.LastValidatedAt = const Value.absent(),
    this.UpdatedAt = const Value.absent(),
  }) : TransactionLogsFolderID = Value(TransactionLogsFolderID),
       EodLogsFolderID = Value(EodLogsFolderID);
  static Insertable<CloudSyncSetting> custom({
    Expression<int>? ID,
    Expression<String>? RootFolderID,
    Expression<String>? TransactionLogsFolderID,
    Expression<String>? EodLogsFolderID,
    Expression<String>? InstallationID,
    Expression<String>? FolderOwnerEmail,
    Expression<String>? ProvisioningStatus,
    Expression<bool>? IsAppOwned,
    Expression<DateTime>? LastValidatedAt,
    Expression<DateTime>? UpdatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (RootFolderID != null) 'root_folder_i_d': RootFolderID,
      if (TransactionLogsFolderID != null)
        'transaction_logs_folder_i_d': TransactionLogsFolderID,
      if (EodLogsFolderID != null) 'eod_logs_folder_i_d': EodLogsFolderID,
      if (InstallationID != null) 'installation_i_d': InstallationID,
      if (FolderOwnerEmail != null) 'folder_owner_email': FolderOwnerEmail,
      if (ProvisioningStatus != null) 'provisioning_status': ProvisioningStatus,
      if (IsAppOwned != null) 'is_app_owned': IsAppOwned,
      if (LastValidatedAt != null) 'last_validated_at': LastValidatedAt,
      if (UpdatedAt != null) 'updated_at': UpdatedAt,
    });
  }

  CloudSyncSettingsCompanion copyWith({
    Value<int>? ID,
    Value<String?>? RootFolderID,
    Value<String>? TransactionLogsFolderID,
    Value<String>? EodLogsFolderID,
    Value<String>? InstallationID,
    Value<String?>? FolderOwnerEmail,
    Value<String>? ProvisioningStatus,
    Value<bool>? IsAppOwned,
    Value<DateTime?>? LastValidatedAt,
    Value<DateTime>? UpdatedAt,
  }) {
    return CloudSyncSettingsCompanion(
      ID: ID ?? this.ID,
      RootFolderID: RootFolderID ?? this.RootFolderID,
      TransactionLogsFolderID:
          TransactionLogsFolderID ?? this.TransactionLogsFolderID,
      EodLogsFolderID: EodLogsFolderID ?? this.EodLogsFolderID,
      InstallationID: InstallationID ?? this.InstallationID,
      FolderOwnerEmail: FolderOwnerEmail ?? this.FolderOwnerEmail,
      ProvisioningStatus: ProvisioningStatus ?? this.ProvisioningStatus,
      IsAppOwned: IsAppOwned ?? this.IsAppOwned,
      LastValidatedAt: LastValidatedAt ?? this.LastValidatedAt,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ID.present) {
      map['id'] = Variable<int>(ID.value);
    }
    if (RootFolderID.present) {
      map['root_folder_i_d'] = Variable<String>(RootFolderID.value);
    }
    if (TransactionLogsFolderID.present) {
      map['transaction_logs_folder_i_d'] = Variable<String>(
        TransactionLogsFolderID.value,
      );
    }
    if (EodLogsFolderID.present) {
      map['eod_logs_folder_i_d'] = Variable<String>(EodLogsFolderID.value);
    }
    if (InstallationID.present) {
      map['installation_i_d'] = Variable<String>(InstallationID.value);
    }
    if (FolderOwnerEmail.present) {
      map['folder_owner_email'] = Variable<String>(FolderOwnerEmail.value);
    }
    if (ProvisioningStatus.present) {
      map['provisioning_status'] = Variable<String>(ProvisioningStatus.value);
    }
    if (IsAppOwned.present) {
      map['is_app_owned'] = Variable<bool>(IsAppOwned.value);
    }
    if (LastValidatedAt.present) {
      map['last_validated_at'] = Variable<DateTime>(LastValidatedAt.value);
    }
    if (UpdatedAt.present) {
      map['updated_at'] = Variable<DateTime>(UpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CloudSyncSettingsCompanion(')
          ..write('ID: $ID, ')
          ..write('RootFolderID: $RootFolderID, ')
          ..write('TransactionLogsFolderID: $TransactionLogsFolderID, ')
          ..write('EodLogsFolderID: $EodLogsFolderID, ')
          ..write('InstallationID: $InstallationID, ')
          ..write('FolderOwnerEmail: $FolderOwnerEmail, ')
          ..write('ProvisioningStatus: $ProvisioningStatus, ')
          ..write('IsAppOwned: $IsAppOwned, ')
          ..write('LastValidatedAt: $LastValidatedAt, ')
          ..write('UpdatedAt: $UpdatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductVariantsTable productVariants = $ProductVariantsTable(
    this,
  );
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems = $TransactionItemsTable(
    this,
  );
  late final $TransactionPrintJobsTable transactionPrintJobs =
      $TransactionPrintJobsTable(this);
  late final $TransactionSyncBatchesTable transactionSyncBatches =
      $TransactionSyncBatchesTable(this);
  late final $EodSummariesTable eodSummaries = $EodSummariesTable(this);
  late final $EodSummaryItemsTable eodSummaryItems = $EodSummaryItemsTable(
    this,
  );
  late final $StoreSettingsTable storeSettings = $StoreSettingsTable(this);
  late final $CloudSyncSettingsTable cloudSyncSettings =
      $CloudSyncSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    productVariants,
    transactions,
    transactionItems,
    transactionPrintJobs,
    transactionSyncBatches,
    eodSummaries,
    eodSummaryItems,
    storeSettings,
    cloudSyncSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transaction_print_jobs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'eod_summaries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('eod_summary_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> ID,
      required String ProductName,
      Value<String?> Brand,
      Value<bool> IsActive,
      Value<DateTime> CreatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> ID,
      Value<String> ProductName,
      Value<String?> Brand,
      Value<bool> IsActive,
      Value<DateTime> CreatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductVariantsTable, List<ProductVariant>>
  _productVariantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productVariants,
    aliasName: 'products__id__product_variants__product_i_d',
  );

  $$ProductVariantsTableProcessedTableManager get productVariantsRefs {
    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.ProductID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productVariantsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ProductName => $composableBuilder(
    column: $table.ProductName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Brand => $composableBuilder(
    column: $table.Brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get IsActive => $composableBuilder(
    column: $table.IsActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productVariantsRefs(
    Expression<bool> Function($$ProductVariantsTableFilterComposer f) f,
  ) {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ProductID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ProductName => $composableBuilder(
    column: $table.ProductName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Brand => $composableBuilder(
    column: $table.Brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get IsActive => $composableBuilder(
    column: $table.IsActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get ProductName => $composableBuilder(
    column: $table.ProductName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get Brand =>
      $composableBuilder(column: $table.Brand, builder: (column) => column);

  GeneratedColumn<bool> get IsActive =>
      $composableBuilder(column: $table.IsActive, builder: (column) => column);

  GeneratedColumn<DateTime> get CreatedAt =>
      $composableBuilder(column: $table.CreatedAt, builder: (column) => column);

  Expression<T> productVariantsRefs<T extends Object>(
    Expression<T> Function($$ProductVariantsTableAnnotationComposer a) f,
  ) {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ProductID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool productVariantsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String> ProductName = const Value.absent(),
                Value<String?> Brand = const Value.absent(),
                Value<bool> IsActive = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => ProductsCompanion(
                ID: ID,
                ProductName: ProductName,
                Brand: Brand,
                IsActive: IsActive,
                CreatedAt: CreatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String ProductName,
                Value<String?> Brand = const Value.absent(),
                Value<bool> IsActive = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                ID: ID,
                ProductName: ProductName,
                Brand: Brand,
                IsActive: IsActive,
                CreatedAt: CreatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productVariantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productVariantsRefs) db.productVariants,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productVariantsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ProductVariant
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._productVariantsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).productVariantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ProductID == item.ID),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool productVariantsRefs})
    >;
typedef $$ProductVariantsTableCreateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> ID,
      required int ProductID,
      Value<String?> Color,
      Value<String?> Size,
      required String Unit,
      required int PriceInCents,
      Value<bool> IsActive,
    });
typedef $$ProductVariantsTableUpdateCompanionBuilder =
    ProductVariantsCompanion Function({
      Value<int> ID,
      Value<int> ProductID,
      Value<String?> Color,
      Value<String?> Size,
      Value<String> Unit,
      Value<int> PriceInCents,
      Value<bool> IsActive,
    });

final class $$ProductVariantsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductVariantsTable, ProductVariant> {
  $$ProductVariantsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _ProductIDTable(_$AppDatabase db) =>
      db.products.createAlias('product_variants__product_i_d__products__id');

  $$ProductsTableProcessedTableManager get ProductID {
    final $_column = $_itemColumn<int>('product_i_d')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ProductIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
  _transactionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionItems,
    aliasName: 'product_variants__id__transaction_items__product_variant_i_d',
  );

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
      $_db,
      $_db.transactionItems,
    ).filter((f) => f.ProductVariantID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EodSummaryItemsTable, List<EodSummaryItem>>
  _eodSummaryItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eodSummaryItems,
    aliasName: 'product_variants__id__eod_summary_items__product_variant_i_d',
  );

  $$EodSummaryItemsTableProcessedTableManager get eodSummaryItemsRefs {
    final manager = $$EodSummaryItemsTableTableManager(
      $_db,
      $_db.eodSummaryItems,
    ).filter((f) => f.ProductVariantID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eodSummaryItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductVariantsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Color => $composableBuilder(
    column: $table.Color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Size => $composableBuilder(
    column: $table.Size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Unit => $composableBuilder(
    column: $table.Unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get PriceInCents => $composableBuilder(
    column: $table.PriceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get IsActive => $composableBuilder(
    column: $table.IsActive,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get ProductID {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductID,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionItemsRefs(
    Expression<bool> Function($$TransactionItemsTableFilterComposer f) f,
  ) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.transactionItems,
      getReferencedColumn: (t) => t.ProductVariantID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionItemsTableFilterComposer(
            $db: $db,
            $table: $db.transactionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eodSummaryItemsRefs(
    Expression<bool> Function($$EodSummaryItemsTableFilterComposer f) f,
  ) {
    final $$EodSummaryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.eodSummaryItems,
      getReferencedColumn: (t) => t.ProductVariantID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummaryItemsTableFilterComposer(
            $db: $db,
            $table: $db.eodSummaryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Color => $composableBuilder(
    column: $table.Color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Size => $composableBuilder(
    column: $table.Size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Unit => $composableBuilder(
    column: $table.Unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get PriceInCents => $composableBuilder(
    column: $table.PriceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get IsActive => $composableBuilder(
    column: $table.IsActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get ProductID {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductID,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductVariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductVariantsTable> {
  $$ProductVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get Color =>
      $composableBuilder(column: $table.Color, builder: (column) => column);

  GeneratedColumn<String> get Size =>
      $composableBuilder(column: $table.Size, builder: (column) => column);

  GeneratedColumn<String> get Unit =>
      $composableBuilder(column: $table.Unit, builder: (column) => column);

  GeneratedColumn<int> get PriceInCents => $composableBuilder(
    column: $table.PriceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get IsActive =>
      $composableBuilder(column: $table.IsActive, builder: (column) => column);

  $$ProductsTableAnnotationComposer get ProductID {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductID,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
    Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f,
  ) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.transactionItems,
      getReferencedColumn: (t) => t.ProductVariantID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eodSummaryItemsRefs<T extends Object>(
    Expression<T> Function($$EodSummaryItemsTableAnnotationComposer a) f,
  ) {
    final $$EodSummaryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.eodSummaryItems,
      getReferencedColumn: (t) => t.ProductVariantID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummaryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.eodSummaryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductVariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductVariantsTable,
          ProductVariant,
          $$ProductVariantsTableFilterComposer,
          $$ProductVariantsTableOrderingComposer,
          $$ProductVariantsTableAnnotationComposer,
          $$ProductVariantsTableCreateCompanionBuilder,
          $$ProductVariantsTableUpdateCompanionBuilder,
          (ProductVariant, $$ProductVariantsTableReferences),
          ProductVariant,
          PrefetchHooks Function({
            bool ProductID,
            bool transactionItemsRefs,
            bool eodSummaryItemsRefs,
          })
        > {
  $$ProductVariantsTableTableManager(
    _$AppDatabase db,
    $ProductVariantsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<int> ProductID = const Value.absent(),
                Value<String?> Color = const Value.absent(),
                Value<String?> Size = const Value.absent(),
                Value<String> Unit = const Value.absent(),
                Value<int> PriceInCents = const Value.absent(),
                Value<bool> IsActive = const Value.absent(),
              }) => ProductVariantsCompanion(
                ID: ID,
                ProductID: ProductID,
                Color: Color,
                Size: Size,
                Unit: Unit,
                PriceInCents: PriceInCents,
                IsActive: IsActive,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required int ProductID,
                Value<String?> Color = const Value.absent(),
                Value<String?> Size = const Value.absent(),
                required String Unit,
                required int PriceInCents,
                Value<bool> IsActive = const Value.absent(),
              }) => ProductVariantsCompanion.insert(
                ID: ID,
                ProductID: ProductID,
                Color: Color,
                Size: Size,
                Unit: Unit,
                PriceInCents: PriceInCents,
                IsActive: IsActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductVariantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ProductID = false,
                transactionItemsRefs = false,
                eodSummaryItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionItemsRefs) db.transactionItems,
                    if (eodSummaryItemsRefs) db.eodSummaryItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ProductID) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ProductID,
                                    referencedTable:
                                        $$ProductVariantsTableReferences._ProductIDTable(
                                          db,
                                        ),
                                    referencedColumn:
                                        $$ProductVariantsTableReferences._ProductIDTable(
                                          db,
                                        ).ID,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionItemsRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          TransactionItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._transactionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ProductVariantID == item.ID,
                              ),
                          typedResults: items,
                        ),
                      if (eodSummaryItemsRefs)
                        await $_getPrefetchedData<
                          ProductVariant,
                          $ProductVariantsTable,
                          EodSummaryItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductVariantsTableReferences
                              ._eodSummaryItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductVariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).eodSummaryItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ProductVariantID == item.ID,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductVariantsTable,
      ProductVariant,
      $$ProductVariantsTableFilterComposer,
      $$ProductVariantsTableOrderingComposer,
      $$ProductVariantsTableAnnotationComposer,
      $$ProductVariantsTableCreateCompanionBuilder,
      $$ProductVariantsTableUpdateCompanionBuilder,
      (ProductVariant, $$ProductVariantsTableReferences),
      ProductVariant,
      PrefetchHooks Function({
        bool ProductID,
        bool transactionItemsRefs,
        bool eodSummaryItemsRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> ID,
      required String ReceiptNumber,
      required String CashierName,
      required int TotalInCents,
      Value<String> Status,
      Value<String> PaymentMethod,
      Value<String> SyncStatus,
      Value<int> SyncAttemptCount,
      Value<DateTime?> LastSyncAttemptAt,
      Value<DateTime?> SyncedAt,
      Value<String?> LastSyncError,
      Value<String?> SyncBatchID,
      Value<DateTime> CreatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> ID,
      Value<String> ReceiptNumber,
      Value<String> CashierName,
      Value<int> TotalInCents,
      Value<String> Status,
      Value<String> PaymentMethod,
      Value<String> SyncStatus,
      Value<int> SyncAttemptCount,
      Value<DateTime?> LastSyncAttemptAt,
      Value<DateTime?> SyncedAt,
      Value<String?> LastSyncError,
      Value<String?> SyncBatchID,
      Value<DateTime> CreatedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
  _transactionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionItems,
    aliasName: 'transactions__id__transaction_items__transaction_i_d',
  );

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
      $_db,
      $_db.transactionItems,
    ).filter((f) => f.TransactionID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TransactionPrintJobsTable,
    List<TransactionPrintJob>
  >
  _transactionPrintJobsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionPrintJobs,
        aliasName: 'transactions__id__transaction_print_jobs__transaction_i_d',
      );

  $$TransactionPrintJobsTableProcessedTableManager
  get transactionPrintJobsRefs {
    final manager = $$TransactionPrintJobsTableTableManager(
      $_db,
      $_db.transactionPrintJobs,
    ).filter((f) => f.TransactionID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionPrintJobsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ReceiptNumber => $composableBuilder(
    column: $table.ReceiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get CashierName => $composableBuilder(
    column: $table.CashierName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get TotalInCents => $composableBuilder(
    column: $table.TotalInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get PaymentMethod => $composableBuilder(
    column: $table.PaymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get SyncStatus => $composableBuilder(
    column: $table.SyncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get SyncAttemptCount => $composableBuilder(
    column: $table.SyncAttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get LastSyncAttemptAt => $composableBuilder(
    column: $table.LastSyncAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get SyncedAt => $composableBuilder(
    column: $table.SyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get LastSyncError => $composableBuilder(
    column: $table.LastSyncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get SyncBatchID => $composableBuilder(
    column: $table.SyncBatchID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionItemsRefs(
    Expression<bool> Function($$TransactionItemsTableFilterComposer f) f,
  ) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.transactionItems,
      getReferencedColumn: (t) => t.TransactionID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionItemsTableFilterComposer(
            $db: $db,
            $table: $db.transactionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionPrintJobsRefs(
    Expression<bool> Function($$TransactionPrintJobsTableFilterComposer f) f,
  ) {
    final $$TransactionPrintJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.transactionPrintJobs,
      getReferencedColumn: (t) => t.TransactionID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionPrintJobsTableFilterComposer(
            $db: $db,
            $table: $db.transactionPrintJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ReceiptNumber => $composableBuilder(
    column: $table.ReceiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get CashierName => $composableBuilder(
    column: $table.CashierName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get TotalInCents => $composableBuilder(
    column: $table.TotalInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get PaymentMethod => $composableBuilder(
    column: $table.PaymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get SyncStatus => $composableBuilder(
    column: $table.SyncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get SyncAttemptCount => $composableBuilder(
    column: $table.SyncAttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get LastSyncAttemptAt => $composableBuilder(
    column: $table.LastSyncAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get SyncedAt => $composableBuilder(
    column: $table.SyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get LastSyncError => $composableBuilder(
    column: $table.LastSyncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get SyncBatchID => $composableBuilder(
    column: $table.SyncBatchID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get ReceiptNumber => $composableBuilder(
    column: $table.ReceiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get CashierName => $composableBuilder(
    column: $table.CashierName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get TotalInCents => $composableBuilder(
    column: $table.TotalInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get Status =>
      $composableBuilder(column: $table.Status, builder: (column) => column);

  GeneratedColumn<String> get PaymentMethod => $composableBuilder(
    column: $table.PaymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get SyncStatus => $composableBuilder(
    column: $table.SyncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get SyncAttemptCount => $composableBuilder(
    column: $table.SyncAttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get LastSyncAttemptAt => $composableBuilder(
    column: $table.LastSyncAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get SyncedAt =>
      $composableBuilder(column: $table.SyncedAt, builder: (column) => column);

  GeneratedColumn<String> get LastSyncError => $composableBuilder(
    column: $table.LastSyncError,
    builder: (column) => column,
  );

  GeneratedColumn<String> get SyncBatchID => $composableBuilder(
    column: $table.SyncBatchID,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get CreatedAt =>
      $composableBuilder(column: $table.CreatedAt, builder: (column) => column);

  Expression<T> transactionItemsRefs<T extends Object>(
    Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f,
  ) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.transactionItems,
      getReferencedColumn: (t) => t.TransactionID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionPrintJobsRefs<T extends Object>(
    Expression<T> Function($$TransactionPrintJobsTableAnnotationComposer a) f,
  ) {
    final $$TransactionPrintJobsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.ID,
          referencedTable: $db.transactionPrintJobs,
          getReferencedColumn: (t) => t.TransactionID,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionPrintJobsTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionPrintJobs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool transactionItemsRefs,
            bool transactionPrintJobsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String> ReceiptNumber = const Value.absent(),
                Value<String> CashierName = const Value.absent(),
                Value<int> TotalInCents = const Value.absent(),
                Value<String> Status = const Value.absent(),
                Value<String> PaymentMethod = const Value.absent(),
                Value<String> SyncStatus = const Value.absent(),
                Value<int> SyncAttemptCount = const Value.absent(),
                Value<DateTime?> LastSyncAttemptAt = const Value.absent(),
                Value<DateTime?> SyncedAt = const Value.absent(),
                Value<String?> LastSyncError = const Value.absent(),
                Value<String?> SyncBatchID = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                ID: ID,
                ReceiptNumber: ReceiptNumber,
                CashierName: CashierName,
                TotalInCents: TotalInCents,
                Status: Status,
                PaymentMethod: PaymentMethod,
                SyncStatus: SyncStatus,
                SyncAttemptCount: SyncAttemptCount,
                LastSyncAttemptAt: LastSyncAttemptAt,
                SyncedAt: SyncedAt,
                LastSyncError: LastSyncError,
                SyncBatchID: SyncBatchID,
                CreatedAt: CreatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String ReceiptNumber,
                required String CashierName,
                required int TotalInCents,
                Value<String> Status = const Value.absent(),
                Value<String> PaymentMethod = const Value.absent(),
                Value<String> SyncStatus = const Value.absent(),
                Value<int> SyncAttemptCount = const Value.absent(),
                Value<DateTime?> LastSyncAttemptAt = const Value.absent(),
                Value<DateTime?> SyncedAt = const Value.absent(),
                Value<String?> LastSyncError = const Value.absent(),
                Value<String?> SyncBatchID = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                ID: ID,
                ReceiptNumber: ReceiptNumber,
                CashierName: CashierName,
                TotalInCents: TotalInCents,
                Status: Status,
                PaymentMethod: PaymentMethod,
                SyncStatus: SyncStatus,
                SyncAttemptCount: SyncAttemptCount,
                LastSyncAttemptAt: LastSyncAttemptAt,
                SyncedAt: SyncedAt,
                LastSyncError: LastSyncError,
                SyncBatchID: SyncBatchID,
                CreatedAt: CreatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionItemsRefs = false,
                transactionPrintJobsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionItemsRefs) db.transactionItems,
                    if (transactionPrintJobsRefs) db.transactionPrintJobs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionItemsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TransactionItem
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.TransactionID == item.ID,
                              ),
                          typedResults: items,
                        ),
                      if (transactionPrintJobsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TransactionPrintJob
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionPrintJobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionPrintJobsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.TransactionID == item.ID,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool transactionItemsRefs,
        bool transactionPrintJobsRefs,
      })
    >;
typedef $$TransactionItemsTableCreateCompanionBuilder =
    TransactionItemsCompanion Function({
      Value<int> ID,
      required int TransactionID,
      required int ProductVariantID,
      required String ProductNameSnapshot,
      required String UnitSnapshot,
      required int UnitPriceInCents,
      required int Quantity,
      required int LineTotalInCents,
    });
typedef $$TransactionItemsTableUpdateCompanionBuilder =
    TransactionItemsCompanion Function({
      Value<int> ID,
      Value<int> TransactionID,
      Value<int> ProductVariantID,
      Value<String> ProductNameSnapshot,
      Value<String> UnitSnapshot,
      Value<int> UnitPriceInCents,
      Value<int> Quantity,
      Value<int> LineTotalInCents,
    });

final class $$TransactionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TransactionItemsTable, TransactionItem> {
  $$TransactionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _TransactionIDTable(_$AppDatabase db) => db
      .transactions
      .createAlias('transaction_items__transaction_i_d__transactions__id');

  $$TransactionsTableProcessedTableManager get TransactionID {
    final $_column = $_itemColumn<int>('transaction_i_d')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_TransactionIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _ProductVariantIDTable(_$AppDatabase db) =>
      db.productVariants.createAlias(
        'transaction_items__product_variant_i_d__product_variants__id',
      );

  $$ProductVariantsTableProcessedTableManager get ProductVariantID {
    final $_column = $_itemColumn<int>('product_variant_i_d')!;

    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ProductVariantIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get Quantity => $composableBuilder(
    column: $table.Quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get LineTotalInCents => $composableBuilder(
    column: $table.LineTotalInCents,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get TransactionID {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get ProductVariantID {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get Quantity => $composableBuilder(
    column: $table.Quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get LineTotalInCents => $composableBuilder(
    column: $table.LineTotalInCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get TransactionID {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get ProductVariantID {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get Quantity =>
      $composableBuilder(column: $table.Quantity, builder: (column) => column);

  GeneratedColumn<int> get LineTotalInCents => $composableBuilder(
    column: $table.LineTotalInCents,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get TransactionID {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get ProductVariantID {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionItemsTable,
          TransactionItem,
          $$TransactionItemsTableFilterComposer,
          $$TransactionItemsTableOrderingComposer,
          $$TransactionItemsTableAnnotationComposer,
          $$TransactionItemsTableCreateCompanionBuilder,
          $$TransactionItemsTableUpdateCompanionBuilder,
          (TransactionItem, $$TransactionItemsTableReferences),
          TransactionItem,
          PrefetchHooks Function({bool TransactionID, bool ProductVariantID})
        > {
  $$TransactionItemsTableTableManager(
    _$AppDatabase db,
    $TransactionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<int> TransactionID = const Value.absent(),
                Value<int> ProductVariantID = const Value.absent(),
                Value<String> ProductNameSnapshot = const Value.absent(),
                Value<String> UnitSnapshot = const Value.absent(),
                Value<int> UnitPriceInCents = const Value.absent(),
                Value<int> Quantity = const Value.absent(),
                Value<int> LineTotalInCents = const Value.absent(),
              }) => TransactionItemsCompanion(
                ID: ID,
                TransactionID: TransactionID,
                ProductVariantID: ProductVariantID,
                ProductNameSnapshot: ProductNameSnapshot,
                UnitSnapshot: UnitSnapshot,
                UnitPriceInCents: UnitPriceInCents,
                Quantity: Quantity,
                LineTotalInCents: LineTotalInCents,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required int TransactionID,
                required int ProductVariantID,
                required String ProductNameSnapshot,
                required String UnitSnapshot,
                required int UnitPriceInCents,
                required int Quantity,
                required int LineTotalInCents,
              }) => TransactionItemsCompanion.insert(
                ID: ID,
                TransactionID: TransactionID,
                ProductVariantID: ProductVariantID,
                ProductNameSnapshot: ProductNameSnapshot,
                UnitSnapshot: UnitSnapshot,
                UnitPriceInCents: UnitPriceInCents,
                Quantity: Quantity,
                LineTotalInCents: LineTotalInCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({TransactionID = false, ProductVariantID = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (TransactionID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.TransactionID,
                                referencedTable:
                                    $$TransactionItemsTableReferences._TransactionIDTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$TransactionItemsTableReferences._TransactionIDTable(
                                      db,
                                    ).ID,
                              )
                              as T;
                    }
                    if (ProductVariantID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ProductVariantID,
                                referencedTable:
                                    $$TransactionItemsTableReferences._ProductVariantIDTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$TransactionItemsTableReferences._ProductVariantIDTable(
                                      db,
                                    ).ID,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionItemsTable,
      TransactionItem,
      $$TransactionItemsTableFilterComposer,
      $$TransactionItemsTableOrderingComposer,
      $$TransactionItemsTableAnnotationComposer,
      $$TransactionItemsTableCreateCompanionBuilder,
      $$TransactionItemsTableUpdateCompanionBuilder,
      (TransactionItem, $$TransactionItemsTableReferences),
      TransactionItem,
      PrefetchHooks Function({bool TransactionID, bool ProductVariantID})
    >;
typedef $$TransactionPrintJobsTableCreateCompanionBuilder =
    TransactionPrintJobsCompanion Function({
      Value<int> ID,
      required int TransactionID,
      Value<String> Status,
      Value<int> AttemptCount,
      Value<DateTime?> LastAttemptAt,
      Value<DateTime?> PrintedAt,
      Value<String?> LastError,
      Value<DateTime> CreatedAt,
    });
typedef $$TransactionPrintJobsTableUpdateCompanionBuilder =
    TransactionPrintJobsCompanion Function({
      Value<int> ID,
      Value<int> TransactionID,
      Value<String> Status,
      Value<int> AttemptCount,
      Value<DateTime?> LastAttemptAt,
      Value<DateTime?> PrintedAt,
      Value<String?> LastError,
      Value<DateTime> CreatedAt,
    });

final class $$TransactionPrintJobsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionPrintJobsTable,
          TransactionPrintJob
        > {
  $$TransactionPrintJobsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _TransactionIDTable(_$AppDatabase db) => db
      .transactions
      .createAlias('transaction_print_jobs__transaction_i_d__transactions__id');

  $$TransactionsTableProcessedTableManager get TransactionID {
    final $_column = $_itemColumn<int>('transaction_i_d')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_TransactionIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionPrintJobsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionPrintJobsTable> {
  $$TransactionPrintJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get PrintedAt => $composableBuilder(
    column: $table.PrintedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get LastError => $composableBuilder(
    column: $table.LastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get TransactionID {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionPrintJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionPrintJobsTable> {
  $$TransactionPrintJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get PrintedAt => $composableBuilder(
    column: $table.PrintedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get LastError => $composableBuilder(
    column: $table.LastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get TransactionID {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionPrintJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionPrintJobsTable> {
  $$TransactionPrintJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get Status =>
      $composableBuilder(column: $table.Status, builder: (column) => column);

  GeneratedColumn<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get PrintedAt =>
      $composableBuilder(column: $table.PrintedAt, builder: (column) => column);

  GeneratedColumn<String> get LastError =>
      $composableBuilder(column: $table.LastError, builder: (column) => column);

  GeneratedColumn<DateTime> get CreatedAt =>
      $composableBuilder(column: $table.CreatedAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get TransactionID {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.TransactionID,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionPrintJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionPrintJobsTable,
          TransactionPrintJob,
          $$TransactionPrintJobsTableFilterComposer,
          $$TransactionPrintJobsTableOrderingComposer,
          $$TransactionPrintJobsTableAnnotationComposer,
          $$TransactionPrintJobsTableCreateCompanionBuilder,
          $$TransactionPrintJobsTableUpdateCompanionBuilder,
          (TransactionPrintJob, $$TransactionPrintJobsTableReferences),
          TransactionPrintJob,
          PrefetchHooks Function({bool TransactionID})
        > {
  $$TransactionPrintJobsTableTableManager(
    _$AppDatabase db,
    $TransactionPrintJobsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionPrintJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionPrintJobsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionPrintJobsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<int> TransactionID = const Value.absent(),
                Value<String> Status = const Value.absent(),
                Value<int> AttemptCount = const Value.absent(),
                Value<DateTime?> LastAttemptAt = const Value.absent(),
                Value<DateTime?> PrintedAt = const Value.absent(),
                Value<String?> LastError = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionPrintJobsCompanion(
                ID: ID,
                TransactionID: TransactionID,
                Status: Status,
                AttemptCount: AttemptCount,
                LastAttemptAt: LastAttemptAt,
                PrintedAt: PrintedAt,
                LastError: LastError,
                CreatedAt: CreatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required int TransactionID,
                Value<String> Status = const Value.absent(),
                Value<int> AttemptCount = const Value.absent(),
                Value<DateTime?> LastAttemptAt = const Value.absent(),
                Value<DateTime?> PrintedAt = const Value.absent(),
                Value<String?> LastError = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionPrintJobsCompanion.insert(
                ID: ID,
                TransactionID: TransactionID,
                Status: Status,
                AttemptCount: AttemptCount,
                LastAttemptAt: LastAttemptAt,
                PrintedAt: PrintedAt,
                LastError: LastError,
                CreatedAt: CreatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionPrintJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({TransactionID = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (TransactionID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.TransactionID,
                                referencedTable:
                                    $$TransactionPrintJobsTableReferences._TransactionIDTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$TransactionPrintJobsTableReferences._TransactionIDTable(
                                      db,
                                    ).ID,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionPrintJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionPrintJobsTable,
      TransactionPrintJob,
      $$TransactionPrintJobsTableFilterComposer,
      $$TransactionPrintJobsTableOrderingComposer,
      $$TransactionPrintJobsTableAnnotationComposer,
      $$TransactionPrintJobsTableCreateCompanionBuilder,
      $$TransactionPrintJobsTableUpdateCompanionBuilder,
      (TransactionPrintJob, $$TransactionPrintJobsTableReferences),
      TransactionPrintJob,
      PrefetchHooks Function({bool TransactionID})
    >;
typedef $$TransactionSyncBatchesTableCreateCompanionBuilder =
    TransactionSyncBatchesCompanion Function({
      Value<int> ID,
      required String BusinessDate,
      required String FileName,
      Value<String?> TextFileName,
      Value<String?> LocalFilePath,
      Value<String?> TextLocalFilePath,
      Value<String?> RemoteFileID,
      Value<String?> RemoteTextFileID,
      Value<String?> Checksum,
      Value<String?> TextChecksum,
      Value<String?> EodFileName,
      Value<String?> EodTextFileName,
      Value<String?> EodLocalFilePath,
      Value<String?> EodTextLocalFilePath,
      Value<String?> EodRemoteFileID,
      Value<String?> EodRemoteTextFileID,
      Value<String?> EodChecksum,
      Value<String?> EodTextChecksum,
      Value<String?> TransactionLogsFolderID,
      Value<String?> EodLogsFolderID,
      Value<int> RecordCount,
      Value<String> Status,
      Value<int> AttemptCount,
      Value<DateTime?> LastAttemptAt,
      Value<String?> LastError,
      Value<DateTime?> UploadedAt,
      Value<DateTime> CreatedAt,
    });
typedef $$TransactionSyncBatchesTableUpdateCompanionBuilder =
    TransactionSyncBatchesCompanion Function({
      Value<int> ID,
      Value<String> BusinessDate,
      Value<String> FileName,
      Value<String?> TextFileName,
      Value<String?> LocalFilePath,
      Value<String?> TextLocalFilePath,
      Value<String?> RemoteFileID,
      Value<String?> RemoteTextFileID,
      Value<String?> Checksum,
      Value<String?> TextChecksum,
      Value<String?> EodFileName,
      Value<String?> EodTextFileName,
      Value<String?> EodLocalFilePath,
      Value<String?> EodTextLocalFilePath,
      Value<String?> EodRemoteFileID,
      Value<String?> EodRemoteTextFileID,
      Value<String?> EodChecksum,
      Value<String?> EodTextChecksum,
      Value<String?> TransactionLogsFolderID,
      Value<String?> EodLogsFolderID,
      Value<int> RecordCount,
      Value<String> Status,
      Value<int> AttemptCount,
      Value<DateTime?> LastAttemptAt,
      Value<String?> LastError,
      Value<DateTime?> UploadedAt,
      Value<DateTime> CreatedAt,
    });

class $$TransactionSyncBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSyncBatchesTable> {
  $$TransactionSyncBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get FileName => $composableBuilder(
    column: $table.FileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get TextFileName => $composableBuilder(
    column: $table.TextFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get LocalFilePath => $composableBuilder(
    column: $table.LocalFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get TextLocalFilePath => $composableBuilder(
    column: $table.TextLocalFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get RemoteFileID => $composableBuilder(
    column: $table.RemoteFileID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get RemoteTextFileID => $composableBuilder(
    column: $table.RemoteTextFileID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Checksum => $composableBuilder(
    column: $table.Checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get TextChecksum => $composableBuilder(
    column: $table.TextChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodFileName => $composableBuilder(
    column: $table.EodFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodTextFileName => $composableBuilder(
    column: $table.EodTextFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodLocalFilePath => $composableBuilder(
    column: $table.EodLocalFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodTextLocalFilePath => $composableBuilder(
    column: $table.EodTextLocalFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodRemoteFileID => $composableBuilder(
    column: $table.EodRemoteFileID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodRemoteTextFileID => $composableBuilder(
    column: $table.EodRemoteTextFileID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodChecksum => $composableBuilder(
    column: $table.EodChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodTextChecksum => $composableBuilder(
    column: $table.EodTextChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get RecordCount => $composableBuilder(
    column: $table.RecordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get LastError => $composableBuilder(
    column: $table.LastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get UploadedAt => $composableBuilder(
    column: $table.UploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionSyncBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSyncBatchesTable> {
  $$TransactionSyncBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get FileName => $composableBuilder(
    column: $table.FileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get TextFileName => $composableBuilder(
    column: $table.TextFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get LocalFilePath => $composableBuilder(
    column: $table.LocalFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get TextLocalFilePath => $composableBuilder(
    column: $table.TextLocalFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get RemoteFileID => $composableBuilder(
    column: $table.RemoteFileID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get RemoteTextFileID => $composableBuilder(
    column: $table.RemoteTextFileID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Checksum => $composableBuilder(
    column: $table.Checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get TextChecksum => $composableBuilder(
    column: $table.TextChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodFileName => $composableBuilder(
    column: $table.EodFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodTextFileName => $composableBuilder(
    column: $table.EodTextFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodLocalFilePath => $composableBuilder(
    column: $table.EodLocalFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodTextLocalFilePath => $composableBuilder(
    column: $table.EodTextLocalFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodRemoteFileID => $composableBuilder(
    column: $table.EodRemoteFileID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodRemoteTextFileID => $composableBuilder(
    column: $table.EodRemoteTextFileID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodChecksum => $composableBuilder(
    column: $table.EodChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodTextChecksum => $composableBuilder(
    column: $table.EodTextChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get RecordCount => $composableBuilder(
    column: $table.RecordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Status => $composableBuilder(
    column: $table.Status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get LastError => $composableBuilder(
    column: $table.LastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get UploadedAt => $composableBuilder(
    column: $table.UploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionSyncBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSyncBatchesTable> {
  $$TransactionSyncBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get FileName =>
      $composableBuilder(column: $table.FileName, builder: (column) => column);

  GeneratedColumn<String> get TextFileName => $composableBuilder(
    column: $table.TextFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get LocalFilePath => $composableBuilder(
    column: $table.LocalFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get TextLocalFilePath => $composableBuilder(
    column: $table.TextLocalFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get RemoteFileID => $composableBuilder(
    column: $table.RemoteFileID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get RemoteTextFileID => $composableBuilder(
    column: $table.RemoteTextFileID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get Checksum =>
      $composableBuilder(column: $table.Checksum, builder: (column) => column);

  GeneratedColumn<String> get TextChecksum => $composableBuilder(
    column: $table.TextChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodFileName => $composableBuilder(
    column: $table.EodFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodTextFileName => $composableBuilder(
    column: $table.EodTextFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodLocalFilePath => $composableBuilder(
    column: $table.EodLocalFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodTextLocalFilePath => $composableBuilder(
    column: $table.EodTextLocalFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodRemoteFileID => $composableBuilder(
    column: $table.EodRemoteFileID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodRemoteTextFileID => $composableBuilder(
    column: $table.EodRemoteTextFileID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodChecksum => $composableBuilder(
    column: $table.EodChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodTextChecksum => $composableBuilder(
    column: $table.EodTextChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => column,
  );

  GeneratedColumn<int> get RecordCount => $composableBuilder(
    column: $table.RecordCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get Status =>
      $composableBuilder(column: $table.Status, builder: (column) => column);

  GeneratedColumn<int> get AttemptCount => $composableBuilder(
    column: $table.AttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get LastAttemptAt => $composableBuilder(
    column: $table.LastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get LastError =>
      $composableBuilder(column: $table.LastError, builder: (column) => column);

  GeneratedColumn<DateTime> get UploadedAt => $composableBuilder(
    column: $table.UploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get CreatedAt =>
      $composableBuilder(column: $table.CreatedAt, builder: (column) => column);
}

class $$TransactionSyncBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSyncBatchesTable,
          TransactionSyncBatche,
          $$TransactionSyncBatchesTableFilterComposer,
          $$TransactionSyncBatchesTableOrderingComposer,
          $$TransactionSyncBatchesTableAnnotationComposer,
          $$TransactionSyncBatchesTableCreateCompanionBuilder,
          $$TransactionSyncBatchesTableUpdateCompanionBuilder,
          (
            TransactionSyncBatche,
            BaseReferences<
              _$AppDatabase,
              $TransactionSyncBatchesTable,
              TransactionSyncBatche
            >,
          ),
          TransactionSyncBatche,
          PrefetchHooks Function()
        > {
  $$TransactionSyncBatchesTableTableManager(
    _$AppDatabase db,
    $TransactionSyncBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSyncBatchesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionSyncBatchesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionSyncBatchesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String> BusinessDate = const Value.absent(),
                Value<String> FileName = const Value.absent(),
                Value<String?> TextFileName = const Value.absent(),
                Value<String?> LocalFilePath = const Value.absent(),
                Value<String?> TextLocalFilePath = const Value.absent(),
                Value<String?> RemoteFileID = const Value.absent(),
                Value<String?> RemoteTextFileID = const Value.absent(),
                Value<String?> Checksum = const Value.absent(),
                Value<String?> TextChecksum = const Value.absent(),
                Value<String?> EodFileName = const Value.absent(),
                Value<String?> EodTextFileName = const Value.absent(),
                Value<String?> EodLocalFilePath = const Value.absent(),
                Value<String?> EodTextLocalFilePath = const Value.absent(),
                Value<String?> EodRemoteFileID = const Value.absent(),
                Value<String?> EodRemoteTextFileID = const Value.absent(),
                Value<String?> EodChecksum = const Value.absent(),
                Value<String?> EodTextChecksum = const Value.absent(),
                Value<String?> TransactionLogsFolderID = const Value.absent(),
                Value<String?> EodLogsFolderID = const Value.absent(),
                Value<int> RecordCount = const Value.absent(),
                Value<String> Status = const Value.absent(),
                Value<int> AttemptCount = const Value.absent(),
                Value<DateTime?> LastAttemptAt = const Value.absent(),
                Value<String?> LastError = const Value.absent(),
                Value<DateTime?> UploadedAt = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionSyncBatchesCompanion(
                ID: ID,
                BusinessDate: BusinessDate,
                FileName: FileName,
                TextFileName: TextFileName,
                LocalFilePath: LocalFilePath,
                TextLocalFilePath: TextLocalFilePath,
                RemoteFileID: RemoteFileID,
                RemoteTextFileID: RemoteTextFileID,
                Checksum: Checksum,
                TextChecksum: TextChecksum,
                EodFileName: EodFileName,
                EodTextFileName: EodTextFileName,
                EodLocalFilePath: EodLocalFilePath,
                EodTextLocalFilePath: EodTextLocalFilePath,
                EodRemoteFileID: EodRemoteFileID,
                EodRemoteTextFileID: EodRemoteTextFileID,
                EodChecksum: EodChecksum,
                EodTextChecksum: EodTextChecksum,
                TransactionLogsFolderID: TransactionLogsFolderID,
                EodLogsFolderID: EodLogsFolderID,
                RecordCount: RecordCount,
                Status: Status,
                AttemptCount: AttemptCount,
                LastAttemptAt: LastAttemptAt,
                LastError: LastError,
                UploadedAt: UploadedAt,
                CreatedAt: CreatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String BusinessDate,
                required String FileName,
                Value<String?> TextFileName = const Value.absent(),
                Value<String?> LocalFilePath = const Value.absent(),
                Value<String?> TextLocalFilePath = const Value.absent(),
                Value<String?> RemoteFileID = const Value.absent(),
                Value<String?> RemoteTextFileID = const Value.absent(),
                Value<String?> Checksum = const Value.absent(),
                Value<String?> TextChecksum = const Value.absent(),
                Value<String?> EodFileName = const Value.absent(),
                Value<String?> EodTextFileName = const Value.absent(),
                Value<String?> EodLocalFilePath = const Value.absent(),
                Value<String?> EodTextLocalFilePath = const Value.absent(),
                Value<String?> EodRemoteFileID = const Value.absent(),
                Value<String?> EodRemoteTextFileID = const Value.absent(),
                Value<String?> EodChecksum = const Value.absent(),
                Value<String?> EodTextChecksum = const Value.absent(),
                Value<String?> TransactionLogsFolderID = const Value.absent(),
                Value<String?> EodLogsFolderID = const Value.absent(),
                Value<int> RecordCount = const Value.absent(),
                Value<String> Status = const Value.absent(),
                Value<int> AttemptCount = const Value.absent(),
                Value<DateTime?> LastAttemptAt = const Value.absent(),
                Value<String?> LastError = const Value.absent(),
                Value<DateTime?> UploadedAt = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionSyncBatchesCompanion.insert(
                ID: ID,
                BusinessDate: BusinessDate,
                FileName: FileName,
                TextFileName: TextFileName,
                LocalFilePath: LocalFilePath,
                TextLocalFilePath: TextLocalFilePath,
                RemoteFileID: RemoteFileID,
                RemoteTextFileID: RemoteTextFileID,
                Checksum: Checksum,
                TextChecksum: TextChecksum,
                EodFileName: EodFileName,
                EodTextFileName: EodTextFileName,
                EodLocalFilePath: EodLocalFilePath,
                EodTextLocalFilePath: EodTextLocalFilePath,
                EodRemoteFileID: EodRemoteFileID,
                EodRemoteTextFileID: EodRemoteTextFileID,
                EodChecksum: EodChecksum,
                EodTextChecksum: EodTextChecksum,
                TransactionLogsFolderID: TransactionLogsFolderID,
                EodLogsFolderID: EodLogsFolderID,
                RecordCount: RecordCount,
                Status: Status,
                AttemptCount: AttemptCount,
                LastAttemptAt: LastAttemptAt,
                LastError: LastError,
                UploadedAt: UploadedAt,
                CreatedAt: CreatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionSyncBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSyncBatchesTable,
      TransactionSyncBatche,
      $$TransactionSyncBatchesTableFilterComposer,
      $$TransactionSyncBatchesTableOrderingComposer,
      $$TransactionSyncBatchesTableAnnotationComposer,
      $$TransactionSyncBatchesTableCreateCompanionBuilder,
      $$TransactionSyncBatchesTableUpdateCompanionBuilder,
      (
        TransactionSyncBatche,
        BaseReferences<
          _$AppDatabase,
          $TransactionSyncBatchesTable,
          TransactionSyncBatche
        >,
      ),
      TransactionSyncBatche,
      PrefetchHooks Function()
    >;
typedef $$EodSummariesTableCreateCompanionBuilder =
    EodSummariesCompanion Function({
      Value<int> ID,
      required String BusinessDate,
      Value<int> TransactionCount,
      Value<int> SoldUnitCount,
      Value<int> TotalSalesInCents,
      Value<DateTime> CreatedAt,
      Value<DateTime> UpdatedAt,
    });
typedef $$EodSummariesTableUpdateCompanionBuilder =
    EodSummariesCompanion Function({
      Value<int> ID,
      Value<String> BusinessDate,
      Value<int> TransactionCount,
      Value<int> SoldUnitCount,
      Value<int> TotalSalesInCents,
      Value<DateTime> CreatedAt,
      Value<DateTime> UpdatedAt,
    });

final class $$EodSummariesTableReferences
    extends BaseReferences<_$AppDatabase, $EodSummariesTable, EodSummary> {
  $$EodSummariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EodSummaryItemsTable, List<EodSummaryItem>>
  _eodSummaryItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eodSummaryItems,
    aliasName: 'eod_summaries__id__eod_summary_items__eod_summary_i_d',
  );

  $$EodSummaryItemsTableProcessedTableManager get eodSummaryItemsRefs {
    final manager = $$EodSummaryItemsTableTableManager(
      $_db,
      $_db.eodSummaryItems,
    ).filter((f) => f.EodSummaryID.ID.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eodSummaryItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EodSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $EodSummariesTable> {
  $$EodSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get TransactionCount => $composableBuilder(
    column: $table.TransactionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get SoldUnitCount => $composableBuilder(
    column: $table.SoldUnitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get TotalSalesInCents => $composableBuilder(
    column: $table.TotalSalesInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get UpdatedAt => $composableBuilder(
    column: $table.UpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eodSummaryItemsRefs(
    Expression<bool> Function($$EodSummaryItemsTableFilterComposer f) f,
  ) {
    final $$EodSummaryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.eodSummaryItems,
      getReferencedColumn: (t) => t.EodSummaryID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummaryItemsTableFilterComposer(
            $db: $db,
            $table: $db.eodSummaryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EodSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $EodSummariesTable> {
  $$EodSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get TransactionCount => $composableBuilder(
    column: $table.TransactionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get SoldUnitCount => $composableBuilder(
    column: $table.SoldUnitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get TotalSalesInCents => $composableBuilder(
    column: $table.TotalSalesInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get CreatedAt => $composableBuilder(
    column: $table.CreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get UpdatedAt => $composableBuilder(
    column: $table.UpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EodSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EodSummariesTable> {
  $$EodSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get BusinessDate => $composableBuilder(
    column: $table.BusinessDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get TransactionCount => $composableBuilder(
    column: $table.TransactionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get SoldUnitCount => $composableBuilder(
    column: $table.SoldUnitCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get TotalSalesInCents => $composableBuilder(
    column: $table.TotalSalesInCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get CreatedAt =>
      $composableBuilder(column: $table.CreatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get UpdatedAt =>
      $composableBuilder(column: $table.UpdatedAt, builder: (column) => column);

  Expression<T> eodSummaryItemsRefs<T extends Object>(
    Expression<T> Function($$EodSummaryItemsTableAnnotationComposer a) f,
  ) {
    final $$EodSummaryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ID,
      referencedTable: $db.eodSummaryItems,
      getReferencedColumn: (t) => t.EodSummaryID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummaryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.eodSummaryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EodSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EodSummariesTable,
          EodSummary,
          $$EodSummariesTableFilterComposer,
          $$EodSummariesTableOrderingComposer,
          $$EodSummariesTableAnnotationComposer,
          $$EodSummariesTableCreateCompanionBuilder,
          $$EodSummariesTableUpdateCompanionBuilder,
          (EodSummary, $$EodSummariesTableReferences),
          EodSummary,
          PrefetchHooks Function({bool eodSummaryItemsRefs})
        > {
  $$EodSummariesTableTableManager(_$AppDatabase db, $EodSummariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EodSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EodSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EodSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String> BusinessDate = const Value.absent(),
                Value<int> TransactionCount = const Value.absent(),
                Value<int> SoldUnitCount = const Value.absent(),
                Value<int> TotalSalesInCents = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
                Value<DateTime> UpdatedAt = const Value.absent(),
              }) => EodSummariesCompanion(
                ID: ID,
                BusinessDate: BusinessDate,
                TransactionCount: TransactionCount,
                SoldUnitCount: SoldUnitCount,
                TotalSalesInCents: TotalSalesInCents,
                CreatedAt: CreatedAt,
                UpdatedAt: UpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String BusinessDate,
                Value<int> TransactionCount = const Value.absent(),
                Value<int> SoldUnitCount = const Value.absent(),
                Value<int> TotalSalesInCents = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
                Value<DateTime> UpdatedAt = const Value.absent(),
              }) => EodSummariesCompanion.insert(
                ID: ID,
                BusinessDate: BusinessDate,
                TransactionCount: TransactionCount,
                SoldUnitCount: SoldUnitCount,
                TotalSalesInCents: TotalSalesInCents,
                CreatedAt: CreatedAt,
                UpdatedAt: UpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EodSummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eodSummaryItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eodSummaryItemsRefs) db.eodSummaryItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eodSummaryItemsRefs)
                    await $_getPrefetchedData<
                      EodSummary,
                      $EodSummariesTable,
                      EodSummaryItem
                    >(
                      currentTable: table,
                      referencedTable: $$EodSummariesTableReferences
                          ._eodSummaryItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EodSummariesTableReferences(
                            db,
                            table,
                            p0,
                          ).eodSummaryItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.EodSummaryID == item.ID,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EodSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EodSummariesTable,
      EodSummary,
      $$EodSummariesTableFilterComposer,
      $$EodSummariesTableOrderingComposer,
      $$EodSummariesTableAnnotationComposer,
      $$EodSummariesTableCreateCompanionBuilder,
      $$EodSummariesTableUpdateCompanionBuilder,
      (EodSummary, $$EodSummariesTableReferences),
      EodSummary,
      PrefetchHooks Function({bool eodSummaryItemsRefs})
    >;
typedef $$EodSummaryItemsTableCreateCompanionBuilder =
    EodSummaryItemsCompanion Function({
      Value<int> ID,
      required int EodSummaryID,
      required int ProductVariantID,
      required String ProductNameSnapshot,
      required String UnitSnapshot,
      required int UnitPriceInCents,
      required int SoldUnits,
      required int SoldTotalInCents,
    });
typedef $$EodSummaryItemsTableUpdateCompanionBuilder =
    EodSummaryItemsCompanion Function({
      Value<int> ID,
      Value<int> EodSummaryID,
      Value<int> ProductVariantID,
      Value<String> ProductNameSnapshot,
      Value<String> UnitSnapshot,
      Value<int> UnitPriceInCents,
      Value<int> SoldUnits,
      Value<int> SoldTotalInCents,
    });

final class $$EodSummaryItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $EodSummaryItemsTable, EodSummaryItem> {
  $$EodSummaryItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EodSummariesTable _EodSummaryIDTable(_$AppDatabase db) => db
      .eodSummaries
      .createAlias('eod_summary_items__eod_summary_i_d__eod_summaries__id');

  $$EodSummariesTableProcessedTableManager get EodSummaryID {
    final $_column = $_itemColumn<int>('eod_summary_i_d')!;

    final manager = $$EodSummariesTableTableManager(
      $_db,
      $_db.eodSummaries,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_EodSummaryIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductVariantsTable _ProductVariantIDTable(_$AppDatabase db) =>
      db.productVariants.createAlias(
        'eod_summary_items__product_variant_i_d__product_variants__id',
      );

  $$ProductVariantsTableProcessedTableManager get ProductVariantID {
    final $_column = $_itemColumn<int>('product_variant_i_d')!;

    final manager = $$ProductVariantsTableTableManager(
      $_db,
      $_db.productVariants,
    ).filter((f) => f.ID.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ProductVariantIDTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EodSummaryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $EodSummaryItemsTable> {
  $$EodSummaryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get SoldUnits => $composableBuilder(
    column: $table.SoldUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get SoldTotalInCents => $composableBuilder(
    column: $table.SoldTotalInCents,
    builder: (column) => ColumnFilters(column),
  );

  $$EodSummariesTableFilterComposer get EodSummaryID {
    final $$EodSummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.EodSummaryID,
      referencedTable: $db.eodSummaries,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummariesTableFilterComposer(
            $db: $db,
            $table: $db.eodSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableFilterComposer get ProductVariantID {
    final $$ProductVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableFilterComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EodSummaryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $EodSummaryItemsTable> {
  $$EodSummaryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get SoldUnits => $composableBuilder(
    column: $table.SoldUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get SoldTotalInCents => $composableBuilder(
    column: $table.SoldTotalInCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$EodSummariesTableOrderingComposer get EodSummaryID {
    final $$EodSummariesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.EodSummaryID,
      referencedTable: $db.eodSummaries,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummariesTableOrderingComposer(
            $db: $db,
            $table: $db.eodSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableOrderingComposer get ProductVariantID {
    final $$ProductVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EodSummaryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EodSummaryItemsTable> {
  $$EodSummaryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get ProductNameSnapshot => $composableBuilder(
    column: $table.ProductNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get UnitSnapshot => $composableBuilder(
    column: $table.UnitSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get UnitPriceInCents => $composableBuilder(
    column: $table.UnitPriceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get SoldUnits =>
      $composableBuilder(column: $table.SoldUnits, builder: (column) => column);

  GeneratedColumn<int> get SoldTotalInCents => $composableBuilder(
    column: $table.SoldTotalInCents,
    builder: (column) => column,
  );

  $$EodSummariesTableAnnotationComposer get EodSummaryID {
    final $$EodSummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.EodSummaryID,
      referencedTable: $db.eodSummaries,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EodSummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.eodSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductVariantsTableAnnotationComposer get ProductVariantID {
    final $$ProductVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ProductVariantID,
      referencedTable: $db.productVariants,
      getReferencedColumn: (t) => t.ID,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.productVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EodSummaryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EodSummaryItemsTable,
          EodSummaryItem,
          $$EodSummaryItemsTableFilterComposer,
          $$EodSummaryItemsTableOrderingComposer,
          $$EodSummaryItemsTableAnnotationComposer,
          $$EodSummaryItemsTableCreateCompanionBuilder,
          $$EodSummaryItemsTableUpdateCompanionBuilder,
          (EodSummaryItem, $$EodSummaryItemsTableReferences),
          EodSummaryItem,
          PrefetchHooks Function({bool EodSummaryID, bool ProductVariantID})
        > {
  $$EodSummaryItemsTableTableManager(
    _$AppDatabase db,
    $EodSummaryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EodSummaryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EodSummaryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EodSummaryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<int> EodSummaryID = const Value.absent(),
                Value<int> ProductVariantID = const Value.absent(),
                Value<String> ProductNameSnapshot = const Value.absent(),
                Value<String> UnitSnapshot = const Value.absent(),
                Value<int> UnitPriceInCents = const Value.absent(),
                Value<int> SoldUnits = const Value.absent(),
                Value<int> SoldTotalInCents = const Value.absent(),
              }) => EodSummaryItemsCompanion(
                ID: ID,
                EodSummaryID: EodSummaryID,
                ProductVariantID: ProductVariantID,
                ProductNameSnapshot: ProductNameSnapshot,
                UnitSnapshot: UnitSnapshot,
                UnitPriceInCents: UnitPriceInCents,
                SoldUnits: SoldUnits,
                SoldTotalInCents: SoldTotalInCents,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required int EodSummaryID,
                required int ProductVariantID,
                required String ProductNameSnapshot,
                required String UnitSnapshot,
                required int UnitPriceInCents,
                required int SoldUnits,
                required int SoldTotalInCents,
              }) => EodSummaryItemsCompanion.insert(
                ID: ID,
                EodSummaryID: EodSummaryID,
                ProductVariantID: ProductVariantID,
                ProductNameSnapshot: ProductNameSnapshot,
                UnitSnapshot: UnitSnapshot,
                UnitPriceInCents: UnitPriceInCents,
                SoldUnits: SoldUnits,
                SoldTotalInCents: SoldTotalInCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EodSummaryItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({EodSummaryID = false, ProductVariantID = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (EodSummaryID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.EodSummaryID,
                                referencedTable:
                                    $$EodSummaryItemsTableReferences._EodSummaryIDTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$EodSummaryItemsTableReferences._EodSummaryIDTable(
                                      db,
                                    ).ID,
                              )
                              as T;
                    }
                    if (ProductVariantID) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ProductVariantID,
                                referencedTable:
                                    $$EodSummaryItemsTableReferences._ProductVariantIDTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$EodSummaryItemsTableReferences._ProductVariantIDTable(
                                      db,
                                    ).ID,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EodSummaryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EodSummaryItemsTable,
      EodSummaryItem,
      $$EodSummaryItemsTableFilterComposer,
      $$EodSummaryItemsTableOrderingComposer,
      $$EodSummaryItemsTableAnnotationComposer,
      $$EodSummaryItemsTableCreateCompanionBuilder,
      $$EodSummaryItemsTableUpdateCompanionBuilder,
      (EodSummaryItem, $$EodSummaryItemsTableReferences),
      EodSummaryItem,
      PrefetchHooks Function({bool EodSummaryID, bool ProductVariantID})
    >;
typedef $$StoreSettingsTableCreateCompanionBuilder =
    StoreSettingsCompanion Function({
      Value<int> ID,
      required String StoreName,
      required String Address,
      Value<String?> ContactNumber,
      Value<String?> ReceiptFooter,
    });
typedef $$StoreSettingsTableUpdateCompanionBuilder =
    StoreSettingsCompanion Function({
      Value<int> ID,
      Value<String> StoreName,
      Value<String> Address,
      Value<String?> ContactNumber,
      Value<String?> ReceiptFooter,
    });

class $$StoreSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $StoreSettingsTable> {
  $$StoreSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get StoreName => $composableBuilder(
    column: $table.StoreName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get Address => $composableBuilder(
    column: $table.Address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ContactNumber => $composableBuilder(
    column: $table.ContactNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ReceiptFooter => $composableBuilder(
    column: $table.ReceiptFooter,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoreSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoreSettingsTable> {
  $$StoreSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get StoreName => $composableBuilder(
    column: $table.StoreName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get Address => $composableBuilder(
    column: $table.Address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ContactNumber => $composableBuilder(
    column: $table.ContactNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ReceiptFooter => $composableBuilder(
    column: $table.ReceiptFooter,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoreSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoreSettingsTable> {
  $$StoreSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get StoreName =>
      $composableBuilder(column: $table.StoreName, builder: (column) => column);

  GeneratedColumn<String> get Address =>
      $composableBuilder(column: $table.Address, builder: (column) => column);

  GeneratedColumn<String> get ContactNumber => $composableBuilder(
    column: $table.ContactNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ReceiptFooter => $composableBuilder(
    column: $table.ReceiptFooter,
    builder: (column) => column,
  );
}

class $$StoreSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoreSettingsTable,
          StoreSetting,
          $$StoreSettingsTableFilterComposer,
          $$StoreSettingsTableOrderingComposer,
          $$StoreSettingsTableAnnotationComposer,
          $$StoreSettingsTableCreateCompanionBuilder,
          $$StoreSettingsTableUpdateCompanionBuilder,
          (
            StoreSetting,
            BaseReferences<_$AppDatabase, $StoreSettingsTable, StoreSetting>,
          ),
          StoreSetting,
          PrefetchHooks Function()
        > {
  $$StoreSettingsTableTableManager(_$AppDatabase db, $StoreSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String> StoreName = const Value.absent(),
                Value<String> Address = const Value.absent(),
                Value<String?> ContactNumber = const Value.absent(),
                Value<String?> ReceiptFooter = const Value.absent(),
              }) => StoreSettingsCompanion(
                ID: ID,
                StoreName: StoreName,
                Address: Address,
                ContactNumber: ContactNumber,
                ReceiptFooter: ReceiptFooter,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String StoreName,
                required String Address,
                Value<String?> ContactNumber = const Value.absent(),
                Value<String?> ReceiptFooter = const Value.absent(),
              }) => StoreSettingsCompanion.insert(
                ID: ID,
                StoreName: StoreName,
                Address: Address,
                ContactNumber: ContactNumber,
                ReceiptFooter: ReceiptFooter,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoreSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoreSettingsTable,
      StoreSetting,
      $$StoreSettingsTableFilterComposer,
      $$StoreSettingsTableOrderingComposer,
      $$StoreSettingsTableAnnotationComposer,
      $$StoreSettingsTableCreateCompanionBuilder,
      $$StoreSettingsTableUpdateCompanionBuilder,
      (
        StoreSetting,
        BaseReferences<_$AppDatabase, $StoreSettingsTable, StoreSetting>,
      ),
      StoreSetting,
      PrefetchHooks Function()
    >;
typedef $$CloudSyncSettingsTableCreateCompanionBuilder =
    CloudSyncSettingsCompanion Function({
      Value<int> ID,
      Value<String?> RootFolderID,
      required String TransactionLogsFolderID,
      required String EodLogsFolderID,
      Value<String> InstallationID,
      Value<String?> FolderOwnerEmail,
      Value<String> ProvisioningStatus,
      Value<bool> IsAppOwned,
      Value<DateTime?> LastValidatedAt,
      Value<DateTime> UpdatedAt,
    });
typedef $$CloudSyncSettingsTableUpdateCompanionBuilder =
    CloudSyncSettingsCompanion Function({
      Value<int> ID,
      Value<String?> RootFolderID,
      Value<String> TransactionLogsFolderID,
      Value<String> EodLogsFolderID,
      Value<String> InstallationID,
      Value<String?> FolderOwnerEmail,
      Value<String> ProvisioningStatus,
      Value<bool> IsAppOwned,
      Value<DateTime?> LastValidatedAt,
      Value<DateTime> UpdatedAt,
    });

class $$CloudSyncSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $CloudSyncSettingsTable> {
  $$CloudSyncSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get RootFolderID => $composableBuilder(
    column: $table.RootFolderID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get InstallationID => $composableBuilder(
    column: $table.InstallationID,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get FolderOwnerEmail => $composableBuilder(
    column: $table.FolderOwnerEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ProvisioningStatus => $composableBuilder(
    column: $table.ProvisioningStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get IsAppOwned => $composableBuilder(
    column: $table.IsAppOwned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get LastValidatedAt => $composableBuilder(
    column: $table.LastValidatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get UpdatedAt => $composableBuilder(
    column: $table.UpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CloudSyncSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CloudSyncSettingsTable> {
  $$CloudSyncSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ID => $composableBuilder(
    column: $table.ID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get RootFolderID => $composableBuilder(
    column: $table.RootFolderID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get InstallationID => $composableBuilder(
    column: $table.InstallationID,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get FolderOwnerEmail => $composableBuilder(
    column: $table.FolderOwnerEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ProvisioningStatus => $composableBuilder(
    column: $table.ProvisioningStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get IsAppOwned => $composableBuilder(
    column: $table.IsAppOwned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get LastValidatedAt => $composableBuilder(
    column: $table.LastValidatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get UpdatedAt => $composableBuilder(
    column: $table.UpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CloudSyncSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CloudSyncSettingsTable> {
  $$CloudSyncSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ID =>
      $composableBuilder(column: $table.ID, builder: (column) => column);

  GeneratedColumn<String> get RootFolderID => $composableBuilder(
    column: $table.RootFolderID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get TransactionLogsFolderID => $composableBuilder(
    column: $table.TransactionLogsFolderID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get EodLogsFolderID => $composableBuilder(
    column: $table.EodLogsFolderID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get InstallationID => $composableBuilder(
    column: $table.InstallationID,
    builder: (column) => column,
  );

  GeneratedColumn<String> get FolderOwnerEmail => $composableBuilder(
    column: $table.FolderOwnerEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ProvisioningStatus => $composableBuilder(
    column: $table.ProvisioningStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get IsAppOwned => $composableBuilder(
    column: $table.IsAppOwned,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get LastValidatedAt => $composableBuilder(
    column: $table.LastValidatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get UpdatedAt =>
      $composableBuilder(column: $table.UpdatedAt, builder: (column) => column);
}

class $$CloudSyncSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CloudSyncSettingsTable,
          CloudSyncSetting,
          $$CloudSyncSettingsTableFilterComposer,
          $$CloudSyncSettingsTableOrderingComposer,
          $$CloudSyncSettingsTableAnnotationComposer,
          $$CloudSyncSettingsTableCreateCompanionBuilder,
          $$CloudSyncSettingsTableUpdateCompanionBuilder,
          (
            CloudSyncSetting,
            BaseReferences<
              _$AppDatabase,
              $CloudSyncSettingsTable,
              CloudSyncSetting
            >,
          ),
          CloudSyncSetting,
          PrefetchHooks Function()
        > {
  $$CloudSyncSettingsTableTableManager(
    _$AppDatabase db,
    $CloudSyncSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CloudSyncSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CloudSyncSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CloudSyncSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String?> RootFolderID = const Value.absent(),
                Value<String> TransactionLogsFolderID = const Value.absent(),
                Value<String> EodLogsFolderID = const Value.absent(),
                Value<String> InstallationID = const Value.absent(),
                Value<String?> FolderOwnerEmail = const Value.absent(),
                Value<String> ProvisioningStatus = const Value.absent(),
                Value<bool> IsAppOwned = const Value.absent(),
                Value<DateTime?> LastValidatedAt = const Value.absent(),
                Value<DateTime> UpdatedAt = const Value.absent(),
              }) => CloudSyncSettingsCompanion(
                ID: ID,
                RootFolderID: RootFolderID,
                TransactionLogsFolderID: TransactionLogsFolderID,
                EodLogsFolderID: EodLogsFolderID,
                InstallationID: InstallationID,
                FolderOwnerEmail: FolderOwnerEmail,
                ProvisioningStatus: ProvisioningStatus,
                IsAppOwned: IsAppOwned,
                LastValidatedAt: LastValidatedAt,
                UpdatedAt: UpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                Value<String?> RootFolderID = const Value.absent(),
                required String TransactionLogsFolderID,
                required String EodLogsFolderID,
                Value<String> InstallationID = const Value.absent(),
                Value<String?> FolderOwnerEmail = const Value.absent(),
                Value<String> ProvisioningStatus = const Value.absent(),
                Value<bool> IsAppOwned = const Value.absent(),
                Value<DateTime?> LastValidatedAt = const Value.absent(),
                Value<DateTime> UpdatedAt = const Value.absent(),
              }) => CloudSyncSettingsCompanion.insert(
                ID: ID,
                RootFolderID: RootFolderID,
                TransactionLogsFolderID: TransactionLogsFolderID,
                EodLogsFolderID: EodLogsFolderID,
                InstallationID: InstallationID,
                FolderOwnerEmail: FolderOwnerEmail,
                ProvisioningStatus: ProvisioningStatus,
                IsAppOwned: IsAppOwned,
                LastValidatedAt: LastValidatedAt,
                UpdatedAt: UpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CloudSyncSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CloudSyncSettingsTable,
      CloudSyncSetting,
      $$CloudSyncSettingsTableFilterComposer,
      $$CloudSyncSettingsTableOrderingComposer,
      $$CloudSyncSettingsTableAnnotationComposer,
      $$CloudSyncSettingsTableCreateCompanionBuilder,
      $$CloudSyncSettingsTableUpdateCompanionBuilder,
      (
        CloudSyncSetting,
        BaseReferences<
          _$AppDatabase,
          $CloudSyncSettingsTable,
          CloudSyncSetting
        >,
      ),
      CloudSyncSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductVariantsTableTableManager get productVariants =>
      $$ProductVariantsTableTableManager(_db, _db.productVariants);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
  $$TransactionPrintJobsTableTableManager get transactionPrintJobs =>
      $$TransactionPrintJobsTableTableManager(_db, _db.transactionPrintJobs);
  $$TransactionSyncBatchesTableTableManager get transactionSyncBatches =>
      $$TransactionSyncBatchesTableTableManager(
        _db,
        _db.transactionSyncBatches,
      );
  $$EodSummariesTableTableManager get eodSummaries =>
      $$EodSummariesTableTableManager(_db, _db.eodSummaries);
  $$EodSummaryItemsTableTableManager get eodSummaryItems =>
      $$EodSummaryItemsTableTableManager(_db, _db.eodSummaryItems);
  $$StoreSettingsTableTableManager get storeSettings =>
      $$StoreSettingsTableTableManager(_db, _db.storeSettings);
  $$CloudSyncSettingsTableTableManager get cloudSyncSettings =>
      $$CloudSyncSettingsTableTableManager(_db, _db.cloudSyncSettings);
}
