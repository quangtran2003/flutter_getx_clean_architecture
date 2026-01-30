enum MenuEnum {
  advice,
  gps,
}

extension MenuEnumExtension on MenuEnum {
  String get label {
    switch (this) {
      case MenuEnum.advice:
        return 'Advice';
      case MenuEnum.gps:
        return 'GPS';
    }
  }

  String icon({required bool isActive}) {
    switch (this) {
      case MenuEnum.advice:
        return isActive
            ? 'assets/images/home-fill.png'
            : 'assets/images/home-line.png';
      case MenuEnum.gps:
        return isActive
            ? 'assets/images/3d-fill.png'
            : 'assets/images/3d-line.png';
    }
  }
}
