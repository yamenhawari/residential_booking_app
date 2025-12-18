enum Governorate {
  damascus,
  aleppo,
  homs,
  latakia,
  tartus,
  hama,
  rifDimashq,
  daraa,
  quneitra,
  deirEzZor;

  String get displayName {
    switch (this) {
      case Governorate.damascus:
        return 'Damascus';
      case Governorate.aleppo:
        return 'Aleppo';
      case Governorate.homs:
        return 'Homs';
      case Governorate.latakia:
        return 'Latakia';
      case Governorate.tartus:
        return 'Tartus';
      case Governorate.hama:
        return 'Hama';
      case Governorate.rifDimashq:
        return 'Rif Dimashq';
      case Governorate.daraa:
        return 'Daraa';
      case Governorate.quneitra:
        return 'Quneitra';
      case Governorate.deirEzZor:
        return 'Deir Ez-Zor';
    }
  }
}
