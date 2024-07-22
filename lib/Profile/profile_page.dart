import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("UserProfile").
          where("UId",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot ){
        if(streamSnapshot.hasData){
          return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context,index){
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 70,bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                documentId: documentSnapshot.id,
                                initialName: documentSnapshot['name'],
                                initialEmail: documentSnapshot['email'],
                                initialMobileNumber:
                                documentSnapshot['mobile'],
                                initialImageUrl:
                                documentSnapshot['image'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 400,
                          decoration: BoxDecoration(borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),color: Colors.pink.shade50
                          ),
                          child: Column(children: [
                            SizedBox(height: 15,),
                            Text('User Profile',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 30),),
                            SizedBox(height: 10,),
                            // CircleAvatar(
                            //   radius: 60,
                            //   backgroundImage: NetworkImage(documentSnapshot['image']),),
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: documentSnapshot['image'] != ""
                                  ? NetworkImage(documentSnapshot['image']) as ImageProvider
                                  : AssetImage('images/student.png'),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text('Name:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),),
                              SizedBox(width: 5,),
                              Text(documentSnapshot['name'],
                                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            ],),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text('Email:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),),
                              SizedBox(width: 5,),
                              Text(documentSnapshot['email'],
                                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                            ],),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text('Mobile:',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),),
                              SizedBox(width: 5,),
                              Text(documentSnapshot['mobile'],
                                style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            ],)
                          ],),
                        ),
                      ),
                  ),
                );
          });
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
class EditProfilePage extends StatefulWidget {
  final String documentId;
  final String initialName;
  final String initialEmail;
  final String initialMobileNumber;
  final String initialImageUrl;

  const EditProfilePage({
    required this.documentId,
    required this.initialName,
    required this.initialEmail,
    required this.initialMobileNumber,
    required this.initialImageUrl,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  File? _image;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _mobileNumberController =
        TextEditingController(text: widget.initialMobileNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (widget.initialImageUrl.isEmpty
                        ? AssetImage('images/student.png')
                        : NetworkImage(widget.initialImageUrl)) as ImageProvider<Object>,
                  ),
                ),
                SizedBox(height: 3,),
                Center(child: Text('Change Profile',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.pink),)),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
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
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',labelStyle: TextStyle(color: Colors.pink),
                    hintText: 'Enter email',hintStyle: TextStyle(color: Colors.deepOrange,),
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
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add additional email validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      labelText: 'Phone',labelStyle: TextStyle(color: Colors.pink),
                      hintText: 'Enter mobile number',hintStyle: TextStyle(color: Colors.deepOrange),
                      prefixIcon: Icon(Icons.phone,color: Colors.pink),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color:Colors.pink, width: 3.0),),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0),),
                      errorStyle: TextStyle(color: Colors.pink),
                      filled: true, fillColor: Colors.blueGrey.shade50//fillColor: Colors.grey
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    // Add additional mobile number validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(200, 50),
                      side: BorderSide(color: Colors.pink,width: 3),
                      elevation: 3
                  ),
                  onPressed: _isUploadingImage ? null : _updateUserProfile,
                  child: _isUploadingImage
                      ? CircularProgressIndicator()
                      : Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        String imageUrl = widget.initialImageUrl;

        if (_image != null) {
          final userName = _nameController.text;
          final storageRef = FirebaseStorage.instance.ref().child('/profilefolder/$userName.jpg');
          final uploadTask = storageRef.putFile(_image!);
          final snapshot = await uploadTask.whenComplete(() {});
          imageUrl = await snapshot.ref.getDownloadURL();

          // Delete the previous image if it exists
          // final previousImageUrl = widget.initialImageUrl;
          // if (previousImageUrl != null && previousImageUrl.isNotEmpty) {
          //   final previousImageRef = FirebaseStorage.instance.refFromURL(previousImageUrl);
          //   await previousImageRef.delete();
          // }
        }

        await FirebaseFirestore.instance
            .collection('UserProfile')
            .doc(widget.documentId)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileNumberController.text,
          'image': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.pink,shape: StadiumBorder(),
              content: Text('Profile updated successfully',textAlign: TextAlign.center,)),
        );
        Navigator.pop(context); // Go back to the previous page
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.pink,shape: StadiumBorder(),
              content: Text('Failed to update profile',textAlign: TextAlign.center,)),
        );
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }
}