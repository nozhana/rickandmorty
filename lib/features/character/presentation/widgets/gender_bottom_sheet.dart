import 'package:flutter/material.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';
import 'package:rickandmorty/core/resources/views/modal/sheet/selector_sheet.dart';

class GenderBottomSheet extends SelectorSheet<CharacterGender> {
  final CharacterGender? selectedGender;
  GenderBottomSheet({Key? key, required this.selectedGender})
      : super(
            key: key,
            title: "Choose Gender",
            headerIcon: Icons.transgender,
            choices: CharacterGender.values,
            choiceIcons: [
              Icons.male,
              Icons.female,
              Icons.transgender,
              Icons.question_mark
            ],
            selected: selectedGender);
}
