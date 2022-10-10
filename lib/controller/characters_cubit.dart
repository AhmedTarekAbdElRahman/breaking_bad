import 'package:bloc/bloc.dart';
import 'package:breaking_bad/controller/characters_state.dart';

import '../data/models/characters.dart';
import '../data/repository/characters_repository.dart';

class CharacterCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character>? characters;
  CharacterCubit(this.charactersRepository) : super(CharactersInitialState());

  List<Character>? getAllCharacters(){
    charactersRepository.getAllCharacters().then((characters){
      emit(CharactersLoadedState(characters));
      this.characters=characters;
    });
    return characters;
  }

  void getQuotes(String? charName){
    charactersRepository.getCharacterQuotes(charName!).then((qoutes){
      emit(QuotesLoadedState(qoutes));
    });
  }

}
