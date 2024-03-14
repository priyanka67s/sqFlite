import 'package:flutter/material.dart';
import 'package:sqldatabase/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //step 2
  List<Map<String,dynamic>> _journals =[];
  bool isLoading = true;
  void _refreshJournal() async{
    final data = await DatabaseHelper.getItems(); //reading the saved data
    setState(() {
      _journals = data; //load to list
      isLoading = false; // showing the data by list using ListView.builder
    });
  }
  @override
  void initState(){
    super.initState();
    DatabaseHelper.openDatabase().then((value) => _refreshJournal()); //frim dbheper .dart
  }
  @override
  void dispose(){
    super.dispose();
    DatabaseHelper.closeDatabase(); //once compulsory have to close the database
  }
  //String ? data;
  //step3
  final  TextEditingController titleController = TextEditingController();
  final TextEditingController descpController = TextEditingController();


  void _showForm(int? id) async{
    if (id!=null){
      //how to read
      final existJournal = _journals.firstWhere((element) => element['id']== id); //key
      titleController.text= existJournal['title'];//key
      descpController.text = existJournal['description']; //key
    }
    showModalBottomSheet(context: context, builder: (_) => Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(border :OutlineInputBorder(),hintText : 'Enter the Title',),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(border :OutlineInputBorder(),hintText : 'Enter the Description',),
            controller: descpController,
          ),
          ElevatedButton(onPressed: ()async{
            if(id==null){
              await _addItem();
            }
            if(id!=null){
              await _update(id);
            }
            Navigator.of(context).pop();
            titleController.text= '';
            descpController.text = '';
          }, child: Text(id == null ? 'Create': 'Update'))
        ],
      ),
    ));
  }
  Future <void> _addItem() async {
    await DatabaseHelper.createItem(
        titleController.text,
        descpController.text
    );
    _refreshJournal();
  }

  Future <void>_update(int id) async{
    await DatabaseHelper.updateItem(
        id, titleController.text, descpController.text);
    _refreshJournal();
  }
  void _delete(int id) async{
    await DatabaseHelper.deleteItem(id);
    _refreshJournal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[200],
      appBar: AppBar(title: Text('SQFlite Database'),backgroundColor: Colors.cyan,),
      body:
       isLoading? Center(child: CircularProgressIndicator(),)
          : ListView.builder(
        itemCount: _journals.length,
          itemBuilder: (context, int index){
          return ListTile(
            tileColor: Colors.greenAccent,
            selectedTileColor: Colors.black45,
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    _showForm(_journals[index]['id']);
                  }, icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){
                    _delete(_journals[index]['id']);
                  }, icon: Icon(Icons.delete))
                ],
              ),
            ),
          );
          }),
      //step 1
      floatingActionButton:FloatingActionButton(
        onPressed: ()=> _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
