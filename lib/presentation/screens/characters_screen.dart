import 'package:breaking_bad/constants/colors.dart';
import 'package:breaking_bad/controller/characters_cubit.dart';
import 'package:breaking_bad/controller/characters_state.dart';
import 'package:breaking_bad/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../data/models/characters.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character>? allCharacter;
  List<Character>? searchedForCharacter;
  bool isSearching = false;
  final searchTextController = TextEditingController();

  @override
  void initState(){
    super.initState();
    BlocProvider.of<CharacterCubit>(context).getAllCharacters();
  }

  Widget buildSearchField(){
    return TextField(
      controller: searchTextController,
      cursorColor: MyColor.grey,
      decoration: const InputDecoration(
        hintText: 'find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColor.grey,
          fontSize: 18.0
        ),
      ),
      style: const TextStyle(
          color: MyColor.grey,
          fontSize: 18.0
      ),
      onChanged: (searchedCharacter){
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }
  void addSearchedForItemsToSearchedList(String searchedCharacter){
    searchedForCharacter=allCharacter!.where((character) => character.name!.toLowerCase().startsWith(searchedCharacter)).toList();
    setState(() {

    });
  }
  List<Widget> buildAppBarActions(){
    if(isSearching){
      return[
        IconButton(onPressed: (){
          clearSearch();
          Navigator.pop(context);
        }, icon: const Icon(Icons.clear,color: MyColor.grey,)),
      ];
    }else{
      return[
        IconButton(onPressed: startSearching, icon: const Icon(Icons.search,color: MyColor.grey,))
      ];
    }
  }

  void startSearching(){
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove:stopSearching));
    setState(() {
      isSearching=true;
    });
  }
  void stopSearching(){
    clearSearch();
    setState(() {
      isSearching=false;
    });
  }

  void clearSearch(){
    setState(() {
      searchTextController.clear();
    });
  }

  Widget buildBlocWidget(){
    return BlocBuilder<CharacterCubit,CharactersState>(builder: (context,state){
      if(state is CharactersLoadedState){
        allCharacter=(state).character;
        return buildLoadedListWidgets();
      }else{
        return showLoadingIndicator();
      }
    });
  }

  Widget showLoadingIndicator(){
    return const Center(
      child: CircularProgressIndicator(
        color: MyColor.yellow,
      ),
    );
  }

  Widget buildLoadedListWidgets(){
    return SingleChildScrollView(
      child: Container(
        color: MyColor.grey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList(){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: searchTextController.text.isEmpty?allCharacter!.length:searchedForCharacter!.length,
        itemBuilder: (context,index){
          return  CharacterItem(character:  searchTextController.text.isEmpty? allCharacter![index]:searchedForCharacter![index]);
        }
    );
  }

  Widget buildAppBarTitle(){
    return const Text('Characters',style: TextStyle(
      color: MyColor.grey,
    ),
    );
  }

  Widget buildNoInternetWidget(){
    return Center(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const SizedBox(
                height: 20.0,
              ),
               const Text('Can\'t connect .. check internet',style: TextStyle(fontSize: 22,color: MyColor.grey),),
              Image.asset('assets/images/noInternet.png'),
            ],
          ),
        ),
      ),
    ) ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.yellow,
        title: isSearching?buildSearchField():buildAppBarTitle(),
        leading:isSearching?const BackButton(color: MyColor.grey,):Container() ,
        actions: buildAppBarActions(),
      ),
      body:OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
          ){
            final bool connected = connectivity != ConnectivityResult.none;
            if(connected){
              return buildBlocWidget();
            }else{
              return buildNoInternetWidget();
            }
          },
          child: showLoadingIndicator(),
          ),
    );
  }
}
