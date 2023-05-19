import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/all_products_screen.dart';
import 'package:second_chance/theme.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

enum SortOption { AtoZ, ZtoA }

class _CategoriesScreenState extends State<CategoriesScreen> {
  SortOption _sortOption = SortOption.AtoZ;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Categories',
          style: subTitle,
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: Icon(
              Icons.sort,
              color: blackColor,
            ),
            onSelected: (SortOption option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: SortOption.AtoZ,
                child: Text('Sort A-Z'),
              ),
              PopupMenuItem(
                value: SortOption.ZtoA,
                child: Text('Sort Z-A'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.yellow.shade900,
            ));
          }

          List<QueryDocumentSnapshot> sortedList = snapshot.data!.docs;
          if (_sortOption == SortOption.AtoZ) {
            sortedList.sort((a, b) => a['categoryName']
                .toString()
                .compareTo(b['categoryName'].toString()));
          } else {
            sortedList.sort((a, b) => b['categoryName']
                .toString()
                .compareTo(a['categoryName'].toString()));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 200 / 300,
            ),
            itemCount: sortedList.length,
            itemBuilder: (BuildContext context, int index) {
              final categoryData = sortedList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllProductsScreen(
                        categoryData: categoryData,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          categoryData['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          categoryData['categoryName'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
