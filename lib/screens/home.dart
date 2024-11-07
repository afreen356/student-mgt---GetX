import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_provider/provider/getx_controller.dart';
import 'package:student_management_provider/screens/add_students.dart';
import 'package:student_management_provider/screens/edit_students.dart';
import 'package:student_management_provider/screens/search.dart';
import 'package:student_management_provider/screens/view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final student = Get.put(StudentController());
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Center(
              child: Text(
            'Home',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          )),
        actions: [
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
           Get.to(() => const SearchStudent());
            },
            icon: const Icon(Icons.search,size: 30,color:Colors.white,),
          ),
        ],
      ),
      body: Obx(
        () => student.students.isEmpty
            ? const Center(
                child: Text(
                  "No Data, Please Add",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              )
            : ListView.builder(
                itemCount: student.students.length,
                itemBuilder: (context, index) {
                  final studentData = student.students[index];
                  return Card(
                    color: Colors.grey[200],
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => Profile(studentId: studentData.key));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: studentData.image.isNotEmpty &&
                                  File(studentData.image).existsSync()
                              ? FileImage(File(studentData.image))
                              : null,
                          child: studentData.image.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Center(child: Text(studentData.name,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600 ))),
                        subtitle: Center(child: Text(studentData.admissionNumber,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500))),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                log(studentData.id.toString()
                                );
                                Get.to(() => EditStudents(data: studentData));
                              },
                              icon: const Icon(Icons.edit,),
                            ),
                            IconButton(
                              onPressed: () {
                                delete(studentData.name, studentData.key);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 199, 75, 66),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>const AddStudents());
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  void delete(String name, int? id) {
    Get.defaultDialog(
      title: "Delete Confirmation",
      middleText: 'Are you sure you want to delete this student?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        Get.find<StudentController>().deleteStudent(id!, name);
        Get.back();
      },
    );
  }
}
