part of 'character_creator_bloc.dart';

class CharacterCreatorState {
  final String? selectedRace;
  final String? selectedClass;
  final bool isComplete;
  final Map<String, int> stats;
  final bool isStatsValid;
  final Map<String, int> baseStats;
  final Set<String> selectedSkills;
  final int availableSkillPoints;

  CharacterCreatorState({
    this.selectedRace,
    this.selectedClass,
    this.isComplete = false,
    this.stats = const {
      'Сила': 8,
      'Ловкость': 8,
      'Телосложение': 8,
      'Интеллект': 8,
      'Мудрость': 8,
      'Харизма': 8,
    },
    this.baseStats = const {
      'Сила': 8,
      'Ловкость': 8,
      'Телосложение': 8,
      'Интеллект': 8,
      'Мудрость': 8,
      'Харизма': 8,
    },
    this.isStatsValid = true,
    this.selectedSkills = const {},
    this.availableSkillPoints = 4,
  });

  CharacterCreatorState copyWith({
    String? selectedRace,
    String? selectedClass,
    bool? isComplete,
    Map<String, int>? stats,
    Map<String, int>? baseStats,
    Set<String>? selectedSkills,
    int? availableSkillPoints,
    bool? isStatsValid,
  }) {
    return CharacterCreatorState(
      selectedRace: selectedRace ?? this.selectedRace,
      selectedClass: selectedClass ?? this.selectedClass,
      isComplete: isComplete ?? this.isComplete,
      stats: stats ?? this.stats,
      baseStats: baseStats ?? this.baseStats,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      availableSkillPoints: availableSkillPoints ?? this.availableSkillPoints,
      isStatsValid: isStatsValid ?? this.isStatsValid,
    );
  }
}