
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_food/CartPages/next_cart_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NextPage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
   const NextPage({Key? key,required this.documentSnapshot}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  var quantity = 1;
  bool favourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body:
      Column(
        children: [
          Expanded(child: Container(
            margin: EdgeInsets.only(top: 20),
            child: CircleAvatar(radius: 110,backgroundImage: NetworkImage(widget.documentSnapshot['image']),backgroundColor: Colors.pink.shade50,),
          )),
          SizedBox(height: 25,),
          Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(widget.documentSnapshot['name'],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    SizedBox(height: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text('Favourite:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      IconButton(
                        icon: favourite ? Icon((Icons.favorite),size:28,color: Colors.pink,):Icon((Icons.favorite_border),size: 28,),
                        onPressed: (){
                          setState(() {
                            favourite =!favourite;
                          });
                          if(favourite == true){
                            FirebaseFirestore.instance.collection("Favourite").doc(FirebaseAuth.instance.currentUser!.uid).collection("userFavourite").doc().set(
                                {
                                  "productId":FirebaseAuth.instance.currentUser!.uid,
                                  "productName":widget.documentSnapshot['name'],
                                  "productImage":widget.documentSnapshot['image'],
                                  "productDesc":widget.documentSnapshot['description'],
                                  "productPrice":widget.documentSnapshot['price']*quantity,
                                  "productQuantity":quantity,
                                });
                          }
                        },
                      ),
                    ],),
                    SizedBox(height: 10,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                setState(() {
                                if(quantity>1){
                                  quantity--;
                                }
                              });
                                }, icon: Icon(Icons.remove_circle,size: 40,color: Colors.pink,)),
                              SizedBox(width: 5,),
                              Text('$quantity',style: TextStyle(fontSize: 19),),
                              SizedBox(width: 3,),
                              IconButton(onPressed: (){setState(() {
                                quantity++;
                              });}, icon: Icon(Icons.add_circle,size: 40,color: Colors.pink,)),
                              SizedBox(width: 100,),
                              Text('\Rs.${widget.documentSnapshot['price'] * quantity}',style: TextStyle(fontSize: 25),),
                            ],),
                        ]),
                    SizedBox(height: 10,),
                    Text('Description:',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    Text(widget.documentSnapshot['description']),
                    SizedBox(height: 60,),
                    Container(
                      height: 45,width: double.infinity, child: ElevatedButton(onPressed: (){
                        FirebaseFirestore.instance.collection("cart").doc(FirebaseAuth.instance.currentUser!.uid).collection("userCart").doc().set(
                            {
                              "productId":FirebaseAuth.instance.currentUser!.uid,
                              "productName":widget.documentSnapshot['name'],
                              "productImage":widget.documentSnapshot['image'],
                              "productDesc":widget.documentSnapshot['description'],
                              "productPrice":widget.documentSnapshot['price']*quantity,
                              "productQuantity":quantity,
                            });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NextCartPage()));
                    },
                        child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          shape: StadiumBorder(),)
                    ),
                    ),
                  ],),
              ))
        ],
      ),
    );
  }
}
