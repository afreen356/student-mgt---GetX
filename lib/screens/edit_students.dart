import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_provider/model/db_model.dart';
import 'package:student_management_provider/provider/getx_controller.dart';
import 'package:student_management_provider/provider/image_controller.dart';

class EditStudents extends StatefulWidget {
  final Student data;

  const EditStudents({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _EditStudentsState createState() => _EditStudentsState();
}

class _EditStudentsState extends State<EditStudents> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final admController = TextEditingController();
  final classController = TextEditingController();
  final addressController = TextEditingController();
  final imagecontroller = Get.put(AddImageController());
  final StudentController studentController = Get.find();
  String? selectedImage;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.data.name;
    admController.text = widget.data.admissionNumber;
    classController.text = widget.data.classs;
    addressController.text = widget.data.address;
    selectedImage = widget.data.image;
  }

  @override
  Widget build(BuildContext context) {
    int? id = widget.data.id;
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
                                controller: admController,
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
                                controller: classController,
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
                                        updateStudent(id);
                                      }
                                    },
                                    child: const Text('Update')),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    )))));
  }

  void updateStudent(int? id) {
    final name = nameController.text;
    final claass = classController.text;
    final admNo = admController.text;
    final address = addressController.text;
    final image = selectedImage;

    if (name.isEmpty ||
        claass.isEmpty ||
        admNo.isEmpty ||
        address.isEmpty ||
        image!.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    } else {
      final student = Student(
          id: id,
          name: name,
          classs: claass,
          admissionNumber: admNo,
          address: address,
          image: image);
      studentController.updateStudent(student, id);
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
