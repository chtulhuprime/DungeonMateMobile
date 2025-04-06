import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class ClassSelectionWidget extends StatelessWidget {
  final List<String> classes = const [
    'Воин',
    'Волшебник',
    'Жрец',
    'Плут',
    'Варвар'
  ];

  const ClassSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Выберите класс:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: classes.map((cls) {
                return ChoiceChip(
                  label: Text(cls),
                  selected: state.selectedClass == cls,
                  onSelected: (selected) {
                    context.read<CharacterCreatorBloc>().add(SelectClassEvent(cls));
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