class MealPlan {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String recipe;
  final NutritionInfo nutrition;
  final int prepTime;
  final int cookTime;
  final String difficulty;

  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.recipe,
    required this.nutrition,
    required this.prepTime,
    required this.cookTime,
    required this.difficulty,
  });
}

class NutritionInfo {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });
}

class MealCategory {
  final String name;
  final String icon;
  final List<MealPlan> meals;

  MealCategory({
    required this.name,
    required this.icon,
    required this.meals,
  });
}

// Sample Meal Plans Data
class MealPlansData {
  static List<MealCategory> getBreakfastPlans() {
    return [
      MealCategory(
        name: 'Healthy Breakfast',
        icon: '🌅',
        meals: [
          MealPlan(
            id: 'bf1',
            name: 'Overnight Oats',
            description: 'Creamy and nutritious overnight oats with fruits',
            imageUrl: 'https://images.unsplash.com/photo-1606312619070-d48b4bdc9c2a?w=800',
            ingredients: [
              '1 cup rolled oats',
              '1 cup almond milk',
              '1 banana, sliced',
              '1/2 cup berries',
              '2 tbsp honey',
              '1 tbsp chia seeds',
            ],
            recipe: '1. Mix oats with almond milk and chia seeds\n2. Add honey and stir well\n3. Refrigerate overnight\n4. Top with banana and berries before serving',
            nutrition: NutritionInfo(
              calories: 320,
              protein: 12.5,
              carbs: 58.0,
              fat: 6.2,
              fiber: 10.5,
            ),
            prepTime: 10,
            cookTime: 0,
            difficulty: 'Easy',
          ),
          MealPlan(
            id: 'bf2',
            name: 'Avocado Toast',
            description: 'Classic avocado toast with poached eggs',
            imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=800',
            ingredients: [
              '2 slices whole grain bread',
              '1 ripe avocado',
              '2 eggs',
              'Salt and pepper',
              'Red pepper flakes',
              'Lemon juice',
            ],
            recipe: '1. Toast bread slices\n2. Mash avocado with lemon juice\n3. Poach eggs\n4. Spread avocado on toast\n5. Top with eggs and seasonings',
            nutrition: NutritionInfo(
              calories: 380,
              protein: 18.0,
              carbs: 32.0,
              fat: 22.0,
              fiber: 12.0,
            ),
            prepTime: 5,
            cookTime: 10,
            difficulty: 'Easy',
          ),
          MealPlan(
            id: 'bf3',
            name: 'Greek Yogurt Bowl',
            description: 'Protein-rich Greek yogurt with granola and fruits',
            imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800',
            ingredients: [
              '1 cup Greek yogurt',
              '1/2 cup granola',
              '1/2 cup mixed berries',
              '1 tbsp honey',
              '1/4 cup nuts',
            ],
            recipe: '1. Scoop Greek yogurt into bowl\n2. Top with granola\n3. Add fresh berries\n4. Drizzle with honey\n5. Sprinkle nuts on top',
            nutrition: NutritionInfo(
              calories: 420,
              protein: 25.0,
              carbs: 45.0,
              fat: 15.0,
              fiber: 8.0,
            ),
            prepTime: 5,
            cookTime: 0,
            difficulty: 'Easy',
          ),
        ],
      ),
    ];
  }

  static List<MealCategory> getLunchPlans() {
    return [
      MealCategory(
        name: 'Balanced Lunch',
        icon: '🍽️',
        meals: [
          MealPlan(
            id: 'ln1',
            name: 'Quinoa Salad Bowl',
            description: 'Nutritious quinoa salad with vegetables and chickpeas',
            imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
            ingredients: [
              '1 cup cooked quinoa',
              '1/2 cup chickpeas',
              '1/2 cup cherry tomatoes',
              '1/2 cucumber, diced',
              '1/4 cup feta cheese',
              '2 tbsp olive oil',
              'Lemon juice',
            ],
            recipe: '1. Cook quinoa according to package\n2. Mix quinoa with chickpeas\n3. Add diced vegetables\n4. Crumble feta cheese\n5. Dress with olive oil and lemon',
            nutrition: NutritionInfo(
              calories: 450,
              protein: 18.0,
              carbs: 55.0,
              fat: 18.0,
              fiber: 12.0,
            ),
            prepTime: 15,
            cookTime: 20,
            difficulty: 'Medium',
          ),
          MealPlan(
            id: 'ln2',
            name: 'Grilled Chicken Wrap',
            description: 'Healthy grilled chicken wrap with vegetables',
            imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=800',
            ingredients: [
              '1 whole wheat tortilla',
              '150g grilled chicken',
              'Lettuce',
              'Tomato slices',
              '1/4 avocado',
              '2 tbsp hummus',
            ],
            recipe: '1. Grill chicken and slice\n2. Warm tortilla\n3. Spread hummus\n4. Add chicken and vegetables\n5. Roll tightly',
            nutrition: NutritionInfo(
              calories: 480,
              protein: 35.0,
              carbs: 42.0,
              fat: 18.0,
              fiber: 8.0,
            ),
            prepTime: 10,
            cookTime: 15,
            difficulty: 'Medium',
          ),
        ],
      ),
    ];
  }

