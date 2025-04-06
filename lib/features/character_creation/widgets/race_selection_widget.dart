import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class RaceSelectionWidget extends StatelessWidget {
  final List<String> races = const [
    'Человек',
    'Эльф',
    'Дварф',
    'Полурослик',
    'Драконорожденный'
  ];

  const RaceSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите расу:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: races.map((race) {
                return ChoiceChip(
                  label: Text(race),
                  selected: state.selectedRace == race,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<CharacterCreatorBloc>().add(SelectRaceEvent(race));
                    } else {
                      // Для сброса выбора используем пустую строку или специальное значение
                      context.read<CharacterCreatorBloc>().add(SelectRaceEvent(''));
                    }
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}