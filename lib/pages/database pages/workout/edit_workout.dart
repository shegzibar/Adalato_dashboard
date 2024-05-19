import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditWorkoutPage extends StatefulWidget {
  final DocumentSnapshot workout;

  EditWorkoutPage({required this.workout});

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workoutNameController;
  late String _selectedProgram;
  late String _selectedProgramId;
  List<DropdownMenuItem<String>> _programsDropdownItems = [];

  @override
  void initState() {
    super.initState();
    _workoutNameController = TextEditingController(text: widget.workout['name']);
    _selectedProgram = widget.workout['programId'];
    _selectedProgramId = widget.workout['programId'];
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    QuerySnapshot programsSnapshot =
    await FirebaseFirestore.instance.collection('programs').get();
    List<DropdownMenuItem<String>> programsItems = [];
    for (var doc in programsSnapshot.docs) {
      programsItems.add(
        DropdownMenuItem(
          value: doc.id,
          child: Text(doc['name']),
        ),
      );
    }
    setState(() {
      _programsDropdownItems = programsItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _workoutNameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the workout name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedProgram,
                decoration: InputDecoration(
                  labelText: 'Program',
                ),
                items: _programsDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedProgram = value!;
                    _selectedProgramId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a program';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('workouts')
                        .doc(widget.workout.id)
                        .update({
                      'name': _workoutNameController.text,
                      'programId': _selectedProgramId,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Workout Updated')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
