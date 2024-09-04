import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

// Define enum for screen sizes
enum ScreenSize { mobile, tablet, web }

// Helper function to determine the screen size type based on the width
ScreenSize getScreenSize(
  double width, {
  VoidCallback? onMobile,
  VoidCallback? onTablet,
  VoidCallback? onWeb,
}) {
  if (width >= 1200) {
    if (onWeb != null) {
      Future.delayed(Duration.zero, onWeb);
    }
    return ScreenSize.web; // Web: >= 1200px
  } else if (width >= 768) {
    if (onTablet != null) {
      Future.delayed(Duration.zero, onTablet);
    }

    return ScreenSize.tablet; // Tablet: >= 768px and < 1200px
  } else {
    if (onMobile != null) {
      Future.delayed(Duration.zero, onMobile);
    }
    return ScreenSize.mobile; // Mobile: < 768px
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layout with Flutter Hooks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResponsiveScreen(),
    );
  }
}

class ResponsiveScreen extends HookWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(isMobile.value
            ? 'Responsive Layout - Mobile'
            : 'Responsive Layout'),
        actions: [
          if (isMobile.value)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.black,
              onPressed: () {
                // Handle cart navigation
              },
            ),
        ],
      ),
      drawer: !isMobile.value
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      // Handle menu navigation
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Cart'),
                    onTap: () {
                      // Handle cart navigation
                    },
                  ),
                ],
              ),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get the current screen size based on the width
          ScreenSize screenSize = getScreenSize(
            constraints.maxWidth,
            onMobile: () {
              isMobile.value = true;
            },
            onTablet: () {
              isMobile.value = false;
            },
            onWeb: () {
              isMobile.value = false;
            },
          );
          log('Screen Size: $screenSize isMobile: ${isMobile.value}');
          switch (screenSize) {
            case ScreenSize.web:
              // Web layout
              return const Row(
                children: [
                  Expanded(flex: 1, child: TabsSection()),
                  Expanded(flex: 3, child: ProductSection()),
                  Expanded(flex: 1, child: CartSection()),
                ],
              );
            case ScreenSize.tablet:
              // Tablet layout
              return const Row(
                children: [
                  Expanded(flex: 1, child: TabsSection()),
                  Expanded(flex: 3, child: ProductSection()),
                ],
              );
            case ScreenSize.mobile:
              // Mobile layout
              return const MobileLayout();
          }
        },
      ),
    );
  }
}

class TabsSection extends StatelessWidget {
  const TabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          ListTile(
            title: const Text('Tab 1'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Tab 2'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Tab 3'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 20, // Example product count
      itemBuilder: (context, index) {
        return Card(
          child: Center(
            child: Text('Product $index'),
          ),
        );
      },
    );
  }
}

class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: const Column(
        children: [
          ListTile(
            title: Text('Cart Item 1'),
          ),
          ListTile(
            title: Text('Cart Item 2'),
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends HookWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // useState hook to manage selected index in the bottom navigation bar
    final selectedIndex = useState(0);

    // List of screens for bottom navigation options
    final widgetOptions = <Widget>[
      const ProductSection(),
      const CartSection(),
    ];

    return Scaffold(
      body: widgetOptions[selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: selectedIndex.value,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          selectedIndex.value = index;
        },
      ),
    );
  }
}
