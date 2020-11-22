import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Views/AddEmployee.dart';
import 'package:flutter/material.dart';

class ViewEmployees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: colors.buttonColor,
        cursorColor: colors.cursorColor,
      ),
      home: Scaffold(
        body: _ViewEmployees(),
        floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddEmployeeScreen()));
      },
      child: Icon(Icons.add),
      backgroundColor: colors.buttonColor,
    ),

      ),
    );
  }
}

class _ViewEmployees extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewEmployees();
}

class __ViewEmployees extends State<_ViewEmployees>{

EmployeeUIController uiController;
List<CafeEmployee> employees;

@override
  void initState() 
  {
  uiController  = new EmployeeUIController();
  _getEmployeesList();

  }

Future _getEmployeesList() async
{
  List<CafeEmployee> list = await uiController.ViewEmployeesList();

  setState((){
  employees = list;
    });
}

  Widget build(BuildContext context){
    return SingleChildScrollView(
        child: 
        employees == null 
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children:<Widget>[ Stack(
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                    ),

                  ),
                  Container(
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.only(left: 40,top: 25),

                    child:
                    Image.asset('images/logo.png'),
                  ),
                ],
              ),
              ]
            )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: employees.length,
            itemBuilder: (BuildContext context, int index) {
              return 
              GestureDetector(
                onTap: () {
                //TODO: Edit or Delete Employee
                },
                onLongPress:(){
                  showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    content: Text(
                                      'Do you want to remove Employee?',
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.heading2_size,
                                        color: colors.labelColor,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Container(
                                        // width: MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: colors.buttonColor,
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontFamily: Fonts.default_font,
                                              fontSize: Fonts.label_size,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // width: MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: colors.buttonColor,
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            //TODO: Delete Employee
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontFamily: Fonts.default_font,
                                              fontSize: Fonts.label_size,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              );
                },
                child:
                Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 10,
                ),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        height: 120.0,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                            employees.elementAt(index).imgURL == null ?'images/profile_pic.png' : employees.elementAt(index).imgURL,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: FittedBox(
                              child: Text(
                              employees.elementAt(index).Name,
                              style: TextStyle(
                                fontFamily: Fonts.default_font,
                                fontSize: 25,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                            ),
                            
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: FittedBox(
                              child: Text(
                              employees.elementAt(index).userType,
                              style: TextStyle(
                                fontFamily: Fonts.default_font,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              );
              
            }));
  }
}
