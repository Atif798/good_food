import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.page == _pageController.page!.toInt()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _deleteSlide(String docId) {
    FirebaseFirestore.instance.collection('FoodSlider').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('FoodSlider').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Slide> slides = snapshot.data!.docs.map((doc) {
            return Slide(
              imageUrl: doc['image'],
              title: doc['name'],
              description: doc['description'],
              docId: doc.id,
            );
          }).toList();

          return PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Slide'),
                        content: Text('Are you sure you want to delete this slide?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('CANCEL'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _deleteSlide(slides[index].docId);
                              Navigator.of(context).pop();
                            },
                            child: Text('DELETE'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  //width: MediaQuery.of(context).size.width,
                  width: 100,height: 100,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 95,),
                      Text(
                        slides[index].title,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        //width: MediaQuery.of(context).size.width,
                          width: 150,height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(slides[index].imageUrl),
                              //fit: BoxFit.fill,
                            ),
                          ),),
                      SizedBox(height: 35,),
                      Text(
                        slides[index].description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 160),
                      if (index == slides.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the next screen here
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                          },
                          child: Text('Lets Started'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Slide {
  final String title;
  final String description;
  final String imageUrl;
  final String docId;

  Slide({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.docId,
  });
}
