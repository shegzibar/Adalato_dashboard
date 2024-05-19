import 'package:adalato_dashboard/pages/database%20pages/program/edit_program.dart';
import 'package:adalato_dashboard/pages/database%20pages/program/programs.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout.dart';
import 'package:adalato_dashboard/pages/database%20pages/workout/workout_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class programlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programs List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('programs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Programs Found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var program = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              DocumentSnapshot programDoc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (BuildContext context) => WorkoutsListPage(),
                    ));
                  },
                  title: Text(program['name']),
                  subtitle: Text('Duration: ${program['duration']} weeks'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditProgramPage(program: programDoc),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProgram(context, programDoc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => programs(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteProgram(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('programs').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Program deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete program: $e')),
      );
    }
  }
}
