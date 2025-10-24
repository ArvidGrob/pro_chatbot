import 'package:flutter/foundation.dart';

class Student {
  Student(this.name, {this.online = false});
  final String name;
  bool online;
}

class StudentStore {
  StudentStore._();
  static final StudentStore instance = StudentStore._();

  /// Current students in the class/app
  final ValueNotifier<List<Student>> students = ValueNotifier<List<Student>>([
    Student('San Janssen', online: true),
    Student('Emily Jansen', online: true),
    Student('Luuk de Vries', online: false),
    Student('Sophie Bakker', online: false),
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

  void addByName(String name) {
    if (containsName(name)) return;
    final list = [...students.value, Student(name, online: false)];
    students.value = list;
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
}
