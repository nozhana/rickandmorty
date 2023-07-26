import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/views/modal/sheet/text_input_sheet.dart';

class TypeBottomSheet extends TextInputSheet {
  TypeBottomSheet({Key? key, required super.prefilledText})
      : super(
          key: key,
          title: "Enter type",
          hintText: "Filter by type",
          headerIcon: Icons.type_specimen,
        );
}
