import 'package:evercook/core/constant/db_constants.dart';
import 'package:evercook/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewMealPlan extends StatefulWidget {
  const ViewMealPlan({Key? key}) : super(key: key);

  @override
  State<ViewMealPlan> createState() => _ViewMealPlanState();
}

class _ViewMealPlanState extends State<ViewMealPlan> {
  List<DateTime> weekDays = [];
  Map<DateTime, List<Map<String, dynamic>>> mealPlansByDay = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    weekDays = getWeekDays();
    fetchMealPlans();
  }

  List<DateTime> getWeekDays() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  //todo separate to business logic
  void fetchMealPlans() async {
    final response = await Supabase.instance.client.from(DBConstants.mealPlan).select('*, recipes(title)');
    final List<Map<String, dynamic>> mealPlans = response;
    for (var day in weekDays) {
      mealPlansByDay[day] =
          mealPlans.where((mealPlan) => mealPlan['date'] == DateFormat('yyyy-MM-dd').format(day)).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  //todo separate to business logic
  void deleteMealPlan(String id) async {
    setState(() => isLoading = true);
    await Supabase.instance.client.from(DBConstants.mealPlan).delete().match({'id': id});
    fetchMealPlans(); // Refresh the meal plans after deleting
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('Meal Plan'),
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekDays.map((date) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Container(
                            width: 60, // Optionally set a fixed width for each container for uniformity
                            decoration: BoxDecoration(
                              color: date.day == DateTime.now().day ? Colors.blue.shade300 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat.E().format(date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), // Weekday
                                Text(DateFormat.d().format(date), style: const TextStyle(fontSize: 24)), // Date
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: weekDays.length,
                    itemBuilder: (context, index) {
                      DateTime date = weekDays[index];
                      List<Map<String, dynamic>> meals = mealPlansByDay[date] ?? [];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 241, 242, 241),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.EEEE().format(date),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ...meals.map((meal) {
                              LoggerService.logger.i(meal);
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${meal['recipes']['title']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Adjust overflow behavior as needed
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => deleteMealPlan(meal['id']),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            if (meals.isEmpty)
                              const Text(
                                'No meal plans for this day',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
