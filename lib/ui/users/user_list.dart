import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_exam_app/bloc/user_bloc.dart';
import 'package:firebase_exam_app/bloc/user_event.dart';
import 'package:firebase_exam_app/models/user_model.dart';
import 'package:firebase_exam_app/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_user_screen.dart';
import 'update_user_screen.dart';

class UserList extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final userCollection = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final user = User.fromJson(doc.data() as Map<String, dynamic>);
              final userId = doc.id;
              return Dismissible(
                key: Key(userId),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red.withOpacity(0.7),
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<UserBloc>().add(DeleteUser(userId));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('User deleted')));
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => UpdateUserScreen(userId: userId, user: user),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: Text('Age: ${user.age}, ${user.email}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        context.read<UserBloc>().add(DeleteUser(userId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User deleted')),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
