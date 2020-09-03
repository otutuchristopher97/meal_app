import 'package:flutter/material.dart';

import './dummy_data.dart';
import './screen/filters_screens.dart';
import './screen/tabs_screen.dart';
import './screen/meal_detail_screen.dart';

import 'screen/category_meals_screen.dart';
import 'screen/categories_screen.dart';
import './models/meal.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((Meal) {
        if (_filters['gluten'] && !Meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !Meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !Meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] && !Meal.isVegetarian) {
          return false;
        }
        return true;
      } ).toList();
    });
  }

void _toggleFavorite(String mealId) {
  final existingIndex =  _favoritedMeals.indexWhere((meal) => meal.id == mealId);
  if(existingIndex >= 0){
    setState(() {
      _favoritedMeals.removeAt(existingIndex);
    });
  } else {
    setState(() {
      _favoritedMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId ),
      );
    });
  }
}

bool _isMealFavorite(String id) {
  return _favoritedMeals.any((meal) => meal.id == id);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
            ),
          bodyText2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1),
            ),
          subtitle1: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      //home: CategoriesScreen(),
      routes: {
        '/': (ctx) => TabScreen(_favoritedMeals),
        CategoryMealScreen.routeName: (ctx) => CategoryMealScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FilterScreen.routeName: (ctx) => FilterScreen(_filters ,_setFilters),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
      //   if(settings.name == '/meal-detail'){
      //     return ...;
      //   } else if (settings.name == '/something-else'){
      //     return ...;
      //   }
      //   return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
      },
      );
    }
}