import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;

  @override
  void initState() {
    super.initState();
    _allTask = <Task>[];
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          var oankiListeElemani = _allTask[index];
          return ListTile(
            title: Text(oankiListeElemani.name + ' ' + oankiListeElemani.id),
            subtitle: Text(oankiListeElemani.createdAt.toString()),
          );
        },
        itemCount: _allTask.length,
      ),
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
                    onConfirm: (time) {
                      var yeniEklenecekGorev = Task.create(
                        name: value,
                        createdAt: time,
                      );
                      setState(() {
                        _allTask.add(yeniEklenecekGorev);
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
}
