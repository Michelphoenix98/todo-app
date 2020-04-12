import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Destiny',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(title: 'Destiny'),
    );
  }
}
final List<Event> _events = <Event>[
  Event("21","Thu","May","Meeting with boss",true,true),
  Event("22","Fri","May","Write a notice",false,false),
  Event("23","Sat","May","Buy groceries",true,true),
  Event("24","Sun","May","Read documents",true,true),

];
final GlobalKey<AnimatedListState> _listKey = GlobalKey();
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class Event{
  String day;
  String dayNo;
  String month;
  String label;
  bool isImportant;
  bool isComplete;
  Event(this.dayNo,this.day,this.month,this.label,this.isImportant,this.isComplete);
}
class _HomePageState extends State<HomePage> {

  bool showAddTaskButton=true;

  Widget _buildTiles(Event event,[int index]){

    return ListTile(
      key: ObjectKey(event),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${event.dayNo}",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
            Text("${event.day}",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
            Text("${event.month}",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 10),),
          ],
        ),
      ),
      title: Text(
        "${event.label}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(event.isImportant?Icons.warning:null, color: event.isImportant?Colors.yellowAccent:null)  ,
          Text("${event.isImportant?"Important":""}", style: TextStyle(color: Colors.white))
        ],
      ),
      trailing:_buildCheckBox(event),

    );
  }
  Widget _buildCheckBox(Event event){
    return Checkbox(

      value:event.isComplete,
      onChanged: (bool state){
        setState(() {
          event.isComplete=state;
        });
      },);
  }
  @override
  Widget build(BuildContext context) {
    final taskViewButton=IconButton(
      icon: Icon(Icons.pie_chart, color: !showAddTaskButton?Colors.indigo:Colors.white),
      onPressed: () {
        setState(() {
          showAddTaskButton=false;

        });

      },
    );
    final todoButton= IconButton(
      icon: Icon(Icons.assignment, color: showAddTaskButton?Colors.indigo:Colors.white),

      onPressed: () {
        setState(() {
          showAddTaskButton=true;
        });

      },
    );
    final addTaskButton=FloatingActionButton(

      tooltip: 'Add new task',
      child: Icon(Icons.add),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      backgroundColor: Colors.red,
      mini:true,
      onPressed: (){
        showDialog(

          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return
            Container(
              child :CustomDialog(





              ));
          },
        );
      },
    );
    final appBar = AppBar(
      elevation: 0.1,
      //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );
    final navBar = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            todoButton,
            VerticalDivider(
                color:Colors.grey
            ),
            taskViewButton,

          ],
        ),
      ),
    );
    return Scaffold(
    //  resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(64, 75, 96, .9),
      appBar: appBar,
      body:
      Column(
          mainAxisSize: MainAxisSize.min,

          children:[
            Flexible(
              fit: FlexFit.loose,
              child:

              showAddTaskButton? Container(
                child: AnimatedList(

key: _listKey,
                  initialItemCount:_events.length,
                  itemBuilder: (BuildContext context, int index,Animation animation) {
                    print(index);
                    final evtObject=_events[index];
                    return FadeTransition(
                      opacity: animation,
                      child:  Dismissible(
                        // background: Container(color: Colors.red),
                        key:ObjectKey(evtObject),
                        onDismissed:(direction) {
                          setState(() {
                           var task= _events.removeAt(index);
                            _listKey.currentState.removeItem(
                              index,
                                  (BuildContext context, Animation<double> animation) {
                               return  _buildTiles(task);

                              },
                              duration: Duration(milliseconds: 00),
                            );
                          });

                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(content: Text("${evtObject.label} deleted"), action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                              setState(() {
                                _events.insert(index, evtObject);
                                _listKey.currentState
                                    .insertItem(index, duration: Duration(milliseconds: 500));
                              });

                            },
                          ),));
                        },
                        child:Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                            child: _buildTiles(evtObject,index),

                          ),

                        ),

                        // Show a red background as the item is swiped away.


                      ),
                    );

                  },
                ),

              ):Container(

              ),

            ),

            SizedBox(height: 20,)
          ]
      ),

      floatingActionButton:showAddTaskButton?addTaskButton:null ,
      bottomNavigationBar: navBar,
    );
  }
}
class CustomDialog extends StatefulWidget{
  @override
  CustomDialogState createState() => CustomDialogState();
}
class CustomDialogState extends State<CustomDialog> {

bool isImportant=false;
  @override
  Widget build(BuildContext context) {
    return Dialog(

      elevation: 0.4,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        width: 1200,
        height: 300,
        decoration: new BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, 10),
          shape: BoxShape.rectangle,
          //borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child:
        SingleChildScrollView(
          child:
        Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
           Row(
            children:[Icon(Icons.add,size: 35,color: Colors.white),
            Text("Add new task",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),]),
            SizedBox(height: 16.0),




              Column(


                children: <Widget>[
                  Container(
                      width:600.0,
                      child:
                      TextField(

                        decoration: InputDecoration(

                          border:OutlineInputBorder(),
                          hintText:'Label: eg Buy groceries',
                          hintStyle: TextStyle(color:Colors.white),


                        ),


                      )),
Row(
children:[
  Text("Important",style:TextStyle(color:Colors.white)),
                 Checkbox(

                   value:isImportant,
                   onChanged: (bool state){
                     setState(() {
isImportant=state;
                     });
                   },
                 ),],),

                  SizedBox(height: 70.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[ new FlatButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                      new FlatButton(
                        child: new Text("Save"),
                        onPressed: () {
                          //code to save
                          int index=_events.length;
                          _events.insert(0,new Event("31","Thur","Mar","Buy groceries",isImportant,false));
                          _listKey.currentState
                              .insertItem(0, duration: Duration(milliseconds: 500));
                          Navigator.of(context).pop();
                        },
                      ),],
                  ),

                ],
              ),


          ],
        ),
      ),
      ),
    );
  }
}
