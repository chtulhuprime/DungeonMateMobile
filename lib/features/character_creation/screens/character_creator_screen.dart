import 'package:diploma_desktop/features/character_creation/screens/stats_state_distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/character_preview_widget.dart';
import '../widgets/race_selection_widget.dart';
import '../widgets/class_selection_widget.dart';

class CharacterCreatorScreen extends StatelessWidget {
  const CharacterCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание персонажа'),
      ),
      body: BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
        builder: (context, state) {
          return Padding(
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Левая панель - превью (30%)
                      const Expanded(
                        flex: 3,
                        child: CharacterPreviewWidget(),
                      ),

                      const VerticalDivider(width: 24),

                      // Правая панель - выбор (70%)
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              RaceSelectionWidget(),
                              SizedBox(height: 30),
                              ClassSelectionWidget(),
                              SizedBox(height: 40),
                              _NavigationButtons(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
        return Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: state.isComplete
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsDistributionScreen()),
                );
              }
                  : null,
            child: const Text('Далее'),
          ),
        );
      },
    );
  }
}