import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'character_creator_event.dart';
part 'character_creator_state.dart';

class CharacterCreatorBloc extends Bloc<CharacterCreatorEvent, CharacterCreatorState> {
  CharacterCreatorBloc() : super(CharacterCreatorState()) {
    on<SelectRaceEvent>(_onSelectRace);
    on<SelectClassEvent>(_onSelectClass);
    on<DistributeStatsEvent>(_onDistributeStats);
  }

  void _onSelectRace(SelectRaceEvent event, Emitter<CharacterCreatorState> emit) {
    emit(state.copyWith(
      selectedRace: event.race,
      isComplete: event.race.isNotEmpty && state.selectedClass?.isNotEmpty == true,
    ));
  }

  void _onSelectClass(SelectClassEvent event, Emitter<CharacterCreatorState> emit) {
    emit(state.copyWith(
      selectedClass: event.characterClass,
      isComplete: event.characterClass.isNotEmpty && state.selectedRace?.isNotEmpty == true,
    ));
  }

  void _onResetSelection(ResetSelectionEvent event, Emitter<CharacterCreatorState> emit) {
    emit(CharacterCreatorState());
  }

  void _onDistributeStats(DistributeStatsEvent event, Emitter<CharacterCreatorState> emit) {
    emit(state.copyWith(
      stats: event.stats,
    ));
  }

  void _onResetStats(ResetStatsEvent event, Emitter<CharacterCreatorState> emit) {
    emit(state.copyWith(
      stats: Map.from(state.baseStats),
    ));
  }

  // Добавляем обработчики
  void _onSelectSkill(SelectSkillEvent event, Emitter<CharacterCreatorState> emit) {
    final newSkills = Set<String>.from(state.selectedSkills);

    if (event.isSelected) {
      newSkills.add(event.skill);
    } else {
      newSkills.remove(event.skill);
    }

    emit(state.copyWith(selectedSkills: newSkills));
  }

  void _onResetSkills(ResetSkillsEvent event, Emitter<CharacterCreatorState> emit) {
    emit(state.copyWith(selectedSkills: {}));
  }
}

