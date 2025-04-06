import 'dart:math';

import 'package:diploma_desktop/features/character_creation/screens/stats_state_distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';
import '../widgets/class_selection_widget.dart';
import '../widgets/race_selection_widget.dart';

class CharacterCreatorScreen extends StatefulWidget {
  const CharacterCreatorScreen({super.key});

  @override
  State<CharacterCreatorScreen> createState() => _CharacterCreatorScreenState();
}

class _CharacterCreatorScreenState extends State<CharacterCreatorScreen> {
  bool _useDragAndDrop = false;
  List<int> _generatedStats = [];
  final Map<String, TextEditingController> _statControllers = {};

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров для ручного ввода
    final stats = ['Сила', 'Ловкость', 'Телосложение', 'Интеллект', 'Мудрость', 'Харизма'];
    for (var stat in stats) {
      _statControllers[stat] = TextEditingController(text: '8');
    }
  }

  @override
  void dispose() {
    // Очистка контроллеров
    for (var controller in _statControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _generateStats() {
    final random = Random();
    setState(() {
      _generatedStats = List.generate(6, (_) => 8 + random.nextInt(7))..sort((a, b) => b.compareTo(a));
      _useDragAndDrop = true;
    });
  }

  void _switchToManualInput() {
    setState(() {
      _useDragAndDrop = false;
    });
  }

  void _applyGeneratedStats() {
    final bloc = context.read<CharacterCreatorBloc>();
    final currentState = bloc.state;
    final newStats = Map<String, int>.from(currentState.stats);

    for (var i = 0; i < _generatedStats.length; i++) {
      final statName = currentState.stats.keys.elementAt(i);
      newStats[statName] = _generatedStats[i];
      _statControllers[statName]?.text = _generatedStats[i].toString();
    }

    bloc.add(DistributeStatsEvent(newStats));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание персонажа'),
      ),
      body: BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Выбор расы и класса
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Основные параметры',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const RaceSelectionWidget(),
                        const SizedBox(height: 16),
                        const ClassSelectionWidget(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Распределение характеристик
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Характеристики',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shuffle),
                                  tooltip: 'Автоматическая генерация',
                                  onPressed: _generateStats,
                                ),
                                // IconButton(
                                //   icon: const Icon(Icons.swap_horiz),
                                //   tooltip: 'Режим Drag&Drop',
                                //   onPressed: () {
                                //     if (_generatedStats.isNotEmpty) {
                                //       setState(() {
                                //         _useDragAndDrop = true;
                                //       });
                                //     }
                                //   },
                                // ),
                                IconButton(
                                  icon: const Icon(Icons.keyboard),
                                  tooltip: 'Ручной ввод',
                                  onPressed: _switchToManualInput,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        if (_useDragAndDrop && _generatedStats.isNotEmpty) ...[
                          const Text('Перетащите значения к характеристикам:'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _generatedStats.map((value) {
                              return Draggable<int>(
                                data: value,
                                feedback: _buildStatValueCard(value, Colors.blue),
                                child: _buildStatValueCard(value, Colors.blue.shade200),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Отображение характеристик в два столбца
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          children: state.stats.entries.map((entry) {
                            return _buildStatInputField(
                              context,
                              entry.key,
                              entry.value,
                              _useDragAndDrop && _generatedStats.isNotEmpty,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Кнопка завершения
                ElevatedButton(
                  onPressed: state.isComplete ? () => _finishCharacterCreation(context) : null,
                  child: const Text('Завершить создание персонажа'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatInputField(
      BuildContext context,
      String statName,
      int statValue,
      bool isDragTargetMode,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: isDragTargetMode
            ? DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  statValue.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          },
          onAccept: (value) {
            final updatedStats = Map<String, int>.from(
              context.read<CharacterCreatorBloc>().state.stats,
            )..[statName] = value;

            context.read<CharacterCreatorBloc>().add(
              DistributeStatsEvent(updatedStats),
            );

            _statControllers[statName]?.text = value.toString();
          },
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _statControllers[statName],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: (value) {
                final intValue = int.tryParse(value) ?? 8;
                final updatedStats = Map<String, int>.from(
                  context.read<CharacterCreatorBloc>().state.stats,
                )..[statName] = intValue.clamp(8, 20);

                context.read<CharacterCreatorBloc>().add(
                  DistributeStatsEvent(updatedStats),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatValueCard(int value, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  void _finishCharacterCreation(BuildContext context) {
    // Сохранение персонажа и навигация
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Персонаж успешно создан!')),
    );
    Navigator.of(context).pop();
  }
}