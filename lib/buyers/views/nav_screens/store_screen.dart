import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/store_detail_screen.dart';
import 'package:second_chance/theme.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Stream<QuerySnapshot> _vendorsStream =
      FirebaseFirestore.instance.collection('vendors').snapshots();

  String? _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: true,
        elevation: 0,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              _searchValue = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Search Store...',
            labelStyle: TextStyle(
              color: blackColor,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: blackColor,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final searchedData = snapshot.data!.docs.where((element) {
            return element['businessName']
                .toLowerCase()
                .contains(_searchValue?.toLowerCase() ?? '');
          }).toList();

          if (searchedData.isEmpty) {
            return Center(
              child: Text(
                'Searched Store is Not Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: searchedData.length,
            itemBuilder: (context, index) {
              final storeData = searchedData[index];
              final storeImage = storeData['storeImage'];
              return SingleChildScrollView(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return StoreDetailScreen(
                          storeData: storeData,
                        );
                      },
                    ));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(storeData['businessName']),
                      subtitle: Text(storeData['email']),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          storeImage == null || storeImage == ''
                              ? 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'
                              : storeData['storeImage'],
                        ),
                      ),
                    ),
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
