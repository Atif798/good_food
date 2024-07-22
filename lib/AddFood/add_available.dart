
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAvailable extends StatefulWidget {
  const AddAvailable({Key? key}) : super(key: key);

  @override
  State<AddAvailable> createState() => _AddAvailableState();
}

class _AddAvailableState extends State<AddAvailable> {
  bool loading = false;
  //..............Image................
  File? image;
  final picker = ImagePicker();
  void dialog(context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.deepOrange.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Container(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: (){getImageCamera(); Navigator.pop(context);},
                child: ListTile(
                  leading: Icon(Icons.camera_alt,color: Colors.pink,),
                  title: Text('Camera',style: TextStyle(color: Colors.pink),),
                ),
              ),
              InkWell(
                onTap: (){getImageGallery(); Navigator.pop(context);},
                child: ListTile(
                  leading: Icon(Icons.browse_gallery,color: Colors.pink,),
                  title: Text('Gallery',style: TextStyle(color: Colors.pink),),
                ),
              ),
            ],
          ),
        ),
      );
    }
    );
  }
  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile !=null){
        image = File(pickedFile.path);
        print('No image selected');
      }else{

      }
    });
  }
  Future getImageCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile !=null){
        image = File(pickedFile.path);
        print('No image selected');
      }else{

      }
    });
  }
  //..............End Image................
  final firestore = FirebaseFirestore.instance.collection("foodcategories");
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //.........Form Key...............................
  var formKey = GlobalKey<FormState>();
  //.................................................
  //.........Function for Validation........................
  void submitted(){
    var isValid = formKey.currentState!.validate();
    formKey.currentState!.save();
    if(isValid){
    }
  }
  //..........End Function Validation..........................
  //...........Variables......................................
  var name;
  var description;
  var price;
  //..............Controllers................................
  final uname = TextEditingController();
  final udescription = TextEditingController();
  final uprice = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uname.addListener(update);
    udescription.addListener(update);
    uprice.addListener(update);
  }
  //............Function update..............
  void update() {
    name = uname.text;
    description = udescription.text;
    price = uprice.text;
  }
  @override
  void dispose() {
    // Dispose of resources, cancel controllers, and cleanup here
    uname.dispose();
    udescription.dispose();
    uprice.dispose();
    super.dispose();
  }
  //......................................
  Future<void> uploadDataAndImage(BuildContext context) async {
    try {
      setState(() {
        loading = true; // Set loading to true when starting the upload process
      });

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/imagefolder/' + DateTime.now().microsecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);
      var newUrl = await ref.getDownloadURL();
      firestore.doc().set({
        "name": name,
        "description": description,
        "price": int.parse(price),
        "image": newUrl,
      });

      Navigator.pop(context); // Return to the previous screen after the data is uploaded
    } catch (error) {
      print(error.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to upload data.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        loading = false; // Reset loading state after the upload process is completed
      });
    }
  }
  //......................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(title: Text('Add Available'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          //padding: EdgeInsets.only(top: 55),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){dialog(context);
                    },
                    child: Center(
                      child: Container(
                        //height: 100,
                        child: image != null ? Image.file(image!.absolute,height:90,
                          fit: BoxFit.fill,):Icon(Icons.camera_alt,size: 115,color: Colors.pink),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  //Icon(Icons.account_circle_rounded,size: 115,color: Colors.purple),
                  Text('Available Food',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink),),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uname,
                      decoration: InputDecoration(
                          hintText: 'Enter food name',hintStyle: TextStyle(color: Colors.pink),
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
                          suffixIcon: IconButton(onPressed: (){uname.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value){},
                      onSaved: (value){
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Foodname is required';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLines: 4,
                      controller: udescription,
                      decoration: InputDecoration(
                          hintText: 'Description',hintStyle: TextStyle(color: Colors.pink,fontFamily: 'Elephant'),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true,
                          suffixIcon: IconButton(onPressed: (){udescription.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      // keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value){},
                      onSaved: (value){description = value;},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Email is required';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uprice,
                      decoration: InputDecoration(
                          hintText: 'Enter price',hintStyle: TextStyle(color: Colors.pink),
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
                          suffixIcon: IconButton(onPressed: (){uprice.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (value){},
                      onSaved: (value){price = value;},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Price is required';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: loading ? null : () {
                      uploadDataAndImage(context);
                    },
                    child: loading ? CircularProgressIndicator() : Text('Available Food',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: StadiumBorder(),
                      minimumSize: Size(200, 50),
                      padding: EdgeInsets.all(15),
                      side: BorderSide(color: Colors.pink,width: 3),
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


