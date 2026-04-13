import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference _taskCollection = 
      FirebaseFirestore.instance.collection('tasks');

  // Create
  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    await _taskCollection.add({
      'title': title.trim(),
      'isCompleted': false,
      'subtasks': [],
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // Read (Stream)
  Stream<List<Task>> getTasks() {
    return _taskCollection.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update Task Completion
  Future<void> toggleTask(Task task) async {
    await _taskCollection.doc(task.id).update({'isCompleted': !task.isCompleted});
  }

  // Add Nested Subtask
  Future<void> addSubtask(Task task, String subtaskTitle) async {
    if (subtaskTitle.trim().isEmpty) return;
    await _taskCollection.doc(task.id).update({
      'subtasks': FieldValue.arrayUnion([{
        'title': subtaskTitle.trim(),
        'isCompleted': false,
      }])
    });
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    await _taskCollection.doc(taskId).delete();
  }
}