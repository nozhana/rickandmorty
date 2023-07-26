import 'package:flutter/material.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';
import 'package:rickandmorty/core/resources/views/modal/sheet/selector_sheet.dart';

class StatusBottomSheet extends SelectorSheet<CharacterStatus> {
  final CharacterStatus? selectedStatus;
  StatusBottomSheet({Key? key, required this.selectedStatus})
      : super(
            key: key,
            title: "Choose Status",
            headerIcon: Icons.energy_savings_leaf,
            choices: CharacterStatus.values,
            choiceIcons: [Icons.person, Icons.person_off, Icons.question_mark],
            selected: selectedStatus);
}
