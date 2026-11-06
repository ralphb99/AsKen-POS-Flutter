class OwnerAccess {
  OwnerAccess._();

  static const String AccessName = 'OWNER';

  static bool IsOwnerName(String Value) {
    return Value.trim().toUpperCase() == AccessName;
  }
}
