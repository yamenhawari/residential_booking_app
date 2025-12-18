enum ApartmentStatus {
  available,
  rented,
  unavailable;

  // Helper to convert String from Backend -> Enum
  static ApartmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'available':
        return ApartmentStatus.available;
      case 'rented':
        return ApartmentStatus.rented;
      case 'unavailable':
        return ApartmentStatus.unavailable;
      default:
        return ApartmentStatus.unavailable;
    }
  }

  String get toApiString {
    return name;
  }
}
