part of 'character_creator_bloc.dart';

abstract class CharacterCreatorEvent {}

class SelectRaceEvent extends CharacterCreatorEvent {
  final String race;
  SelectRaceEvent(this.race);
}

class SelectClassEvent extends CharacterCreatorEvent {
  final String characterClass;
  SelectClassEvent(this.characterClass);
}

class ResetSelectionEvent extends CharacterCreatorEvent {}

class DistributeStatsEvent extends CharacterCreatorEvent {
  final Map<String, int> stats;
  DistributeStatsEvent(this.stats);
}

class ResetStatsEvent extends CharacterCreatorEvent {}

class SelectSkillEvent extends CharacterCreatorEvent {
  final String skill;
  final bool isSelected;
  SelectSkillEvent(this.skill, this.isSelected);
}

class ResetSkillsEvent extends CharacterCreatorEvent {}