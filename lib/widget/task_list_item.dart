import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _taskNameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            setState(() {
              widget.task.isCompleted = !widget.task.isCompleted;
            });
            await _localStorage.updateTask(task: widget.task);
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.task.isCompleted ? Colors.green : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 0.8),
            ),
            child: Icon(Icons.check, color: Colors.white),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
            : TextField(
                minLines: 1,
                maxLines: null,
                controller: _taskNameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(border: InputBorder.none),

                onSubmitted: (yeniDeger) async {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    await _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
