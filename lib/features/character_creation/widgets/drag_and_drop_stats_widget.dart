import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class DragAndDropStatsWidget extends StatefulWidget {
  const DragAndDropStatsWidget({super.key});

  @override
  State<DragAndDropStatsWidget> createState() => _DragAndDropStatsWidgetState();
}

class _DragAndDropStatsWidgetState extends State<DragAndDropStatsWidget> {
  final List<int> _availablePoints = [15, 14, 13, 12, 10, 8];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              'Перетащите значения к характеристикам:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Доступные значения для перетаскивания
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availablePoints.map((value) {
                return Draggable<int>(
                  data: value,
                  feedback: _buildStatValueCard(value, Colors.blue),
                  childWhenDragging: _buildStatValueCard(value, Colors.grey),
                  child: _buildStatValueCard(value, Colors.blue.shade200),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Характеристики для назначения значений
            ...state.stats.entries.map((entry) {
              return DragTarget<int>(
                builder: (context, candidateData, rejectedData) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            entry.value.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: _availablePoints.contains(entry.value)
                                  ? Colors.green
                                  : Colors.red,
                            ),
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
        ElevatedButton(
        onPressed: () {
        // Генерация случайных значений
        final randomStats = {
        'Сила': 8 + Random().nextInt(5),
        'Ловкость': 8 + Random().nextInt(5),
        'Телосложение': 8 + Random().nextInt(5),
        'Интеллект': 8 + Random().nextInt(5),
        'Мудрость': 8 + Random().nextInt(5),
        'Харизма': 8 + Random().nextInt(5),
        };
        context.read<CharacterCreatorBloc>().add(
        DistributeStatsEvent(randomStats),
        );
        },
        child: const Text('Сгенерировать случайные значения'),
        ),],
        );
      },
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