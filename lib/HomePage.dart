import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_food/AddFood/add_available.dart';
import 'package:good_food/AddFood/add_slider.dart';
import 'package:good_food/Favourite/favourite_page.dart';
import 'package:good_food/Profile/Signin.dart';
import 'package:good_food/Profile/profile_page.dart';
import 'package:good_food/CartPages/next_cart_page.dart';
import 'package:good_food/CartPages/next_page.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int selecteds =0;
  //..................Controller............................
  final searchFilter = TextEditingController();
  String search = '';
  //..................End Controller.......................
  //..................Delete Function Stream................
  final CollectionReference items = FirebaseFirestore.instance.collection('foodcategories');
  Future<void> _delete(String productId) async {
    await items.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.white,
        content: Text('Product deleted successfully',style: TextStyle(color: Colors.pink),)));
  }
  //................End Delete Function Stream
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        // elevation: 0.0,
        // leading: Icon(Icons.arrow_back),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilter,
                decoration: InputDecoration(
                    hintText: 'Search',hintStyle: TextStyle(color: Colors.pink),
                    prefixIcon: Icon(Icons.search,color: Colors.pink),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                    errorStyle: TextStyle(color: Colors.pink),
                    filled: true, //fillColor: Colors.grey
                    suffixIcon: IconButton(onPressed: (){searchFilter.clear();},
                        icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                ),
              onChanged: (String value){
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 10),
              child: Text('Most Popular:',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)),
        Expanded(
          child: Container(
            child: StreamBuilder(
                stream: items.snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.hasData){
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1,
                        ),
                        shrinkWrap: false,
                        primary: false,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                          String tempTitle = documentSnapshot['name'];
                          if (searchFilter.text.isEmpty){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NextPage(documentSnapshot: documentSnapshot)));
                              },
                              onLongPress: (){
                                _delete(documentSnapshot.id);
                              },
                              child: Card(
                                margin: EdgeInsets.all(10),
                                child: Container(
                                    width: 150,height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange.shade50,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(children: [
                                      SizedBox(height: 5,),
                                      CircleAvatar(radius: 50, backgroundImage: NetworkImage(documentSnapshot['image']),backgroundColor: Colors.pink.shade50,),
                                      SizedBox(height: 3,),
                                      Text(documentSnapshot['name'],style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 3,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Rs.',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
                                          Text(documentSnapshot['price'].toString()),
                                        ],
                                      ),
                                    ],)
                                ),
                              ),
                            );
                          }else if(tempTitle.toString().contains(searchFilter.text.toString())){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NextPage(documentSnapshot: documentSnapshot)));
                              },
                              onLongPress: (){
                                _delete(documentSnapshot.id);
                              },
                              child: Card(
                                margin: EdgeInsets.all(10),
                                child: Container(
                                    width: 150,height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange.shade50,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Column(children: [
                                      SizedBox(height: 5,),
                                      CircleAvatar(radius: 50, backgroundImage: NetworkImage(documentSnapshot['image']),),
                                      SizedBox(height: 3,),
                                      Text(documentSnapshot['name']),
                                      SizedBox(height: 3,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Rs.'),
                                          Text(documentSnapshot['price'].toString()),
                                        ],
                                      ),
                                    ],)
                                ),
                              ),
                            );
                          }else{}
                          return Container();
                        }
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }
            ),
          ),
        ),
      ],),
      //..............................End of Body............................................
      //....................Drawer Start...................................
      drawer: Drawer(
        backgroundColor: Colors.pink.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("UserProfile").
                where("UId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.hasData){
                    return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                          return UserAccountsDrawerHeader(
                            decoration: BoxDecoration(color: Colors.pink),
                            accountEmail: Text(documentSnapshot['email']),
                            accountName: Text(documentSnapshot['name']),
                            // currentAccountPicture:
                            // CircleAvatar(backgroundImage: NetworkImage(documentSnapshot['image']),
                            // ),
                            currentAccountPicture: CircleAvatar(
                              backgroundImage: (documentSnapshot['image'] != "")
                                  ? NetworkImage(documentSnapshot['image'])
                                  : AssetImage('images/student.png') as ImageProvider, // Explicitly cast to ImageProvider
                              backgroundColor: Colors.blueGrey.shade50,
                              radius: 40,
                            ),
                          );
                        }
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Title(
                    color: Colors.black,
                    child: Padding(padding: const EdgeInsets.only(left: 15),
                      child: Text('Home:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.pink),
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: 10,),
            ListTile(leading: Icon(Icons.home,color: selecteds==0 ? Colors.white:Colors.pink,),
              title: Text('Home'),
              shape: StadiumBorder(),
              selected: selecteds==0,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  selecteds =0;
                });
              },
            ),
            ListTile(leading: Icon(Icons.add_box,color: selecteds==1 ? Colors.white: Colors.pink,),
              title: Text('Add Available'),
              shape: StadiumBorder(),
              selected: selecteds==1,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAvailable()));
                  selecteds =1;
                });
              },
            ),
            ListTile(leading: Icon(Icons.add_box,color: selecteds==2 ? Colors.white: Colors.pink,),
              title: Text('Add Slider'),
              shape: StadiumBorder(),
              selected: selecteds==2,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddVariety()));
                  selecteds =2;
                });
              },
            ),
            ListTile(leading: Icon(Icons.add_box,color: selecteds==3 ? Colors.white: Colors.pink,),
              title: Text('Cart View'),
              shape: StadiumBorder(),
              selected: selecteds==3,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NextCartPage()));
                  selecteds =3;
                });
              },
            ),
            ListTile(leading: Icon(Icons.favorite,color: selecteds==4 ? Colors.white: Colors.pink,),
              title: Text('Favourite'),
              shape: StadiumBorder(),
              selected: selecteds==4,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FavouritePage()));
                  selecteds =4;
                });
              },
            ),
            Divider(thickness: 2,indent: 10,endIndent: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Title(color: Colors.black, child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Profile:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.pink),),
                )),
              ],
            ),
            ListTile(leading: Icon(Icons.share,color: selecteds==5 ? Colors.white: Colors.pink,),
              title: Text('User Profile'),
              shape: StadiumBorder(),
              selected: selecteds==5,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                  selecteds =5;
                });
              },
            ),
            ListTile(leading: Icon(Icons.logout,color: selecteds==6 ? Colors.white: Colors.pink,),
              title: Text('Logout'),
              shape: StadiumBorder(),
              selected: selecteds==6,selectedTileColor: Colors.pink,selectedColor: Colors.white,
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                  auth.signOut().then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signin()));
                  });
                  selecteds =6;
                });
              },
            ),
            Divider(thickness: 2,indent: 10,endIndent: 10,),
          ],
        ),
      ),
    );
  }
}
