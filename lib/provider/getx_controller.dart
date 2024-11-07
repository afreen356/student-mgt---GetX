import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_management_provider/model/db_model.dart';

class StudentController extends GetxController {
  RxList<Student> students = <Student>[].obs;
  final studentbox = Hive.box<Student>('students');

  @override
  void onInit() {
    super.onInit();
    getStudents();
  }

  getStudents() async {
    final box = await Hive.openBox<Student>('students');
    students.assignAll(box.values.toList());
    box.watch().listen((event) {
      students.assignAll(box.values.toList());
    });
  }

  postStudent(Student data) async {
    data.id=  await studentbox.add(data);
    await studentbox.put(data.id, data);
    getStudents();  
    Get.snackbar("Succes", "${data.name} Added succesfully");
  }

  Future<void> updateStudent(Student data,int? id)async{
   await  studentbox.put(id, data);
  }

  Student? getStudentById(int? id) {
    return students.firstWhereOrNull((student) => student.key == id);
  }

  deleteStudent(int? id, String name) async {
    await studentbox.delete(id);
    log(id.toString());
    Get.snackbar("Succes", "$name Deleted succesfully");
  }
}

// id kerunind ing edhteel theryttha