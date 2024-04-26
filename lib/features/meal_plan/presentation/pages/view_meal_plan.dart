import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:evercook/features/meal_plan/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewMealPlan extends StatefulWidget {
  const ViewMealPlan({super.key});

  @override
  State<ViewMealPlan> createState() => _ViewMealPlanState();
}

class _ViewMealPlanState extends State<ViewMealPlan> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(DateTime.now()),
                        style: const TextStyle(color: Colors.red),
                      ),
                      const Text('Today')
                    ],
                  ),
                ),
                MyButton(
                  label: '+ Add Task',
                  onTap: () => null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.blue,
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              dayTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              monthTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              onDateChange: (date) {
                _selectedDate = date;
              },
            ),
          ),
        ],
      ),
    );
  }
}
