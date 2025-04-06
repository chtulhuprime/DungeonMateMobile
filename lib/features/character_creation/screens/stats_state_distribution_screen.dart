import 'package:diploma_desktop/features/character_creation/screens/skills_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/character_preview_widget.dart';
import '../widgets/stats_distribution_widget.dart';

class StatsDistributionScreen extends StatelessWidget {
  const StatsDistributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Распределение характеристик'),
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
                 StatsDistributionWidget(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: BlocProvider.of<CharacterCreatorBloc>(context),
                            child: const SkillsSelectionScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Далее'),
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
        int usedPoints = state.stats.values.fold(0, (sum, value) => sum + (value - 8));
        bool isValid = usedPoints <= 27;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SkillsSelectionScreen()),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid ? Colors.green : Colors.grey,
              ),
              child: const Text('Далее'),
            ),
          ],
        );
      },
    );
  }
}