  static List<MealCategory> getDinnerPlans() {
    return [
      MealCategory(
        name: 'Healthy Dinner',
        icon: '🌙',
        meals: [
          MealPlan(
            id: 'dn1',
            name: 'Salmon with Vegetables',
            description: 'Baked salmon with roasted vegetables',
            imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
            ingredients: [
              '200g salmon fillet',
              '1 cup broccoli',
              '1 cup sweet potato',
              '2 tbsp olive oil',
              'Garlic',
              'Lemon',
            ],
            recipe: '1. Season salmon with salt and pepper\n2. Roast vegetables with olive oil\n3. Bake salmon at 400°F for 15 min\n4. Serve with lemon wedges',
            nutrition: NutritionInfo(
              calories: 520,
              protein: 38.0,
              carbs: 35.0,
              fat: 22.0,
              fiber: 8.0,
            ),
            prepTime: 15,
            cookTime: 25,
            difficulty: 'Medium',
          ),
          MealPlan(
            id: 'dn2',
            name: 'Vegetable Stir Fry',
            description: 'Colorful vegetable stir fry with tofu',
            imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d29b?w=800',
            ingredients: [
              '200g tofu',
              '1 bell pepper',
              '1 cup broccoli',
              '1 carrot',
              '2 tbsp soy sauce',
              '1 tbsp sesame oil',
            ],
            recipe: '1. Cut tofu and vegetables\n2. Heat oil in pan\n3. Stir fry vegetables\n4. Add tofu and sauce\n5. Cook until tender',
            nutrition: NutritionInfo(
              calories: 380,
              protein: 22.0,
              carbs: 28.0,
              fat: 18.0,
              fiber: 10.0,
            ),
            prepTime: 10,
            cookTime: 15,
            difficulty: 'Easy',
          ),
        ],
      ),
    ];
  }

  static List<MealCategory> getSnacksPlans() {
    return [
      MealCategory(
        name: 'Healthy Snacks',
        icon: '🍎',
        meals: [
          MealPlan(
            id: 'sn1',
            name: 'Apple with Almond Butter',
            description: 'Simple and nutritious snack',
            imageUrl: 'https://images.unsplash.com/photo-1619546813926-a78fa6372cd2?w=800',
            ingredients: [
              '1 apple',
              '2 tbsp almond butter',
            ],
            recipe: '1. Slice apple\n2. Serve with almond butter',
            nutrition: NutritionInfo(
              calories: 220,
              protein: 6.0,
              carbs: 28.0,
              fat: 12.0,
              fiber: 6.0,
            ),
            prepTime: 2,
            cookTime: 0,
            difficulty: 'Easy',
          ),
          MealPlan(
            id: 'sn2',
            name: 'Trail Mix',
            description: 'Homemade trail mix with nuts and dried fruits',
            imageUrl: 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=800',
            ingredients: [
              '1/4 cup almonds',
              '1/4 cup walnuts',
              '1/4 cup dried cranberries',
              '1/4 cup dark chocolate chips',
            ],
            recipe: '1. Mix all ingredients\n2. Store in airtight container',
            nutrition: NutritionInfo(
              calories: 280,
              protein: 8.0,
              carbs: 22.0,
              fat: 18.0,
              fiber: 6.0,
            ),
            prepTime: 5,
            cookTime: 0,
            difficulty: 'Easy',
          ),
        ],
      ),
    ];
  }
}

