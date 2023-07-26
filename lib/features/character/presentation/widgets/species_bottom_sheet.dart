import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/views/modal/sheet/text_input_sheet.dart';

class SpeciesBottomSheet extends TextInputSheet {
  SpeciesBottomSheet({Key? key, required super.prefilledText})
      : super(
          key: key,
          title: "Enter species",
          hintText: "Filter by species",
          headerIcon: Icons.account_tree,
        );
}
