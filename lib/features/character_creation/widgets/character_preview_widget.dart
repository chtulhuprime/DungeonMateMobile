import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class CharacterPreviewWidget extends StatelessWidget {
  const CharacterPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(Icons.person, size: 100),
                const SizedBox(height: 20),
                _buildPreviewItem('Раса', state.selectedRace ?? 'Не выбрана'),
                _buildPreviewItem('Класс', state.selectedClass ?? 'Не выбран'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}