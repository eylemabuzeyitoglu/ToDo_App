import 'package:flutter/material.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/widget/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
          (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankiListeElemani = filteredList[index];
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
                  filteredList.removeAt(index);
                  locator<LocalStorage>().deleteTask(task: oankiListeElemani);
                },
                child: TaskItem(task: oankiListeElemani),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(child: Text('Aradığınızı bulamadık'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
