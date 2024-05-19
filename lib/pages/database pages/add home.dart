import 'package:adalato_dashboard/pages/database%20pages/exercises/exerciseLIst.dart';
import 'package:adalato_dashboard/pages/database%20pages/exercises/exercises.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/program_list.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/programs.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout_list.dart';
import 'package:flutter/material.dart';

class add_home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push (
                          context,
                          MaterialPageRoute (
                            builder: (BuildContext context) => programlist(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.blueGrey], // Example gradient colors
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                          child: Center(
                            child: Text(
                              'Programs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),

                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push (
                            context,
                            MaterialPageRoute (
                              builder: (BuildContext context) =>  WorkoutsListPage(),
                            ));
                      },
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.indigo, Colors.blueGrey], // Example gradient colors
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Workouts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push (
                            context,
                            MaterialPageRoute (
                              builder: (BuildContext context) =>  ExercisesListPage(),
                            ));
                      },
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.red, Colors.blueGrey], // Example gradient colors
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Exercises',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),

                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}


