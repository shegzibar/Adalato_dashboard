import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class createExercisesPage extends StatefulWidget {
  @override
  _createExercisesPageState createState() => _createExercisesPageState();
}

class _createExercisesPageState extends State<createExercisesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pictureUrlController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedWorkout = '';
  String _selectedWorkoutId = '';
  final String documentId = Uuid().v4();
  List<DropdownMenuItem<String>> _workoutsDropdownItems = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    QuerySnapshot workoutsSnapshot =
    await FirebaseFirestore.instance.collection('workouts').get();
    List<DropdownMenuItem<String>> workoutsItems = [];
    for (var doc in workoutsSnapshot.docs) {
      workoutsItems.add(
        DropdownMenuItem(
          value: doc.id,
          child: Text(doc['name']),
        ),
      );
    }
    setState(() {
      _workoutsDropdownItems = workoutsItems;
      if (workoutsItems.isNotEmpty) {
        _selectedWorkout = workoutsItems.first.value!;
        _selectedWorkoutId = workoutsItems.first.value!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _pictureUrlController,
                decoration: InputDecoration(
                  labelText: 'Picture URL',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the picture URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _youtubeLinkController,
                decoration: InputDecoration(
                  labelText: 'YouTube Link',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the YouTube link';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedWorkout,
                decoration: InputDecoration(
                  labelText: 'Workout',
                ),
                items: _workoutsDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedWorkout = value!;
                    _selectedWorkoutId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a workout';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance.collection('exercises').doc(documentId).set({
                      'name': _nameController.text,
                      'pictureUrl': _pictureUrlController.text,
                      'youtubeLink': _youtubeLinkController.text,
                      'description': _descriptionController.text,
                      'workoutId': _selectedWorkoutId,
                      'documentId': documentId,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Exercise Added')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
