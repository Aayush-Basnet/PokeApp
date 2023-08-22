import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapp/pokedetail.dart';
import 'package:pokeapp/pokemon.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: "Poke App",
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    ));

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ScrollController _scrollController = ScrollController();
  var url = Uri.parse(
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json");

  late PokeHub pokeHub = PokeHub(pokemon: []);
  TextEditingController searchController = TextEditingController();
  List<Pokemon>? filteredPokemonList;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    // print(pokeHub.toJson());
    filteredPokemonList = pokeHub.pokemon;
    setState(() {});
  }

  void updateFilteredPokemonList(String query) {
    setState(() {
      filteredPokemonList = pokeHub.pokemon
          ?.where((pokemon) =>
              pokemon.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poke App'),
        backgroundColor: Colors.cyan,
        //centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PokemonSearch(filteredPokemonList!),
                );
              },
              icon: Icon(
                Icons.search,
                size: 26,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 26,
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scrollToTop();
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
      body: pokeHub.pokemon == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              children: pokeHub.pokemon!
                  .map((poke) => Padding(
                        padding: EdgeInsets.all(2),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeDetail(
                                          pokemon: poke,
                                        )));
                          },
                          child: Hero(
                            tag: poke.img!,
                            child: Card(
                                elevation: 3.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(poke.img!),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      poke.name!,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class PokemonSearch extends SearchDelegate<Pokemon> {
  final List<Pokemon> pokemonList;
  PokemonSearch(this.pokemonList);
  final Pokemon noPokemonSelected = Pokemon(
      id: -1,
      num: '',
      name: '',
      img: '',
      type: [],
      height: '',
      weight: '',
      candy: '',
      candyCount: 9,
      egg: '',
      spawnChance: '',
      avgSpawns: '',
      spawnTime: '',
      multipliers: [],
      weaknesses: [],
      nextEvolution: []);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, noPokemonSelected);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: pokemonList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pokemonList[index].name!),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PokeDetail(
                            pokemon: pokemonList[index],
                          )));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : pokemonList
            .where((pokemon) =>
                pokemon.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionList[index].name!),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PokeDetail(
                            pokemon: suggestionList[index],
                          )));
            },
          );
        });
  }
}
