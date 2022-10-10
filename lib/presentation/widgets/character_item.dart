import 'package:breaking_bad/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../constants/app_router.dart';
import '../../data/models/characters.dart';

class CharacterItem extends StatelessWidget {
  final Character character;
  const CharacterItem({Key? key, required this.character}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: const EdgeInsetsDirectional.all(4.0),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: ()=>Navigator.pushNamed(context, Routes.characterDetailRoute,arguments: character),
        child: GridTile(
          footer: Hero(
            tag: character.charId!,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.black54,
              alignment: Alignment.bottomCenter,
              child: Text(
                '${character.name}',
                style: const TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColor.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          child: Container(
            color: MyColor.grey,
            child: character.img!.isNotEmpty
                ? FadeInImage.assetNetwork(
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: 'assets/images/loading.gif',
                    image: character.img!,
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/image/placeholder.png'),
          ),
        ),
      ),
    );
  }
}
