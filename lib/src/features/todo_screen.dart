import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TextEditingController _todoController;

  @override
  void initState() {
    super.initState();
    _todoController = TextEditingController();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final randomId =
                FirebaseFirestore.instance.collection('test').doc().id;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('todos')
                .doc(randomId)
                .set(
              {
                "id": randomId,
                "title": _todoController.text,
              },
            );
            _todoController.clear();
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('todos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      final todos =
                          snapshot.data!.docs.map((e) => e.data()).toList();
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final currentTodo = todos[index];

                          return Dismissible(
                            key: Key(currentTodo['id']),
                            onDismissed: (direction) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('todos')
                                  .doc(currentTodo['id'])
                                  .delete();
                            },
                            child: ListTile(
                              title: Text(currentTodo['title']),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.connectionState !=
                        ConnectionState.done) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView(
                          children: const [
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                            SizedBox(height: 16),
                            LoadingLine(),
                          ],
                        ),
                      );
                    } else {
                      return const Icon(Icons.error);
                    }
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  controller: _todoController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingLine extends StatelessWidget {
  const LoadingLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
