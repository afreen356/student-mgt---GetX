import 'package:hive/hive.dart';

  part 'db_model.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String classs;
  @HiveField(3)
  final String admissionNumber;
  @HiveField(4)
  final String address;
  @HiveField(5)
  final String image;

  Student(
      {this.id,
        required this.name,
      required this.classs,
      required this.admissionNumber,
      required this.address,
      required this.image});
}
