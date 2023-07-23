import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  
  late File _image;
  late List _results;
  bool imageSelect=false;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/model.tflite",labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("রোগ শনাক্তকরণ"),
      ),
      body: ListView(
        children: [
          (imageSelect)?Container(
        margin: const EdgeInsets.all(10),
        child: Image.file(_image),
      ):Container(
        margin: const EdgeInsets.all(10),
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: Text("ছবি নির্বাচন করুন",style: const TextStyle(color: Colors.black87,fontSize: 25,height: 1.5,fontWeight: FontWeight.bold),),
              ),
            ),
      ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)?_results.map((result) {
                return Card(
                  child: Container(
                      margin: EdgeInsets.all(5),

                      child: result['label'] == 'LSD'?
                      Text("রোগ: লাম্পি চর্ম রোগ",style: const TextStyle(color: Colors.black87,fontSize: 25,height: 1.5,fontWeight: FontWeight.bold),): (result['label'] == 'FMD'? Text("রোগ: ফুট অ্যান্ড মাউথ রোগ",style: const TextStyle(color: Colors.black87,fontSize: 25,height: 1.5,fontWeight: FontWeight.bold),):(result['label'] == 'IBK'? Text("রোগ: সংক্রামক বোভাইন কেরাটোকনজাংটিভাইটিস রোগ",style: const TextStyle(color: Colors.black87,fontSize: 25,height: 1.5,fontWeight: FontWeight.bold),):null))



                  ),

                );
              }).toList():[],

            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }
  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }
}
