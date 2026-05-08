class Recipe {
  final String id;
  final String name;
  final List<String?> grid;
  final String result;

  Recipe({
    required this.id,
    required this.name,
    required this.grid,
    required this.result,
  });
}

final List<Recipe> recipes = [
  Recipe(
    id: "None",
    name: "None",
    grid: [
      "null", "null", "null",
      "null", "null", "null",
      "null", "null", "null"
    ],
    result: "None",
  ),

  Recipe(
    id: "anvil",
    name: "Anvil",
    grid: [
      "iron", "iron", "iron",
      null, "iron", null,
      "iron", "iron", "iron"
    ],
    result: "anvil",
  ),

  Recipe(
    id: "arrow",
    name: "Arrow",
    grid: [
      null, "flint", null,
      null, "stick", null,
      null, "feather", null
    ],
    result: "arrow",
  ),

  Recipe(
    id: "blast_furnace",
    name: "Blast Furnace",
    grid: [
      "iron", "iron", "iron",
      "iron", "furnace", "iron",
      "smooth_stone", "smooth_stone", "smooth_stone"
    ],
    result: "blast_furnace",
  ),

  Recipe(
    id: "bow",
    name: "Bow",
    grid: [
      "stick", null, "string",
      null, "stick", "string",
      "stick", null, "string"
    ],
    result: "bow",
  ),

  Recipe(
    id: "bookshelf",
    name: "Bookshelf",
    grid: [
      "wood", "wood", "wood",
      "book", "book", "book",
      "wood", "wood", "wood"
    ],
    result: "bookshelf",
  ),

  Recipe(
    id: "bread",
    name: "Bread",
    grid: [
      null, null, null,
      "wheat", "wheat", "wheat",
      null, null, null
    ],
    result: "bread",
  ),

  Recipe(
    id: "bucket",
    name: "Bucket",
    grid: [
      null, null, null,
      "iron", null, "iron",
      null, "iron", null
    ],
    result: "bucket",
  ),

  Recipe(
    id: "crafting_table",
    name: "Crafting Table",
    grid: [
      "wood", "wood", null,
      "wood", "wood", null,
      null, null, null
    ],
    result: "crafting_table",
  ),

  Recipe(
    id: "furnace",
    name: "Furnace",
    grid: [
      "cobble", "cobble", "cobble",
      "cobble", null, "cobble",
      "cobble", "cobble", "cobble"
    ],
    result: "furnace",
  ),

  Recipe(
    id: "torch",
    name: "Torch",
    grid: [
      null, "coal", null,
      null, "stick", null,
      null, null, null
    ],
    result: "torch",
  ),

  Recipe(
    id: "wood_pickaxe",
    name: "Wood Pickaxe",
    grid: [
      "wood", "wood", "wood",
      null, "stick", null,
      null, "stick", null
    ],
    result: "wood_pickaxe",
  ),
];