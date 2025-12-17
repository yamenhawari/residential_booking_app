enum Governorate {
  damascus,
  aleppo,
  homs,
  latakia,
  tartus,
  hama,
  rifDimashq,
  sweida,
  daraa,
  quneitra,
  deirEzZor,
  hasakah,
  raqqa,
  idlib;

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
      case Governorate.sweida:
        return 'Sweida';
      case Governorate.daraa:
        return 'Daraa';
      case Governorate.quneitra:
        return 'Quneitra';
      case Governorate.deirEzZor:
        return 'Deir Ez-Zor';
      case Governorate.hasakah:
        return 'Hasakah';
      case Governorate.raqqa:
        return 'Raqqa';
      case Governorate.idlib:
        return 'Idlib';
    }
  }
}
