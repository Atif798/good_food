
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  //......................................................................................
  final CollectionReference items = FirebaseFirestore.instance.collection("Favourite").
  doc(FirebaseAuth.instance.currentUser!.uid).collection("userFavourite");
  //......................................................................................
  Future<void> _delete(String productId) async {
    await items.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content: Text('Favourite deleted successfully',style: TextStyle(
          color: Colors.pink,fontSize: 14,),textAlign: TextAlign.center,)));
  }
  //........................................................................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Page'),
      ),
      body:
      StreamBuilder(
          stream: items.snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.hasData){
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return InkWell(
                      onLongPress: (){setState(() {
                        _delete(documentSnapshot.id);
                      });},
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius:
                        BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18))),
                        margin: EdgeInsets.only(left: 8,right: 8,top: 8),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(18)),
                                color: Colors.deepOrange.shade50,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(children: [
                                Container(
                                  height: 100,width: 100,
                                  child: CircleAvatar(backgroundImage: NetworkImage(documentSnapshot['productImage']),backgroundColor: Colors.pink.shade50,),
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
                                              Text(documentSnapshot['productName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),),
                                              Text(documentSnapshot['productDesc']),
                                              Text('\Rs.${documentSnapshot['productPrice']}',style: TextStyle(fontSize: 20),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.remove_circle_outline,size: 30,color: Colors.black,)),
                                                  Text(documentSnapshot['productQuantity'].toString(),style: TextStyle(fontSize: 20),),
                                                  IconButton(onPressed: (){}, icon: Icon(Icons.add_circle_outline,size: 30,color: Colors.black,)),
                                                  SizedBox(width: 35,),
                                                  IconButton(onPressed: (){setState(() {
                                                    _delete(documentSnapshot.id);
                                                  });}, icon: Icon(Icons.delete_forever,size: 30,color: Colors.pink,)),
                                                ],)
                                            ],),
                                        ),
                                        // IconButton(onPressed: (){setState(() {
                                        //   _delete(documentSnapshot.id);
                                        // });}, icon: Icon(Icons.close))
                                      ],)),
                              ],),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}
