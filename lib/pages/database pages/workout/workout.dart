import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class WorkouteditPage extends StatefulWidget {
  @override
  _WorkouteditPageState createState() => _WorkouteditPageState();
}

class _WorkouteditPageState extends State<WorkouteditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workoutNameController = TextEditingController();
  String _selectedProgram = '';
  String _selectedProgramId = '';
  final String documentId = Uuid().v4();
  List<DropdownMenuItem<String>> _programsDropdownItems = [];

  @override
  void initState() {
    super.initState();
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
      if (programsItems.isNotEmpty) {
        _selectedProgram = programsItems.first.value!;
        _selectedProgramId = programsItems.first.value!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
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
                    await FirebaseFirestore.instance.collection('workouts').doc(documentId).set({
                      'name': _workoutNameController.text,
                      'programId': _selectedProgramId,
                      'documentId': documentId,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Workout Added')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
