import 'package:flutter/material.dart';
import '../data/recipes.dart';

class CraftingPage extends StatefulWidget {
  const CraftingPage({super.key});

  @override
  State<CraftingPage> createState() => _CraftingPageState();
}

class _CraftingPageState extends State<CraftingPage> {
  late Recipe selectedRecipe;

  @override
  void initState() {
    super.initState();

    selectedRecipe = recipes.isNotEmpty
        ? recipes[0]
        : Recipe(
            id: "empty",
            name: "Empty",
            grid: List.filled(9, null),
            result: "",
          );
  }

  Widget slot(String? item) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Text(
        item ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget buildGrid(List<String?> grid) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: grid.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, i) => slot(grid[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
            alignment: Alignment(0, 0.6),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Crafting Simulator",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            /// Crafting Table
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    selectedRecipe.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white.withOpacity(0.8),
                    child: buildGrid(selectedRecipe.grid),
                  ),
                ],
              ),
            ),

            const Text(
              "Inventory",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),

            const SizedBox(height: 10),

            /// Inventory
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.builder(
                  itemCount: recipes.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (context, i) {
                    final recipe = recipes[i];

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        backgroundColor: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRecipe = recipe;
                        });
                      },
                      child: Text(
                        recipe.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}