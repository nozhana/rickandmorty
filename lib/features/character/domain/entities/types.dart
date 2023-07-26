enum CharacterGender {
  male,
  female,
  genderless,
  unknown;

  static CharacterGender? fromString(String? value) {
    if (value == null) return null;
    for (CharacterGender element in CharacterGender.values) {
      if (element.name == value.toLowerCase()) {
        return element;
      }
    }
    return null;
  }
}

enum CharacterStatus {
  alive,
  dead,
  unknown;

  static CharacterStatus? fromString(String? value) {
    if (value == null) return null;
    for (CharacterStatus element in CharacterStatus.values) {
      if (element.name == value.toLowerCase()) {
        return element;
      }
    }
    return null;
  }
}
