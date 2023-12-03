import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/tranlations.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: Text(
            'title'.tr(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var nowListElemnt = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(padding: EdgeInsets.all(8)),
                      const Icon(Icons.delete, color: Colors.red),
                      const Text('remove_task').tr()
                    ],
                  ),
                  key: Key(nowListElemnt.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deteleTask(task: nowListElemnt);
                    setState(() {});
                  },
                  child: TaskItem(task: nowListElemnt),
                );
              },
            )
          : Center(
              child: Text(
                'empty_task_list'.tr(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    hintText: 'add_task'.tr(), border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length >= 3) {
                    DatePicker.showTimePicker(
                      context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false,
                      onConfirm: (time) {
                        var newAddMissions =
                            Task.create(name: value, createdAt: time);

                        setState(() {
                          _allTasks.insert(0, newAddMissions);
                          _localStorage.addTask(task: newAddMissions);
                        });
                      },
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    _getAllTaskFromDb();
  }
}
