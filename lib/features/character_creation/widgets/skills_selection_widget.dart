import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class SkillsSelectionWidget extends StatelessWidget {
  final Map<String, String> allSkills = const {
    'Акробатика': 'Ловкость',
    'Анализ': 'Интеллект',
    'Атлетика': 'Сила',
    'Внимание': 'Мудрость',
    'Выживание': 'Мудрость',
    'Запугивание': 'Харизма',
    'История': 'Интеллект',
    'Ловкость рук': 'Ловкость',
    'Магия': 'Интеллект',
    'Медицина': 'Мудрость',
    'Обман': 'Харизма',
    'Природа': 'Интеллект',
    'Проницательность': 'Мудрость',
    'Религия': 'Интеллект',
    'Скрытность': 'Ловкость',
    'Убеждение': 'Харизма',
  };

  const SkillsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Выберите ${state.availableSkillPoints} навыка(ов)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Доступно: ${state.availableSkillPoints - state.selectedSkills.length}',
              style: TextStyle(
                color: (state.availableSkillPoints - state.selectedSkills.length) < 0
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSkillsGrid(context, state),
          ],
        );
      },
    );
  }

  Widget _buildSkillsGrid(BuildContext context, CharacterCreatorState state) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: allSkills.entries.map((entry) {
        final isSelected = state.selectedSkills.contains(entry.key);
        final isDisabled = !isSelected &&
            state.selectedSkills.length >= state.availableSkillPoints;

        return FilterChip(
          label: Text('${entry.key} (${entry.value})'),
          selected: isSelected,
          onSelected: isDisabled ? null : (selected) {
            context.read<CharacterCreatorBloc>().add(
              SelectSkillEvent(entry.key, selected),
            );
          },
          backgroundColor: isDisabled
              ? Colors.grey[300]
              : null,
          selectedColor: Colors.blue[200],
          checkmarkColor: Colors.blue[800],
          labelStyle: TextStyle(
            color: isDisabled ? Colors.grey[600] : null,
          ),
        );
      }).toList(),
    );
  }
}