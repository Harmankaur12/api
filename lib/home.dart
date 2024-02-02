import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getapi/model.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<Recipies> fetchRecipes() async {
    final url = Uri.parse("https://dummyjson.com/recipes");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Recipies.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: FutureBuilder(
          future: fetchRecipes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final rescipes = snapshot.data?.recipes;
              return ListView.builder(
                  itemCount: rescipes?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(
                            '${rescipes?[index].image}',height: 200,width: 200,
                          ),
                          ListTile(
                            title: Text('${rescipes?[index].name}'),
                            subtitle: Text(
                                '${rescipes?[index].cuisine} - ${rescipes?[index].difficulty}'),
                            trailing: Text('${rescipes?[index].rating}'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                'Prep Time: ${rescipes?[index].prepTimeMinutes} minutes'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                'Cook Time: ${rescipes?[index].cookTimeMinutes} minutes'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child:
                                Text('Servings: ${rescipes?[index].servings}'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                'Calories per Serving: ${rescipes?[index].caloriesPerServing}'),
                          ),
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}
