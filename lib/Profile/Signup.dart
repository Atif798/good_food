import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_food/Profile/Signin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
    });
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
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseRef = FirebaseFirestore.instance.collection("UserProfile");
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //.........Form Key...............................
  var formKey = GlobalKey<FormState>();
  //.................................................
  bool showHide = true;
  //...........Variables......................................
  var name;
  var email;
  var mobile;
  var pass;
  var confirm;
  //..............Controllers................................
  final uname = TextEditingController();
  final uemail = TextEditingController();
  final umobile = TextEditingController();
  final upass = TextEditingController();
  final uconfirm = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uname.addListener(update);
    uemail.addListener(update);
    umobile.addListener(update);
    upass.addListener(update);
    uconfirm.addListener(update);
  }
  //............Funtion update..............
  void update() {
    name = uname.text;
    email = uemail.text;
    mobile = umobile.text;
    pass = upass.text;
    confirm = uconfirm.text;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(title: Text('Register'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          //padding: EdgeInsets.only(top: 40),
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
                        child: image != null ? Image.file(
                          image!.absolute,height:90,fit: BoxFit.fill,):Icon(Icons.camera_alt,size: 115,
                            color: Colors.pink),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text('Signup',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold
                  ,color: Colors.pink),),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uname,
                      decoration: InputDecoration(
                          labelText: 'Name',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter username',hintStyle: TextStyle(color: Colors.deepOrange),
                          prefixIcon: Icon(Icons.person,color: Colors.pink),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true, //fillColor: Colors.grey
                          suffixIcon: IconButton(onPressed: (){uname.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value){},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Username is required';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uemail,
                      decoration: InputDecoration(
                          labelText: 'Email',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter email',hintStyle: TextStyle(color: Colors.deepOrange,fontFamily: 'Elephant'),
                          prefixIcon: Icon(Icons.email,color: Colors.pink),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true,
                          suffixIcon: IconButton(onPressed: (){uemail.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value){},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Email is required';
                        String pattern = r'\w+@\w+\.\w+';
                        if (!RegExp(pattern).hasMatch(value))
                          return 'Invalid email address format.';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: umobile,
                      decoration: InputDecoration(
                          labelText: 'Phone',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter mobile number',hintStyle: TextStyle(color: Colors.deepOrange),
                          prefixIcon: Icon(Icons.phone,color: Colors.pink),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true, //fillColor: Colors.grey
                          suffixIcon: IconButton(onPressed: (){umobile.clear();},
                              icon: Icon(Icons.clear,color: Colors.pink,size: 20,))
                      ),
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (value){},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Mobile number is required';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: upass,
                      obscureText: showHide,
                      maxLength: 8,
                      decoration: InputDecoration(
                          labelText: 'Password',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Enter password',hintStyle: TextStyle(color: Colors.deepOrange),
                          prefixIcon: Icon(Icons.vpn_key,color: Colors.pink),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true,
                          suffixIcon: IconButton(onPressed: (){setState(() {showHide =! showHide;});},
                              icon: showHide ?
                              Icon(Icons.visibility_off_outlined,size: 20,color: Colors.pink,):
                              Icon(Icons.visibility_outlined,size: 20,color: Colors.pinkAccent,))
                      ),
                      onFieldSubmitted: (value){},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Password is required';
                        String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        if (!RegExp(pattern).hasMatch(value))
                          return 'Password uppercase letter, number and symbol.';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      controller: uconfirm,
                      obscureText: showHide,
                      maxLength: 8,
                      decoration: InputDecoration(
                          labelText: 'Confirm',labelStyle: TextStyle(color: Colors.pink),
                          hintText: 'Retype password',hintStyle: TextStyle(color: Colors.deepOrange),
                          prefixIcon: Icon(Icons.vpn_key,color: Colors.pink),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                          errorStyle: TextStyle(color: Colors.pink),
                          filled: true,
                          suffixIcon: IconButton(onPressed: (){setState(() {showHide =! showHide;});},
                              icon: showHide ?
                              Icon(Icons.visibility_off_outlined,size: 20,color: Colors.pink,):Icon(Icons.visibility_outlined,size: 20,color: Colors.pinkAccent,))
                      ),
                      onFieldSubmitted: (value){},
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Confirm password is required';
                        if (value != pass)
                          return 'Password not matching';
                        return null;
                      }
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: loading ? null : () async {
                      if(formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        try{
                          final user = await auth.createUserWithEmailAndPassword(
                              email: email,
                              password: pass);
                          if(user != null){
                            firebase_storage.Reference ref =
                            firebase_storage.FirebaseStorage.instance.ref('/profilefolder/'+DateTime.now().microsecondsSinceEpoch.toString());
                            UploadTask uploadTask = ref.putFile(image!.absolute);
                            await Future.value(uploadTask);
                            var newUrl = await ref.getDownloadURL();
                            final User? users = auth.currentUser;
                            databaseRef.doc().set({
                              "UId":users!.uid.toString(),
                              "name":name,
                              "email":email,
                              "mobile" :mobile,
                              "password":pass,
                              "image":newUrl
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Signin()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.pink,shape: StadiumBorder(),
                                  content: Text('Registered Successfully',textAlign: TextAlign.center,)),
                            );
                            setState(() {
                              loading = false;
                            });
                          }
                        }catch(e){
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.pink,shape: StadiumBorder(),
                                content: Text('Failed to registered',textAlign: TextAlign.center,)),
                          );
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    }, child: loading
                      ? CircularProgressIndicator()
                      : Text('Signup'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: StadiumBorder(),
                        //minimumSize: Size(150, 50),
                        //padding: EdgeInsets.all(15),
                        minimumSize: Size(200, 50),
                        side: BorderSide(color: Colors.pink,width: 3),
                        elevation: 3
                    ),),
                  TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> Signin()));},
                      child: Text('Allready have an account?'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
