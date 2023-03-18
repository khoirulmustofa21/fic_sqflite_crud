import 'package:flutter/material.dart';
import '../cat.dart';
import '../cat_db.dart';

class CatListScreen extends StatefulWidget {
  const CatListScreen({Key? key}) : super(key: key);

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  final _catDB = CatDB();
  late Future<List<Cat>> _cats;
  @override
  void initState() {
    super.initState();
    _refreshCatList();
  }

  void _refreshCatList() {
    setState(() {
      _cats = _catDB.cats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat List'),
      ),
      body: FutureBuilder(
        future: _cats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          List<Cat> cats = snapshot.data as List<Cat>;
          return ListView.builder(
            itemCount: cats.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cats[index].name),
                subtitle: Text('Age: ${cats[index].age}'),
                onTap: () {
                  _showAddUpdateCatDialog(cats[index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUpdateCatDialog(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddUpdateCatDialog(Cat? cat) {
    bool isUpdating = (cat != null);
    final TextEditingController nameController =
    TextEditingController(text: isUpdating ? cat.name : '');
    final TextEditingController ageController =
    TextEditingController(text: isUpdating ? '${cat.age}' : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdating ? 'Update Cat' : 'Add Cat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (isUpdating) {
                  await _catDB.updateCat(Cat(
                    id: cat.id,
                    name: nameController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                  ));
                } else {
                final date = DateTime.now();
                final milliseconds = date.millisecondsSinceEpoch;
                  await _catDB.insertCat(Cat(
                    id: milliseconds,
                    name: nameController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                  ));
                }
                _refreshCatList();
                Navigator.of(context).pop();
              },
              child: Text(isUpdating ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}