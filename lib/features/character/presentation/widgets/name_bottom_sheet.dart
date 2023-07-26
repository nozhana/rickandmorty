import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/views/modal/sheet/text_input_sheet.dart';

class NameBottomSheet extends TextInputSheet {
  NameBottomSheet({Key? key, required super.prefilledText})
      : super(
            key: key,
            title: "Enter name",
            headerIcon: Icons.person,
            hintText: "Filter by name");
}
