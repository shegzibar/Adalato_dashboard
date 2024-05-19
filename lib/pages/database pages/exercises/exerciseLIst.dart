import 'package:adalato_dashboard/pages/database%20pages/exercises/EditExercisePage.dart';
import 'package:adalato_dashboard/pages/database%20pages/exercises/exercises.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => createExercisesPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('exercises').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot exercise = snapshot.data!.docs[index];

              return ListTile(
                title: Text(exercise['name']),
                subtitle: Text('Workout ID: ${exercise['workoutId']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _deleteExercise(context, exercise.id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExercisePage(documentId: exercise),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteExercise(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('exercises').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete exercise: $e')),
      );
    }
  }
}
