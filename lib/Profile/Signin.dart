
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_food/HomePage.dart';
import 'package:good_food/Profile/ForgotPassword.dart';
import 'package:good_food/Profile/Signup.dart';
import 'package:good_food/Profile/profile_page.dart';

import '../Slider/intro_slider.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  FirebaseAuth auth = FirebaseAuth.instance;
  //.........Form Key...............................
  var formKey = GlobalKey<FormState>();
  //.................................................
  bool showHide = true;
  bool loading = false;
  //...........Variables......................................
  var email;
  var pass;
  //..............Controllers................................
  final uemail = TextEditingController();
  final upass = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uemail.addListener(update);
    upass.addListener(update);
  }
  //............Funtion update..............
  void update() {
    email = uemail.text;
    pass = upass.text;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(title: Text('Login Screen'),),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
              key: formKey,
              child:
             ListView(children: [
               Column(
                 children: [
                   SizedBox(height: 15,),
                   Icon(Icons.account_circle_rounded,size: 115,color: Colors.pink),
                   Text('Signin',textAlign: TextAlign.center,style: TextStyle(
                       fontSize: 30,fontWeight: FontWeight.bold,
                       color: Colors.pinkAccent),),
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
                               Icon(Icons.visibility_off_outlined,size: 20,color: Colors.pink,):Icon(Icons.visibility_outlined,size: 20,color: Colors.pinkAccent,))
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
                   SizedBox(height: 7,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));},
                           child: Text('Forget Password?', textAlign: TextAlign.right,)),
                     ],
                   ),
                   SizedBox(height: 20,),
                   ElevatedButton(onPressed: loading ? null : () async {
                     if(formKey.currentState!.validate()){
                       setState(() {
                         loading = true;
                       });
                       try{
                         final user = await auth.signInWithEmailAndPassword(
                             email: email.toString().trim(),
                             password: pass.toString().trim());
                         if(user !=null){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageSlider()));
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                 backgroundColor: Colors.pink,shape: StadiumBorder(),
                                 content: Text('Login Successfully',textAlign: TextAlign.center,)),
                           );
                           setState(() {
                             loading = false;
                           });
                         }else{
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                 backgroundColor: Colors.pink,shape: StadiumBorder(),
                                 content: Text('Failed to login',textAlign: TextAlign.center,)),
                           );
                         }
                       }catch(e){
                         print(e.toString());
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                               backgroundColor: Colors.pink,shape: StadiumBorder(),
                               content: Text('Failed to login',textAlign: TextAlign.center,)),
                         );
                         setState(() {
                           loading = false;
                         });
                       }
                     }
                   }, child: loading
                       ? CircularProgressIndicator()
                       : Text('Signin',style: TextStyle(color: Colors.white),),
                     style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.pink,
                         shape: StadiumBorder(),
                         minimumSize: Size(200, 50),
                         side: BorderSide(color: Colors.pink,width: 3),
                         elevation: 3
                     ),),
                   TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));},
                       child: Text('Not have an account?'))
                 ],
               ),
             ],)
            ),
      ),
    );
  }
}
