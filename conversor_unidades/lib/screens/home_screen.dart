import 'package:flutter/material.dart';
import 'package:conversor_unidades/screens/length_converter_screen.dart';
import 'package:conversor_unidades/screens/weight_converter_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedPage == 0
              ? (widget.isDarkMode ? 'Conversor de Longitud' : 'Conversor de Longitud')
              : (widget.isDarkMode ? 'Conversor de Peso' : 'Conversor de Peso'),
        ),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? Colors.lightBlue[900] : Colors.blue.shade300,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                LengthConverterScreen(),
                WeightConverterScreen(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe_left, color: Colors.blue),
                SizedBox(width: 8),
                Text('Desliza para cambiar', style: TextStyle(color: Colors.blue)),
                SizedBox(width: 8),
                Icon(Icons.swipe_right, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Longitud',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'Peso',
          ),
        ],
      ),
    );
  }
}
