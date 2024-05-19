import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditExercisePage extends StatefulWidget {
  final DocumentSnapshot documentId;

  EditExercisePage({required this.documentId});

  @override
  _EditExercisePageState createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _pictureUrlController;
  late TextEditingController _youtubeLinkController;
  late TextEditingController _descriptionController;
  String? _selectedWorkoutId;
  List<DropdownMenuItem<String>> _workoutDropdownItems = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _pictureUrlController = TextEditingController();
    _youtubeLinkController = TextEditingController();
    _descriptionController = TextEditingController();
    _fetchWorkouts();
    _fetchExerciseData();
  }

  Future<void> _fetchWorkouts() async {
    var workoutSnapshot = await FirebaseFirestore.instance.collection('workouts').get();
    var workoutItems = workoutSnapshot.docs.map((doc) {
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(doc['name']),
      );
    }).toList();

    setState(() {
      _workoutDropdownItems = workoutItems;
    });
  }

  Future<void> _fetchExerciseData() async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('exercises').doc(widget.documentId.id).get();
    var exerciseData = documentSnapshot.data()!;
    _nameController.text = exerciseData['name'];
    _pictureUrlController.text = exerciseData['pictureUrl'];
    _youtubeLinkController.text = exerciseData['youtubeLink'];
    _descriptionController.text = exerciseData['description'];
    _selectedWorkoutId = exerciseData['workoutId'];
    if (_workoutDropdownItems.any((item) => item.value == _selectedWorkoutId)) {
      setState(() {
        _selectedWorkoutId = exerciseData['workoutId'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Exercise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pictureUrlController,
                decoration: InputDecoration(labelText: 'Picture URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the picture URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _youtubeLinkController,
                decoration: InputDecoration(labelText: 'YouTube Link'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: _selectedWorkoutId,
                onChanged: (newValue) {
                  setState(() {
                    _selectedWorkoutId = newValue!;
                  });
                },
                items: _workoutDropdownItems,
                decoration: InputDecoration(labelText: 'Select Workout'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a workout';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection('exercises').doc(widget.documentId.id).update({
                      'name': _nameController.text,
                      'pictureUrl': _pictureUrlController.text,
                      'youtubeLink': _youtubeLinkController.text,
                      'description': _descriptionController.text,
                      'workoutId': _selectedWorkoutId,
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pictureUrlController.dispose();
    _youtubeLinkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
