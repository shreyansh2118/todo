import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/model/todo.dart';

class TodoItems extends StatefulWidget {
  final Todo todo;
  final void Function(Todo todo) handleTodoCheckBox;
  final void Function(String id) onDelete;
  final void Function(Todo todo) onEdit;

  const TodoItems({
    Key? key,
    required this.todo,
    required this.handleTodoCheckBox,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<TodoItems> createState() => _TodoItemsState();
}

class _TodoItemsState extends State<TodoItems> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    tz.initializeTimeZones(); // Initialize timezone data
  }

  // Get priority color
  Color _getPriorityColor() {
    switch (widget.todo.priority) {
      case 'Very Urgent':
        return Colors.red[100]!;
      case 'Urgent':
        return Colors.yellow[100]!;
      case 'Normal':
        return Colors.green[100]!;
      default:
        return Colors.white;
    }
  }

  // Show notification with specific title and description
  void showNotification(String notificationTitle, String notificationDesc, DateTime scheduledDateTime) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: notificationTitle,
        body: notificationDesc,
      ),
      schedule: NotificationCalendar(
        year: scheduledDateTime.year,
        month: scheduledDateTime.month,
        day: scheduledDateTime.day,
        hour: scheduledDateTime.hour,
        minute: scheduledDateTime.minute,
        second: scheduledDateTime.second,
        millisecond: scheduledDateTime.millisecond,
      ),
    );
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        DateTime scheduledDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Call the showNotification method with the selected time
        showNotification(
          widget.todo.title,
          widget.todo.description,
          scheduledDateTime,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120, // Increased height to accommodate the description
        decoration: BoxDecoration(
          color: _getPriorityColor(), // Set background color based on priority
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: () {
            widget.handleTodoCheckBox(widget.todo);
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          tileColor: _getPriorityColor(), // Set tile color based on priority
          leading: widget.todo.isdone
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.green,
                ),
          title: Text(
            widget.todo.title,
            style: TextStyle(
              decoration:
                  widget.todo.isdone ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            widget.todo.description,
            style: TextStyle(
              decoration:
                  widget.todo.isdone ? TextDecoration.lineThrough : null,
            ),
          ), // Display description
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  widget.onDelete(widget.todo.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.alarm, color: Colors.purple),
                onPressed: () {
                  _selectDateTime(context); // Show date and time picker
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController _titleController =
        TextEditingController(text: widget.todo.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.todo.description);

    // Set initial value for priority
    String selectedPriority = widget.todo.priority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Enter new title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(hintText: 'Enter new description'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items:
                    ['Very Urgent', 'Urgent', 'Normal'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPriority = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  labelText: 'Priority',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedTitle = _titleController.text;
                final updatedDescription = _descriptionController.text;
                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  widget.onEdit(
                    widget.todo.copyWith(
                      title: updatedTitle,
                      description: updatedDescription,
                      priority: selectedPriority, // Update priority
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
