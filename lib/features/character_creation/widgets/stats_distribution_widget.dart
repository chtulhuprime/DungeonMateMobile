import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/character_creator_bloc.dart';

class StatsDistributionWidget extends StatefulWidget {
  const StatsDistributionWidget({super.key});

  @override
  State<StatsDistributionWidget> createState() => _StatsDistributionWidgetState();
}

class _StatsDistributionWidgetState extends State<StatsDistributionWidget> {
  final List<String> _availablePoints = List.generate(15, (index) => '●');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              'Распределение характеристик',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStatsGrid(state),
            const SizedBox(height: 30),
            _buildPointsPool(state),
            const SizedBox(height: 20),
            _buildManualInput(),
          ],
        );
      },
    );
  }

  Widget _buildStatsGrid(CharacterCreatorState state) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: state.stats.entries.map((entry) {
        return _buildStatCard(entry.key, entry.value, state);
      }).toList(),
    );
  }

  Widget _buildStatCard(String statName, int value, CharacterCreatorState state) {
    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('$value'),
                    const SizedBox(width: 10),
                    _buildStatControls(statName, value, state),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      onAccept: (points) {
        _updateStat(statName, value + points);
      },
    );
  }

  Widget _buildStatControls(String statName, int value, CharacterCreatorState state) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _updateStat(statName, value - 1),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _updateStat(statName, value + 1),
        ),
      ],
    );
  }

  Widget _buildPointsPool(CharacterCreatorState state) {
    int usedPoints = state.stats.values.fold(0, (sum, value) => sum + (value - 8));
    int remainingPoints = 27 - usedPoints;

    return Column(
      children: [
      Text(
      'Осталось очков: $remainingPoints/27',
      style: TextStyle(
        color: remainingPoints < 0 ? Colors.red : Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 10),
    Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(remainingPoints.clamp(0, 15), (index) {
    return Draggable<int>(
    data: 1,
    feedback: const Icon(Icons.circle, color: Colors.blue, size: 24),
    childWhenDragging: const Icon(Icons.circle_outlined, size: 24),
    child: const Icon(Icons.circle, size: 24),
    );
    },
    ),
    )],
    );
  }

  Widget _buildManualInput() {
    return Column(
      children: [
        const Text('Или введите значения вручную:'),
        const SizedBox(height: 10),
        BlocBuilder<CharacterCreatorBloc, CharacterCreatorState>(
          builder: (context, state) {
            return Column(
              children: state.stats.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(entry.key),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: entry.value.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            int? newValue = int.tryParse(value);
                            if (newValue != null) {
                              _updateStat(entry.key, newValue);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  void _updateStat(String stat, int newValue) {
    context.read<CharacterCreatorBloc>().add(DistributeStatsEvent({
      ...context.read<CharacterCreatorBloc>().state.stats,
      stat: newValue.clamp(8, 15),
    }));
  }
}