import 'package:flutter/material.dart';

class CompletedList extends StatelessWidget {
  const CompletedList(
      {super.key,
        required this.taskName,
        required this.returnTask,
      });

  final String taskName;
  final Function returnTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.pink[300],
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      padding: EdgeInsets.all(6),
      child: ListTile(
        title: Text(
          taskName,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            decorationColor: Colors.white,
            decoration: TextDecoration.lineThrough,
            decorationThickness: 2,
          ),
        ),
        trailing: returnTask(context) as IconButton,
      ),
    );
  }
}
