import 'package:breaking_bad/data/models/characters.dart';
import 'package:breaking_bad/data/models/quotes.dart';
import 'package:breaking_bad/data/web_services/characters_web_service.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;
  CharactersRepository(this.charactersWebServices);
  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quotes>> getCharacterQuotes(String charName) async {
    final quotes = await charactersWebServices.getCharacterQuotes(charName);
    return quotes.map((charQuotes) => Quotes.fromJson(charQuotes)).toList();
  }
}
