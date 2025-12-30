enum Governorate {
  damascus,
  aleppo,
  homs,
  rifDimashq,
  daraa,
  latakia,
  tartus,
  quneitra,
  deirEzZor,
  hama;

  int get id {
    switch (this) {
      case Governorate.damascus:
        return 1;
      case Governorate.aleppo:
        return 2;
      case Governorate.homs:
        return 3;
      case Governorate.rifDimashq:
        return 4;
      case Governorate.daraa:
        return 5;
      case Governorate.latakia:
        return 6;
      case Governorate.tartus:
        return 7;
      case Governorate.quneitra:
        return 8;
      case Governorate.deirEzZor:
        return 9;
      case Governorate.hama:
        return 10;
    }
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  static Governorate fromId(int id) {
    switch (id) {
      case 1:
        return Governorate.damascus;
      case 2:
        return Governorate.aleppo;
      case 3:
        return Governorate.homs;
      case 4:
        return Governorate.rifDimashq;
      case 5:
        return Governorate.daraa;
      case 6:
        return Governorate.latakia;
      case 7:
        return Governorate.tartus;
      case 8:
        return Governorate.quneitra;
      case 9:
        return Governorate.deirEzZor;
      case 10:
        return Governorate.hama;
      default:
        return Governorate.damascus;
    }
  }
}
