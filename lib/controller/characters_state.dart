import 'package:breaking_bad/data/models/characters.dart';

import '../data/models/quotes.dart';

abstract class CharactersState{}

class CharactersInitialState extends CharactersState{}

class CharactersLoadedState extends CharactersState{
  final List<Character> character;
  CharactersLoadedState(this.character);
}

class QuotesLoadedState extends CharactersState{
  final List<Quotes> quotes;
  QuotesLoadedState(this.quotes);
}