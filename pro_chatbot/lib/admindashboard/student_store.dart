import 'package:flutter/foundation.dart';

class Student {
  Student(this.name, {this.online = false, this.password});
  String name;
  bool online;
  String? password;
}

class StudentStore {
  StudentStore._();
  static final StudentStore instance = StudentStore._();

  /// Current students in the class/app
  final ValueNotifier<List<Student>> students = ValueNotifier<List<Student>>([
    Student('San Janssen', online: true, password: 'san123'),
    Student('Emily Jansen', online: true, password: 'emily123'),
    Student('Luuk de Vries', online: false, password: 'luuk123'),
    Student('Sophie Bakker', online: false, password: 'sophie123'),
  ]);

  /// “Directory” of all known people you can add from (mocked).
  final List<String> directory = [
    'San Janssen',
    'Emily Jansen',
    'Luuk de Vries',
    'Sophie Bakker',
    'Maxime Kulpers',
    'Noah Visser',
    'Lotte Van Dijk',
    'Bram de Boer',
    'Gabriel Daloiso',
    'Leroy Rodermond',
    'Emma Coers',
    'Arvid Grobbe',
  ];

  bool containsName(String name) =>
      students.value.any((s) => s.name.toLowerCase() == name.toLowerCase());

  // Neuer Weg zum Hinzufügen, damit Passwort gesetzt werden kann
  void addStudent(String name, {bool online = false, String? password}) {
    if (containsName(name)) return;
    final list = [...students.value, Student(name, online: online, password: password)];
    students.value = list;
  }

  void addByName(String name) {
    addStudent(name, online: false);
  }

  void removeByName(String name) {
    final list = students.value.where((s) => s.name != name).toList();
    students.value = list;
  }

  void setStatus(String name, bool online) {
    final list = students.value;
    final i = list.indexWhere((s) => s.name == name);
    if (i == -1) return;
    list[i].online = online;
    students.value = List<Student>.from(list); // trigger listeners
  }
  void renameStudent(String oldName, String newName) {
    final list = students.value;
    final i = list.indexWhere((s) => s.name == oldName);
    if (i == -1) return;
    list[i].name = newName;
    students.value = List<Student>.from(list);
  }
  void setPassword(String name, String newPassword) {
    final list = students.value;
    final i = list.indexWhere((s) => s.name == name);
    if (i == -1) return;
    list[i].password = newPassword;
    students.value = List<Student>.from(list);
  }
  String? getPassword(String name) {
    final list = students.value;
    final i = list.indexWhere((s) => s.name == name);
    if (i == -1) return null;
    return list[i].password;
  }
}
