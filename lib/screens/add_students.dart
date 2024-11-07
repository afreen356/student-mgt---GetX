import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_provider/model/db_model.dart';
import 'package:student_management_provider/provider/getx_controller.dart';

import '../provider/image_controller.dart';

class AddStudents extends StatefulWidget {
  const AddStudents({super.key});

  @override
  State<AddStudents> createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final classsController = TextEditingController();
  final admissionController = TextEditingController();
  final addressController = TextEditingController();
  final imageController = Get.put(AddImageController());
  final StudentController studentController = Get.find();

  String? selectedImage;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
              child: Text('Enter the details',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    height: 650,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  color:
                                      const Color.fromARGB(255, 211, 204, 204),
                                  child: selectedImage == null
                                      ? const Center(
                                          child: Icon(
                                          Icons.person,
                                          size: 150,
                                          color: Colors.grey,
                                        ))
                                      : Image.file(
                                          File(
                                            selectedImage!,
                                          ),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            //  SizedBox(height: 2,),
                            IconButton(
                                onPressed: () {
                                  pickImage();
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 100),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: admissionController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Admission No',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your admission No';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: classsController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Class',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'class is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: addressController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Address',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        saveStudent();
                                      }
                                    },
                                    child: const Text('Submit')),
                                const SizedBox(
                                  width: 40,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      clear();
                                    },
                                    child: const Text('Clear'))
                              ],
                            ),
                          ]),
                        ),
                      ),
                    )))));
  }

  void clear() {
    setState(() {
      nameController.clear();
      classsController.clear();
      admissionController.clear();
      addressController.clear();
      imageController.selectedImage.value = null;
    });
  }

  void saveStudent() {
   final name = nameController.text;
   final claass = classsController.text;
   final  admNo = admissionController.text;
   final address = addressController.text;
   final image = selectedImage;
      
    if (name.isEmpty ||
        claass.isEmpty ||
        admNo.isEmpty ||
        address.isEmpty ||
        image!.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;

        }else{
           final student = Student(
        name: name,
        classs: claass,
        admissionNumber: admNo,
        address: address,
        image: image);
        studentController.postStudent(student);
        Get.back();
        }
   
   
   }

  Future<void> pickImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        selectedImage = returnedImage.path;
      });
    }
  }
}
