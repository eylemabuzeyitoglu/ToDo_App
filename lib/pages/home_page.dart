import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/widget/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: Text(
            'Bugün Neler Yapacaksın?',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oankiListeElemani = _allTask[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Bu göreev silindi'),
                    ],
                  ),
                  key: Key(oankiListeElemani.id),
                  onDismissed: (direction) {
                    setState(() {
                      _allTask.removeAt(index);
                      _localStorage.deleteTask(task: oankiListeElemani);
                    });
                  },
                  child: TaskItem(task: oankiListeElemani),
                );
              },
              itemCount: _allTask.length,
            )
          : Center(child: Text('Hadi Görev Ekle')),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Görev nedir?',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev = Task.create(
                        name: value,
                        createdAt: time,
                      );
                      _allTask.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {
                        //_allTask.add(yeniEklenecekGorev);
                      });
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }
}
