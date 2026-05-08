import 'package:flutter/material.dart';

class MinecraftTable extends StatelessWidget {
  final String searchQuery;

  const MinecraftTable({super.key, this.searchQuery = ""});
  
  List<Map<String, String>> filterData(List<Map<String, String>> data) {
    if (searchQuery.isEmpty) return data;

    return data.where((item) {
      return item.values
          .join(" ")
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final database = {
      "Armor": [
        {
          "Item": "Helmet",
          "Material": "Iron",
          "Points": "2",
          "Durability": "165",
          "Obtain": "Crafted"
        },
        {
          "Item": "Chestplate",
          "Material": "Diamond",
          "Points": "8",
          "Durability": "528",
          "Obtain": "Crafted"
        },
      ],
      "Weapons": [
        {
          "Weapon": "Sword",
          "Material": "Diamond",
          "Damage": "7",
          "Durability": "1561",
          "Notes": "High durability"
        },
        {
          "Weapon": "Bow",
          "Material": "String/Stick",
          "Damage": "Up to 10",
          "Durability": "384",
          "Notes": "Long range"
        },
      ],
      "Mobs": [
        {
          "Name": "Creeper",
          "Status": "Hostile",
          "Health": "20",
          "Attack": "Explosion",
          "Facts": "Afraid of cats"
        },
      ],
      "Potions": [
        {
          "Potion": "Healing",
          "Effect": "Health",
          "Ingredient": "Melon",
          "Duration": "Instant"
        },
      ]
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          buildSection(
            title: "🛡️ Armor Encyclopedia",
            color: Colors.green,
            data: filterData(database["Armor"]!),
            columns: ["Item", "Material", "Points", "Durability", "Obtain"],
          ),

          buildSection(
            title: "⚔️ Weapons & Combat",
            color: Colors.red,
            data: filterData(database["Weapons"]!),
            columns: ["Weapon", "Material", "Damage", "Durability", "Notes"],
          ),

          buildSection(
            title: "👾 Entity & Mob Database",
            color: Colors.purple,
            data: filterData(database["Mobs"]!),
            columns: ["Name", "Status", "Health", "Attack", "Facts"],
          ),

          buildSection(
            title: "🧪 Potion & Alchemy",
            color: Colors.blue,
            data: filterData(database["Potions"]!),
            columns: ["Potion", "Effect", "Ingredient", "Duration"],
          ),
        ],
      ),
    );
  }

  Widget buildSection({
    required String title,
    required Color color,
    required List<Map<String, String>> data,
    required List<String> columns,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: columns
                  .map((col) => DataColumn(
                        label: Text(
                          col,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),

              rows: data.map((row) {
                return DataRow(
                  cells: columns
                      .map((col) => DataCell(Text(row[col] ?? "")))
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}