import 'package:flutter/material.dart';
import 'package:instagramz_flutter/api/models/meal.dart';
import 'package:instagramz_flutter/api/resources/api_method.dart';
import 'package:url_launcher/url_launcher.dart';

class RanndomMealView extends StatefulWidget {
  const RanndomMealView({super.key});

  @override
  State<RanndomMealView> createState() => _RanndomMealViewState();
}

class _RanndomMealViewState extends State<RanndomMealView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random meal for you!'),
      ),
      body: FutureBuilder(
          future: ApiMethod().getRandomMeal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const Text('Nothing for you. Sorry!!!');
            } else {
              final MealModel meal = snapshot.data!;
              final Uri url = Uri.parse(meal.strYoutube);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'Info',
                        ),
                        Tab(
                          text: 'Ingredients',
                        ),
                        Tab(
                          text: 'Cooking',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(meal.strMealThumb)),
                            ),
                            Text(
                              meal.strMeal,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text("Category: ${meal.strCategory}"),
                            Text("From: ${meal.strArea}"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: meal.ingredients.length,
                            itemBuilder: (context, index) => Text(
                                "${meal.ingredients[index]}: ${meal.measures[index]}"),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(meal.strInstructions),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.video_collection),
                                    InkWell(
                                      onTap: () async {
                                        await launchUrl(url);
                                      },
                                      child: const Text(
                                        '   Guide on Youtube',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
