import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProgramPage extends StatefulWidget {
  final DocumentSnapshot program;

  EditProgramPage({required this.program});

  @override
  _EditProgramPageState createState() => _EditProgramPageState();
}

class _EditProgramPageState extends State<EditProgramPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.program['name']);
    _descriptionController = TextEditingController(text: widget.program['description']);
    _durationController = TextEditingController(text: widget.program['duration']);
    _selectedType = widget.program['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Program'),
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
                  labelText: 'Program Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the program name';
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
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (weeks)',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Program Type',
                ),
                items: ['Calisthenics', 'Weighted', 'Weighted Calisthenics']
                    .map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('programs')
                        .doc(widget.program.id)
                        .update({
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'duration': _durationController.text,
                      'type': _selectedType,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Program Updated')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Program'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
