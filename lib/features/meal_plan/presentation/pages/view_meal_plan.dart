import 'package:evercook/core/common/widgets/skeleton/meal_plan_skeleton.dart';
import 'package:evercook/core/constant/db_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final response = await Supabase.instance.client.from(DBConstants.mealPlan).select('*, recipes(name)').eq(
          'user_id',
          Supabase.instance.client.auth.currentSession!.user.id,
        );
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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              heroTag: Null,
              alwaysShowMiddle: false,
              largeTitle: Text(
                'Meal Plan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              middle: Text(
                'Meal Plan',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ];
        },
        body: isLoading
            ? SkeletonMealPlan()
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  DateTime date = weekDays[index];
                  DateTime today = DateTime.now();
                  DateTime justDate = DateTime(today.year, today.month, today.day);
                  bool isToday = date.year == justDate.year && date.month == justDate.month && date.day == justDate.day;

                  List<Map<String, dynamic>> meals = mealPlansByDay[date] ?? [];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 226, 227, 227),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    DateFormat.d().format(date), // Date on the left
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: isToday
                                              ? Color.fromRGBO(221, 56, 32, 1)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground, // Color is red if it's today, otherwise black
                                        ),
                                  ),
                                  const SizedBox(width: 10), // Add some space between date and the right column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat.EEEE().format(date), // Day of the week
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Text(
                                        DateFormat.MMMM().format(date), // Month
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Color.fromARGB(255, 221, 56, 32),
                                ), // Add your desired icon here
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                              ),
                            ],
                          ),
                        ),
                        ...meals.map((meal) {
                          return Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: const Text('Are you sure you want to delete this recipe?'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  deleteMealPlan(meal['id']);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: const Color(0xFFFF0000),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.subdirectory_arrow_right_rounded,
                                      size: 22,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      // Using Expanded here
                                      child: Text(
                                        '${meal['recipes']['name']}',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // if (meals.isEmpty)
                        //   const Text(
                        //     'No meal plans for this day',
                        //     style: TextStyle(fontSize: 16, color: Colors.grey),
                        //   ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
