import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class ManualStatsInputWidget extends StatelessWidget {
  const ManualStatsInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              'Введите значения характеристик:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...state.stats.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: entry.value.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              // Показать информацию о характеристике
                            },
                          ),
                        ),
                        onChanged: (value) {
                          final intValue = int.tryParse(value) ?? 8;
                          final updatedStats = Map<String, int>.from(state.stats)
                            ..[entry.key] = intValue.clamp(8, 20);

                          context.read<CharacterCreatorBloc>().add(
                            DistributeStatsEvent(updatedStats),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
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
            ),
          ],
        );
      },
    );
  }
}