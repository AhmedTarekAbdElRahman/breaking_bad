import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad/constants/colors.dart';
import 'package:breaking_bad/controller/characters_cubit.dart';
import 'package:breaking_bad/controller/characters_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/characters.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailScreen({Key? key, required this.character})
      : super(key: key);
  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600.0,
      pinned: true,
      stretch: true,
      backgroundColor: MyColor.grey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickname!,
          style: const TextStyle(
            color: MyColor.white,
          ),
          textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId!,
          child: Image.network(
            character.img!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: title,
              style: const TextStyle(
                color: MyColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          TextSpan(
              text: value,
              style: const TextStyle(
                color: MyColor.white,
                fontSize: 16,
              ))
        ]));
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColor.yellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }
  Widget checkIfQuotesAreLoaded(CharactersState state){
    if(state is QuotesLoadedState){
      return displayRandomQuoteOrEmptySpace(state);
    }else{
      return showLoadingIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state){
    var quotes=(state).quotes;
    if(quotes.length != 0){
      int randomQuoteIndex = Random().nextInt(quotes.length-1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: MyColor.white,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: MyColor.yellow,
                offset: Offset(0,0),
              )
            ]
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote),
            ],
          ),

        ),
      );
    }else{
      return Container();
    }
  }
  Widget showLoadingIndicator(){
    return const Center(
      child: CircularProgressIndicator(
        color: MyColor.yellow,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharacterCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColor.grey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  characterInfo('Job : ', character.occupation!.join(' / ')),
                  buildDivider(315),
                  characterInfo('Appeared in : ', character.category!),
                  buildDivider(250),
                  characterInfo(
                      'Seasons : ', character.appearance!.join(' / ')),
                  buildDivider(280),
                  characterInfo('Status : ', character.status!),
                  buildDivider(300),
                  character.betterCallSaulAppearance!.isEmpty
                      ? Container()
                      : characterInfo('Better Call Saul Season : ',
                          character.betterCallSaulAppearance!.join(' / ')),
                  character.betterCallSaulAppearance!.isEmpty
                      ? Container()
                      : buildDivider(150),
                  characterInfo('Actor/Actress : ', character.name!),
                  buildDivider(300),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<CharacterCubit,CharactersState>(
                      builder: (context,state){
                        return checkIfQuotesAreLoaded(state);
                      }
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 300,
            )
          ]))
        ],
      ),
    );
  }
}
