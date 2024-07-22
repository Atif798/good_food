
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVariety extends StatefulWidget {
  const AddVariety({Key? key}) : super(key: key);

  @override
  State<AddVariety> createState() => _AddVarietyState();
}

class _AddVarietyState extends State<AddVariety> {
  bool loading = false;
  //..............Image................
  File? image;
  final picker = ImagePicker();
  void dialog(context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Container(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: (){getImageCamera(); Navigator.pop(context);},
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                ),
              ),
              InkWell(
                onTap: (){getImageGallery(); Navigator.pop(context);},
                child: ListTile(
                  leading: Icon(Icons.browse_gallery),
                  title: Text('Gallery'),
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
  final firestore = FirebaseFirestore.instance.collection("FoodSlider");
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //.........Form Key...............................
  var formKey = GlobalKey<FormState>();
  //.................................................
  //.........Function for Validation........................
  // void submitted(){
  //   var isValid = formKey.currentState!.validate();
  //   formKey.currentState!.save();
  //   if(isValid){
  //   }
  // }
  //..........End Function Validation..........................
  //...........Variables......................................
  var name;
  var desc;
  //..............Controllers................................
  final uname = TextEditingController();
  final descrip = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uname.addListener(update);
    descrip.addListener(update);
  }
  //............Funtion update..............
  void update() {
    name = uname.text;
    desc = descrip.text;
  }
  @override
  void dispose() {
    // Dispose of resources, cancel controllers, and cleanup here
    uname.dispose();
    descrip.dispose();
    super.dispose();
  }
  //....................................
  Future<void> uploadDataAndImage(BuildContext context) async {
    try {
      setState(() {
        loading = true; // Set loading to true when starting the upload process
      });

      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/foodslider/' + DateTime.now().microsecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);
      var newUrl = await ref.getDownloadURL();
      firestore.doc().set({
        "name": name,
        "description": desc,
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
  //....................................
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(title: Text('Add Variety'),),
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
                        child: image != null ? Image.file(image!.absolute,height:90,fit: BoxFit.fill,):Icon(Icons.account_circle_rounded,size: 115,color: Colors.pink),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  //Icon(Icons.account_circle_rounded,size: 115,color: Colors.purple),
                  Text('Add Variety',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink),),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uname,
                      decoration: InputDecoration(
                          labelText: 'Name',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter foodname',hintStyle: TextStyle(color: Colors.deepOrange),
                          prefixIcon: Icon(Icons.person,color: Colors.pink),
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
                      controller: descrip,
                      decoration: InputDecoration(
                          labelText: 'Description',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter food description',hintStyle: TextStyle(color: Colors.deepOrange),
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
                          suffixIcon: IconButton(onPressed: (){descrip.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value){},
                      onSaved: (value){
                        desc = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Description is required';
                        return null;
                      },maxLines: 8,
                  ),
                  // SizedBox(height: 20,),
                  // TextFormField(
                  //     controller: uemail,
                  //     decoration: InputDecoration(
                  //         labelText: 'Email',labelStyle: TextStyle(color: Colors.purple),
                  //         hintText: 'Enter email',hintStyle: TextStyle(color: Colors.blueGrey,fontFamily: 'Elephant'),
                  //         prefixIcon: Icon(Icons.email,color: Colors.purple),
                  //         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         errorStyle: TextStyle(color: Colors.purple),
                  //         filled: true,
                  //         suffixIcon: IconButton(onPressed: (){uemail.clear();},
                  //             icon: Icon(Icons.clear,color: Colors.purple,size: 20,))
                  //     ),
                  //     keyboardType: TextInputType.emailAddress,
                  //     onFieldSubmitted: (value){},
                  //     onSaved: (value){email = value;},
                  //     validator: (value) {
                  //       if (value!.isEmpty)
                  //         return 'Email is required';
                  //       String pattern = r'\w+@\w+\.\w+';
                  //       if (!RegExp(pattern).hasMatch(value))
                  //         return 'Invalid email address format.';
                  //       return null;
                  //     }
                  // ),
                  // SizedBox(height: 20,),
                  // TextFormField(
                  //     controller: umobile,
                  //     decoration: InputDecoration(
                  //         labelText: 'Phone',labelStyle: TextStyle(color: Colors.purple),
                  //         hintText: 'Enter mobile number',hintStyle: TextStyle(color: Colors.blueGrey),
                  //         prefixIcon: Icon(Icons.phone,color: Colors.purple),
                  //         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  //           borderSide: BorderSide(color: Colors.purple, width: 3.0),),
                  //         errorStyle: TextStyle(color: Colors.purple),
                  //         filled: true, //fillColor: Colors.grey
                  //         suffixIcon: IconButton(onPressed: (){umobile.clear();},
                  //             icon: Icon(Icons.clear,color: Colors.purple,size: 20,))
                  //     ),
                  //     keyboardType: TextInputType.phone,
                  //     onFieldSubmitted: (value){},
                  //     onSaved: (value){mobile = value;},
                  //     validator: (value) {
                  //       if (value!.isEmpty)
                  //         return 'Mobile number is required';
                  //       return null;
                  //     }
                  // ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: loading
                        ? null // Disable the button when loading is true
                        : () {
                      uploadDataAndImage(context);
                    },
                    child: loading
                        ? CircularProgressIndicator() // Show CircularProgressIndicator while loading is true
                        : Text('Add Variety',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: StadiumBorder(),
                        minimumSize: Size(200, 50),
                        padding: EdgeInsets.all(15),
                        side: BorderSide(color: Colors.pink,width: 3),
                        elevation: 3
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

