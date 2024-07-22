import 'package:flutter/material.dart';
import 'package:good_food/HomePage.dart';
import 'package:good_food/Profile/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_badged/flutter_badge.dart';

class NextCartPage extends StatefulWidget {
  const NextCartPage({Key? key}) : super(key: key);

  @override
  State<NextCartPage> createState() => _NextCartPageState();
}

class _NextCartPageState extends State<NextCartPage> {
  int totalAmount = 0;
  final CollectionReference items = FirebaseFirestore.instance.collection("cart").
  doc(FirebaseAuth.instance.currentUser!.uid).collection("userCart");

  Future<void> _delete(String productId) async {
    await items.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Cart item deleted successfully',
          style: TextStyle(color: Colors.pink, fontSize: 14,),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        padding: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                StreamBuilder(
                  stream: items.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting) {
                      return Text('\Rs.0', style: TextStyle(fontSize: 23));
                    }
                    if (!streamSnapshot.hasData) {
                      return Text('\Rs.0', style: TextStyle(fontSize: 23));
                    }
                    // Reset total amount
                    int newTotalAmount = 0;
                    // Calculate the total amount
                    streamSnapshot.data!.docs.forEach((documentSnapshot) {
                      int price = documentSnapshot['productPrice'];
                      newTotalAmount += price;
                    });
                    totalAmount = newTotalAmount;
                    return Text('\Rs.$totalAmount', style: TextStyle(fontSize: 23));
                  },
                ),
              ],
            ),
            SizedBox(height: 5,),
            Expanded(
              child: Container(
                height: 45, width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Checkout',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.pink,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Cart Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          StreamBuilder(
            stream: items.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Badge(
                  child: Row(
                    children: [
                      Text('0'),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              }
              if (!streamSnapshot.hasData) {
                return Badge(
                  child: Row(
                    children: [
                      Text('0'),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              }
              // Calculate the item count in real-time
              int newItemCount = 0;
              streamSnapshot.data!.docs.forEach((documentSnapshot) {
                newItemCount += 1;
              });
              return Badge(
                child: Row(
                  children: [
                    Text(newItemCount.toString()),
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: items.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  if (streamSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!streamSnapshot.hasData) {
                    // Handle empty cart case
                    return Center(child: Text("Cart is empty."));
                  }
                  // Calculate the total amount and item count
                  streamSnapshot.data!.docs.forEach((documentSnapshot) {
                    int price = documentSnapshot['productPrice'];
                    totalAmount += price;
                  });

                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      int quantity = documentSnapshot['productQuantity'];
                      int price = documentSnapshot['productPrice'];
                      return Column(
                        children: [
                          InkWell(
                            onLongPress: () {
                              setState(() {
                                _delete(documentSnapshot.id);
                              });
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                        bottomLeft: Radius.circular(18),
                                        bottomRight: Radius.circular(18),
                                      ),
                                      color: Colors.deepOrange.shade50,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100, width: 100,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(documentSnapshot['productImage']),
                                            backgroundColor: Colors.pink.shade50,
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        Expanded(
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      documentSnapshot['productName'],
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                                                    ),
                                                    Text(documentSnapshot['productDesc']),
                                                    Text('\Rs.${documentSnapshot['productPrice']}', style: TextStyle(fontSize: 20),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons.remove_circle_outline, size: 30, color: Colors.black,),
                                                        ),
                                                        Text(documentSnapshot['productQuantity'].toString(), style: TextStyle(fontSize: 20),),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons.add_circle_outline, size: 30, color: Colors.black,),
                                                        ),
                                                        SizedBox(width: 35,),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _delete(documentSnapshot.id);
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete_forever, size: 30, color: Colors.pink,),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
