import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/helper/translation_helper.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/widget/custom_search_delegate.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    _getAllTaskFromDb();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: Text('title', style: TextStyle(color: Colors.black)).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
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
                      Text('remove_task').tr(),
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
          : Center(child: Text('empty_task_list').tr()),
    );
  }

  void _showAddTaskBottomSheet() {
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
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationHelper.getDeviceLanguage(context),
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

  void _getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(allTask: _allTask),
    );
    _getAllTaskFromDb();
  }
}
