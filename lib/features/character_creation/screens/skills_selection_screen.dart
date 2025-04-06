import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/character_preview_widget.dart';
import '../widgets/skills_selection_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/character_preview_widget.dart';

class SkillsSelectionScreen extends StatelessWidget {
  const SkillsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор навыков'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 3,
              child: CharacterPreviewWidget(),
            ),
            const VerticalDivider(width: 24),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  // Ваш виджет выбора навыков
                  SkillsSelectionWidget(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Финализация создания персонажа
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Завершить'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        final isValid = state.selectedSkills.length == state.availableSkillPoints;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: isValid
                  ? () {
                // Финализация создания персонажа
                _finishCharacterCreation(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? Colors.green : Colors.grey,
              ),
              child: const Text('Завершить'),
            ),
          ],
        );
      },
    );
  }

  void _finishCharacterCreation(BuildContext context) {
    // Здесь можно сохранить персонажа
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Персонаж успешно создан!')),
    );

    // Возврат на главный экран
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}