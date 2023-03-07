import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String _id = '';
  String _name = '';
  String _birthDate = '';
  String _gender = '';
  String _country = '';
  String _prefecture = '';
  double _bodyHeight = 0.0;
  double _bodyWeight = 0.0;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get birthDate => _birthDate;
  String get gender => _gender;
  String get country => _country;
  String get prefecture => _prefecture;
  double get bodyHeight => _bodyHeight;
  double get bodyWeight => _bodyWeight;
  DateTime get createdAt => _createdAt;

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _name = snapshot.data()!['name'] ?? '';
    _birthDate = snapshot.data()!['birthDate'] ?? '';
    _gender = snapshot.data()!['gender'] ?? '';
    _country = snapshot.data()!['country'] ?? '';
    _prefecture = snapshot.data()!['prefecture'] ?? '';
    _bodyHeight = double.parse('${snapshot.data()!['bodyHeight']}');
    _bodyWeight = double.parse('${snapshot.data()!['bodyWeight']}');
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}
