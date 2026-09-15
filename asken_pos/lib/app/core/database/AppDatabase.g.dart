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
  final DateTime CreatedAt;
  const Transaction({
    required this.ID,
    required this.ReceiptNumber,
    required this.CashierName,
    required this.TotalInCents,
    required this.Status,
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
      'CreatedAt': serializer.toJson<DateTime>(CreatedAt),
    };
  }

  Transaction copyWith({
    int? ID,
    String? ReceiptNumber,
    String? CashierName,
    int? TotalInCents,
    String? Status,
    DateTime? CreatedAt,
  }) => Transaction(
    ID: ID ?? this.ID,
    ReceiptNumber: ReceiptNumber ?? this.ReceiptNumber,
    CashierName: CashierName ?? this.CashierName,
    TotalInCents: TotalInCents ?? this.TotalInCents,
    Status: Status ?? this.Status,
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
          other.CreatedAt == this.CreatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> ID;
  final Value<String> ReceiptNumber;
  final Value<String> CashierName;
  final Value<int> TotalInCents;
  final Value<String> Status;
  final Value<DateTime> CreatedAt;
  const TransactionsCompanion({
    this.ID = const Value.absent(),
    this.ReceiptNumber = const Value.absent(),
    this.CashierName = const Value.absent(),
    this.TotalInCents = const Value.absent(),
    this.Status = const Value.absent(),
    this.CreatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.ID = const Value.absent(),
    required String ReceiptNumber,
    required String CashierName,
    required int TotalInCents,
    this.Status = const Value.absent(),
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
    Expression<DateTime>? CreatedAt,
  }) {
    return RawValuesInsertable({
      if (ID != null) 'id': ID,
      if (ReceiptNumber != null) 'receipt_number': ReceiptNumber,
      if (CashierName != null) 'cashier_name': CashierName,
      if (TotalInCents != null) 'total_in_cents': TotalInCents,
      if (Status != null) 'status': Status,
      if (CreatedAt != null) 'created_at': CreatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? ID,
    Value<String>? ReceiptNumber,
    Value<String>? CashierName,
    Value<int>? TotalInCents,
    Value<String>? Status,
    Value<DateTime>? CreatedAt,
  }) {
    return TransactionsCompanion(
      ID: ID ?? this.ID,
      ReceiptNumber: ReceiptNumber ?? this.ReceiptNumber,
      CashierName: CashierName ?? this.CashierName,
      TotalInCents: TotalInCents ?? this.TotalInCents,
      Status: Status ?? this.Status,
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
  late final $StoreSettingsTable storeSettings = $StoreSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    productVariants,
    transactions,
    transactionItems,
    storeSettings,
  ];
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
          PrefetchHooks Function({bool ProductID, bool transactionItemsRefs})
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
          prefetchHooksCallback: ({ProductID = false, transactionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems,
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
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
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
      PrefetchHooks Function({bool ProductID, bool transactionItemsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> ID,
      required String ReceiptNumber,
      required String CashierName,
      required int TotalInCents,
      Value<String> Status,
      Value<DateTime> CreatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> ID,
      Value<String> ReceiptNumber,
      Value<String> CashierName,
      Value<int> TotalInCents,
      Value<String> Status,
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
          PrefetchHooks Function({bool transactionItemsRefs})
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
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                ID: ID,
                ReceiptNumber: ReceiptNumber,
                CashierName: CashierName,
                TotalInCents: TotalInCents,
                Status: Status,
                CreatedAt: CreatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> ID = const Value.absent(),
                required String ReceiptNumber,
                required String CashierName,
                required int TotalInCents,
                Value<String> Status = const Value.absent(),
                Value<DateTime> CreatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                ID: ID,
                ReceiptNumber: ReceiptNumber,
                CashierName: CashierName,
                TotalInCents: TotalInCents,
                Status: Status,
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
          prefetchHooksCallback: ({transactionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems,
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
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
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
      PrefetchHooks Function({bool transactionItemsRefs})
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
  $$StoreSettingsTableTableManager get storeSettings =>
      $$StoreSettingsTableTableManager(_db, _db.storeSettings);
}
