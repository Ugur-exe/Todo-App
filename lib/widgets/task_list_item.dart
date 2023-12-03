import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(
                0,
                4,
              ),
            )
          ]),
      child: ListTile(
        autofocus: true,
        leading: GestureDetector(
            onTap: () {
              setState(() {
                widget.task.isComleted = !widget.task.isComleted;
                _localStorage.updateTask(task: widget.task);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isComleted ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            )),
        title: widget.task.isComleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                minLines: 1,
                maxLength: null,
                textInputAction: TextInputAction.done,
                controller: _taskNameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (newValue) {
                  if (newValue.length >= 3) {
                    widget.task.name = newValue;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
