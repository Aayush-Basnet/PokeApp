import 'package:flutter/material.dart';
import 'package:pokeapp/pokemon.dart';

class PokeDetail extends StatelessWidget {
  late final Pokemon pokemon;

  PokeDetail({required this.pokemon});

  BodyWidget(BuildContext context) => Stack(
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width - 20,
            left: 10.0,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                  ),
                  Text(
                    pokemon.name!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text('Height: ${pokemon.height}'),
                  Text("Weight: ${pokemon.weight}"),
                  Text(
                    'Types',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pokemon.type!
                        .map((t) => FilterChip(
                              label: Text(t),
                              onSelected: (b) {},
                              backgroundColor: Colors.amber,
                            ))
                        .toList(),
                  ),
                  Text(
                    'Weakness',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pokemon.weaknesses!
                        .map((t) => FilterChip(
                            backgroundColor: Colors.red,
                            label: Text(
                              t,
                              style: TextStyle(color: Colors.white),
                            ),
                            onSelected: (b) {}))
                        .toList(),
                  ),
                  Text("Next Evolution",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pokemon.nextEvolution == null
                        ? <Widget>[Text('This is the final form')]
                        : pokemon.nextEvolution!
                            .map((n) => FilterChip(
                                  label: Text(
                                    '${n.name}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onSelected: (b) {},
                                  backgroundColor: Colors.white,
                                ))
                            .toList(),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
                tag: pokemon.img!,
                child: Container(
                  height: 165,
                  width: 165,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(pokemon.img!),
                    fit: BoxFit.cover,
                  )),
                )),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.cyan,
        title: Text(pokemon.name!),
      ),
      body: BodyWidget(context),
    );
  }
}
