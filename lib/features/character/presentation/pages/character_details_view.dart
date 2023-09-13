import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/features/character/presentation/bloc/character_bloc.dart';
import 'package:rickandmorty/features/character/presentation/widgets/character_details_content_view.dart';
import 'package:rickandmorty/injection_container.dart';

class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({Key? key, required this.characterId})
      : super(key: key);

  final int characterId;

  @override
  State<CharacterDetailsView> createState() => _CharacterDetailsViewState();
}

class _CharacterDetailsViewState extends State<CharacterDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>(
      create: (context) => sl()..add(GetCharacter(id: widget.characterId)),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: CharacterDetailsContentView(characterId: widget.characterId),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Character Details",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
