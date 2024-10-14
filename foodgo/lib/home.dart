import 'package:flutter/material.dart';
import 'package:foodgo/customize.dart';
import 'package:foodgo/doublepatty.dart';
import 'package:foodgo/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodgo/burger.dart';
import 'package:foodgo/cheese.dart';
import 'package:foodgo/humburger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodGo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const homepage(), // Change to your home page class name
      routes: {
        '/': (context) => const homepage(), // Home route
        // Add other routes here as needed
      },
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String selectedCategory = 'All';
  Set<String> favoriteItems = {};
  int _selectedIndex = 0;
  List<String> categories = ['All', 'Burgers', 'Customize', 'Others'];
  String searchQuery = '';
  List<Map<String, dynamic>> cartItems = [];

  

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoriteItems');
    if (savedFavorites != null) {
      setState(() {
        favoriteItems = savedFavorites.toSet();
      });
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteItems', favoriteItems.toList());
  }

  void _toggleFavorite(String item) {
    setState(() {
      if (favoriteItems.contains(item)) {
        favoriteItems.remove(item);
      } else {
        favoriteItems.add(item);
      }
      _saveFavorites();
    });
  }

void _onItemTapped(int index) {
  switch (index) {
    case 0: // Home
      setState(() {
        _selectedIndex = index;
      });
      break;
    case 1: // Favorites
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritesPage(
            favoriteItems: favoriteItems,
            onItemRemoved: _removeFromFavorites,
          ),
        ),
      );
      
     
      break;
    case 3: // Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>ProfilePage(), // Navigate to Profile Page
        ),
      );
      break;
  }
}


  void _removeFromFavorites(String item) {
    setState(() {
      favoriteItems.remove(item);
      _saveFavorites();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FoodGo',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 0),
              Text(
                'Order your favourite food!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildCategoryCard(category),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodContainer1('Cheeseburger',
                        "Wendy's burger", 'assets/images/container1.png'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildFoodContainer2('Burger', "Veggie burger",
                        'assets/images/container2.png'),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildFoodContainer3('Hamburger', "Chicken burger",
                        'assets/images/container3.png'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildFoodContainer4('Double Patty',
                        "Fried chicken burger", 'assets/images/container4.png'),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 236, 31, 16),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.home_outlined),
                if (_selectedIndex == 0)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.favorite_border_outlined),
                if (_selectedIndex == 1)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.messenger_outline_outlined),
                if (_selectedIndex == 2)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.person_3_outlined),
                if (_selectedIndex == 3)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  // 1st Food Container
  Widget _buildFoodContainer1(String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => cheesepage(),
          ),
        );
      },
      child: _buildFoodCard(title, subtitle, imagePath, 4.9),
    );
  }

  // 2nd Food Container
  Widget _buildFoodContainer2(String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => burgerpage(),
          ),
        );
      },
      child: _buildFoodCard(title, subtitle, imagePath, 4.8),
    );
  }

  // 3rd Food Container
  Widget _buildFoodContainer3(String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => humburger(),
          ),
        );
      },
      child: _buildFoodCard(title, subtitle, imagePath, 4.6),
    );
  }

  // 4th Food Container
  Widget _buildFoodContainer4(String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => doublepatty(),
          ),
        );
      },
      child: _buildFoodCard(title, subtitle, imagePath, 4.5),
    );
  }

  Widget _buildFoodCard(
      String title, String subtitle, String imagePath, double rating) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 130, width: 130),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(
                      rating.toString(),
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
              // Favorite Icon
              IconButton(
                icon: Icon(
                  favoriteItems.contains(title)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favoriteItems.contains(title) ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFavorite(title);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Category Card
  Widget _buildCategoryCard(String category) {
    bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });

        if (category == 'Customize') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => customizepage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// favourite page..........................

class FavoritesPage extends StatefulWidget {
  final Set<String> favoriteItems;
  final Function(String) onItemRemoved;

  const FavoritesPage(
      {Key? key, required this.favoriteItems, required this.onItemRemoved})
      : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: widget.favoriteItems.isEmpty
          ? Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.favoriteItems.length,
              itemBuilder: (context, index) {
                String item = widget.favoriteItems.elementAt(index);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      item,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          widget.favoriteItems.remove(item);
                        });
                        widget.onItemRemoved(item);
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 235, 25, 10),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.home_outlined),
                if (_selectedIndex == 0)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.favorite_border_outlined),
                if (_selectedIndex == 1)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.messenger_outline_outlined),
                if (_selectedIndex == 2)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.person_3_outlined),
                if (_selectedIndex == 3)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}



