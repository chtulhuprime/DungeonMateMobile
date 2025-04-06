import 'package:flutter/material.dart';
import 'features/character_creation/screens/character_creator_screen.dart';

void main() {
  runApp(const DungeonMateApp());
}

class DungeonMateApp extends StatelessWidget {
  const DungeonMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DungeonMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _screens = [
    const CharacterCreatorScreen(), // Заменили на конструктор персонажей
    const ScreenContent(title: 'Сценарии', icon: Icons.book),
    const ScreenContent(title: 'Инвентарь', icon: Icons.backpack),
    const ScreenContent(title: 'Карта', icon: Icons.map),
    const ScreenContent(title: 'Бой', icon: Icons.sports_martial_arts),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DungeonMate'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Row(
          children: [
            // Навигационная панель
            Container(
              width: 200, // Фиксированная ширина для десктопа
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: NavigationRail(
                extended: true, // Развернутый вид для десктопа
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.none,
                backgroundColor: Colors.transparent,
                selectedIconTheme: IconThemeData(
                  color: Theme.of(context).colorScheme.primary,
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Персонажи'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.book),
                    label: Text('Сценарии'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.backpack),
                    label: Text('Инвентарь'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.map),
                    label: Text('Карта'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_martial_arts),
                    label: Text('Бой'),
                  ),
                ],
              ),
            ),

            // Основной контент
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenContent extends StatelessWidget {
  final String title;
  final IconData icon;

  const ScreenContent({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}