import 'package:breaking_bad/constants/strings.dart';
import 'package:breaking_bad/controller/characters_cubit.dart';
import 'package:breaking_bad/data/repository/characters_repository.dart';
import 'package:breaking_bad/data/web_services/characters_web_service.dart';
import 'package:breaking_bad/presentation/screens/characters_screen.dart';
import 'package:breaking_bad/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/characters.dart';
import '../presentation/screens/character_detail.dart';

class Routes{
  static const String splashRoute ="/";
  static const String charactersRoute ="/characters";
  static const String characterDetailRoute ="/characterDetail";

}

class RouteGenerator{
  late CharactersRepository charactersRepository;
  late CharacterCubit characterCubit;
  RouteGenerator(){
    charactersRepository=CharactersRepository(CharactersWebServices());
    characterCubit=CharacterCubit(charactersRepository);
  }
  Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_)=> const SplashView());
      case Routes.charactersRoute:
        return MaterialPageRoute(builder: (_)=> BlocProvider(
            create: (BuildContext context)=>CharacterCubit(charactersRepository),
          child: const CharactersScreen(),
        ),
        );
      case Routes.characterDetailRoute:
        final character = settings.arguments as Character;
        return MaterialPageRoute(builder: (_)=> BlocProvider(
            create:(BuildContext context)=>CharacterCubit(charactersRepository) ,
            child: CharacterDetailScreen(character: character)
        )
        );

      default:
        return unDefinedRoute();
    }
  }
  static Route<dynamic> unDefinedRoute(){
    return MaterialPageRoute(builder: (_)=> Scaffold(
      appBar: AppBar(title: const Text(noRouteFound),),
      body: const Center(child: Text(noRouteFound)),
    ));
  }
}