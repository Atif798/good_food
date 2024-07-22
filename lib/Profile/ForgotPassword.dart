
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_food/Profile/Signin.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  //.........Form Key...............................
  var formKey = GlobalKey<FormState>();
  //...........Variables......................................
  var email;
  //..............Controllers................................
  final uemail = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uemail.addListener(update);
  }
  //............Funtion update..............
  void update() {
    email = uemail.text;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(title: Text('Forget Password Screen'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          padding: EdgeInsets.only(top: 30),
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 15,),
                  Icon(Icons.account_circle_rounded,size: 115,color: Colors.pink),
                  Text('Forget Password',textAlign: TextAlign.center,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.pink),),
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
                  ElevatedButton(
                    onPressed: loading
                        ? null // Disable the button when loading is true
                        : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = true; // Set loading to true when the button is pressed
                        });
                        try {
                          await auth.sendPasswordResetEmail(email: email).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.pink,
                                shape: StadiumBorder(),
                                content: Text(
                                  'Please check reset link has been sent via email',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                            setState(() {
                              loading = false; // Set loading to false when the email is sent successfully
                            });
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.pink,
                                shape: StadiumBorder(),
                                content: Text(
                                  'Failed to forget password',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          });
                        } catch (e) {
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.pink,
                              shape: StadiumBorder(),
                              content: Text(
                                'Failed to forget password',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          setState(() {
                            loading = false; // Set loading to false in case of an error
                          });
                        }
                      }
                    },
                    child: loading
                        ? CircularProgressIndicator() // Show CircularProgressIndicator while loading is true
                        : Text('Forget Password',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: StadiumBorder(),
                      minimumSize: Size(200, 50),
                      side: BorderSide(color: Colors.pink, width: 3),
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
  // void toastMessage(String message){
  //   Fluttertoast.showToast(
  //       msg: message.toString(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.SNACKBAR,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.deepOrange,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }
}
