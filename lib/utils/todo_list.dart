import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.taskName,
    required this.createdAt,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editTask,
  });

  final String taskName;
  final DateTime createdAt;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext, String) editTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.pink[400],        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              checkColor: Colors.pink,
              activeColor: Colors.pink[50],
              side: BorderSide(
                color: Colors.white,
              ),
            ),
            Text(
              taskName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    final TextEditingController controller =
                        TextEditingController(
                            text: taskName); // input с названием задания
                    showDialog(
                      // pop-up окно
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Отредактировать задание',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        content: TextFormField(
                          controller: controller,
                          maxLength: (MediaQuery.of(context).size.width / 14.0)
                              .floor(),
                          decoration: InputDecoration(
                              hintText: 'Введите название задачи'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteFunction!(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Удалить',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // Закрытие окна
                            child: Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              editTask(context, controller.text);
                              Navigator.pop(context);
                            },
                            child: Text('Сохранить'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
