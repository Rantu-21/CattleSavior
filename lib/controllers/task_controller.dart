import 'package:CattleSavior/db/db_helpers.dart';
import 'package:get/get.dart';
import '../model/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    getTasks();
    super.onReady();
  }
  var taskList =<Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();
  }
}