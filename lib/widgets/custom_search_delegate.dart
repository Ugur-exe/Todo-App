import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  late final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filterList = allTask
        .where((missions) =>
            missions.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filterList.isNotEmpty
        ? ListView.builder(
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              var nowListElemnt = filterList[index];
              return Dismissible(
                background:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.all(8)),
                    const Icon(Icons.delete, color: Colors.red),
                    const Text('remove_task').tr()
                  ],
                ),
                key: Key(nowListElemnt.id),
                onDismissed: (direction) async {
                  filterList.removeAt(index);
                  await locator<LocalStorage>().deteleTask(task: nowListElemnt);
                  
                },
                child: TaskItem(task: nowListElemnt),
              );
            },
          )
        :  Center(
            child: const Text('Arama Bulunamadı !').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
