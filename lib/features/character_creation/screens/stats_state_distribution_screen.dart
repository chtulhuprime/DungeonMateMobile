import 'dart:math';

import 'package:diploma_desktop/features/character_creation/screens/skills_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/character_preview_widget.dart';
import '../widgets/drag_and_drop_stats_widget.dart';
import '../widgets/manual_stats_widget.dart';
import '../widgets/stats_distribution_widget.dart';

class StatsDistributionScreen extends StatefulWidget {
  const StatsDistributionScreen({super.key});

  @override
  State<StatsDistributionScreen> createState() => _StatsDistributionScreenState();
}

class _StatsDistributionScreenState extends State<StatsDistributionScreen> {
  bool _showGeneratedValues = false;
  List<int> _generatedValues = [];

  void _generateStats() {
    final random = Random();
    setState(() {
      _generatedValues = List.generate(6, (_) => 8 + random.nextInt(7))..sort((a, b) => b.compareTo(a));
      _showGeneratedValues = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Распределение характеристик'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
          builder: (context, state) {
            return Column(
              children: [
                // Кнопка генерации
                if (!_showGeneratedValues)
                  ElevatedButton(
                    onPressed: _generateStats,
                    child: const Text('Сгенерировать значения'),
                  ),

                // Сгенерированные значения (Drag)
                if (_showGeneratedValues) ...[
                  const Text(
                    'Перетащите значения к характеристикам:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _generatedValues.map((value) {
                      return Draggable<int>(
                        data: value,
                        feedback: _buildStatValueCard(value, Colors.blue),
                        child: _buildStatValueCard(value, Colors.blue.shade200),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showGeneratedValues = false;
                      });
                    },
                    child: const Text('Вернуться к ручному вводу'),
                  ),
                  const SizedBox(height: 30),
                ],

                // Поля для характеристик (Drop)
                ...state.stats.entries.map((entry) {
                  return DragTarget<int>(
                    builder: (context, candidateData, rejectedData) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              _showGeneratedValues
                                  ? Text(
                                entry.value.toString(),
                                style: const TextStyle(fontSize: 18),
                              )
                                  : TextFormField(
                                initialValue: entry.value.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final intValue = int.tryParse(value) ?? 8;
                                  final updatedStats = Map<String, int>.from(state.stats)
                                    ..[entry.key] = intValue.clamp(8, 20);

                                  context.read<CharacterCreatorBloc>().add(
                                    DistributeStatsEvent(updatedStats),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onAccept: (value) {
                      final updatedStats = Map<String, int>.from(state.stats)
                        ..[entry.key] = value;
                      context.read<CharacterCreatorBloc>().add(
                        DistributeStatsEvent(updatedStats),
                      );
                    },
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatValueCard(int value, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<CharacterCreatorBloc>(context),
                      child: const SkillsSelectionScreen(),
                    ),
                  ),
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