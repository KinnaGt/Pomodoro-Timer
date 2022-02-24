import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/responsive/responsive_app.dart';
import 'package:pomodoro/responsive/sizing_info.dart';




void main() async{
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Pomodoro()
  ));

  
}
class Pomodoro extends StatefulWidget {
  
  const Pomodoro({ Key? key }) : super(key: key);
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  
  static AudioCache player = AudioCache();
  
  static const maxSeconds = 60;
  int seconds = 0;
  bool isBreakTime = false;
  int minutes = 25;
  int breakTime = 5;
  int shortBreakTime = 5;
  int largeBreakTime = 15;
  int pomodoroTime = 25;
  int breakInterval = 4;
  int breaksCounter = 0;
  
  List<Color> gradientStudiying = [const Color(0xff7659FF),const Color(0xff7298D9)];
  List<Color> gradientBreak = [const Color(0xff171717),const Color(0xff252525)];
  Timer? timer;

 bool _notifications = true;
 bool _alarm = true;
 double _volumeAlarm = 60;
  startTimer(){
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      if(minutes >= 0 ){
        setState(() {
          seconds--;
          if(seconds <= 0){
              seconds = 60;
              minutes--;
              if(minutes <0 ){
                resetTimer();
              }
          }
        } );
      }else{
        resetTimer();
      }
    });
  }

  stopTimer({bool reset = true}){
    setState(() {
      timer?.cancel();
    });
  }
  play() async{
      player.clearAll();
      player.play('audio/alarm.mp3',volume: _volumeAlarm/100);
  }
  resetTimer(){
    if(_alarm)
    {
      play();
    }
    // NotificationService().showNotification(1,isBreakTime ? "Break Time " : "Focus Time",isBreakTime ? "You need a break for 5 minutes" : "You have 25 minutes to focus on it",5);
    
    setState(() {
      isBreakTime = !isBreakTime;
      seconds = 0;
      if (isBreakTime)
      {
        if(breaksCounter ==  breakInterval- 1){
        breakTime = largeBreakTime;
        breaksCounter = 0;
        }
        else {
          breakTime = shortBreakTime;
          breaksCounter++;
        }
      }
      minutes = isBreakTime ? breakTime : pomodoroTime;
      
      timer?.cancel();
    });
    
    if(_notifications){
      _showNotification();
    }
   
  }


  late FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var androidInitialize = AndroidInitializationSettings('@drawable/ic_stat_alarm_on');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize);
    localNotifications  = FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
  }

Future _showNotification() async {
  var androidDetails =  AndroidNotificationDetails('channel id', 'local notifications',channelDescription: 'This is the description',importance: Importance.high);
  var iOSDetails = IOSNotificationDetails();
  var generalNotificationDetails = NotificationDetails(android: androidDetails,iOS: iOSDetails);
  await localNotifications.show(0,isBreakTime ? "Break Time " : "Focus Time",isBreakTime ? "You need a break for 5 minutes" : "You have 25 minutes to focus on it",generalNotificationDetails);
}

  @override
  Widget build(BuildContext context) {
    late ResponsiveApp responsiveApp;
    responsiveApp= ResponsiveApp(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () async => false,
      child:  SafeArea(
      
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isBreakTime ?  gradientBreak : gradientStudiying ,
              begin:FractionalOffset(0.5,1)
            )
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Center(child: Text(
                  "Pomodoro",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveApp.headline3,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                  ),
                  )),
                  Expanded(child: Container(),),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    color: Colors.white,
                    onPressed: () => aboutPopUp(context),
                    //For receive a value  createPopUp(context).then((onValue){
                    //  
                    //})
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () { settingsPopUp(context); },
                  ),
                  SizedBox(width: 25,)
                ]),
              Expanded(
                child: CircularPercentIndicator(
                  circularStrokeCap:CircularStrokeCap.round,
                  percent: isBreakTime ? minutes/breakTime : minutes/pomodoroTime,
                  backgroundColor: Colors.white,
                  animateFromLastPercent: true,
                  animation: true ,
                  radius:250,
                  lineWidth: 15.0,
                  progressColor: isBreakTime ? Colors.indigo.shade300 : Color(0xFFf2be00),
                  center: Text(
                    "$minutes : " + (seconds).toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.white ),
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.only(top:5,bottom:25),
                child: Text(isBreakTime ? "Time to Break" : "Lets do it!",
                  style: TextStyle(
                    color:Colors.white,
                    fontSize: responsiveApp.bodyText1 ),
                ),
              ),
              buildButton(),
            ]
          )
        )
      ),
    ));
  }
  
  Future aboutPopUp(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("About Pomodoro",style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s.\n It uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.​\n"),
              SizedBox(height: 15,),
              Center(child: Text("5 Steps for Using the Pomodoro Technique\n",style: TextStyle(fontWeight: FontWeight.bold),)),
              Text("1 - Choose your task and total time to work on it.\n"),
              Text("2 - Set a timer to 25 minutes\n"),
              Text("3 - Work on the task for 25 minutes\n"),
              Text("4 - Take a 5-minute break for energy renewal, start another Pomodoro.\n"),
              Text("5 - Take a 20-30 minute break after completing four Pomodoros.")
            ]
          )),
          actions: [
            MaterialButton(
                child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.lime,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child : Center(child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),))
                ),
              onPressed: (){
                Navigator.of(context).pop();
                //For Pass The String to another context
                // Navigator.of(context).pop(customController.text.toString());
              },
            )
          ],
        );
      }
    );
  }

  
  Future settingsPopUp(BuildContext context){
    TextEditingController minutesCon = TextEditingController(text: pomodoroTime.toString());
    TextEditingController shortCon = TextEditingController(text: shortBreakTime.toString());
    TextEditingController largeCon = TextEditingController(text: largeBreakTime.toString());
    TextEditingController intervalCon = TextEditingController(text: breakInterval.toString());
    int minutesStudiying,shortBreak,largeBreak;
    return showDialog(
      context: context,
      builder: (context){
        
      return StatefulBuilder(
      builder: (context, setState) {
        final _formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: Text("Timer Settings",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF171717)),),
          content: SingleChildScrollView(  
            child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text("Pomodoro",style: TextStyle(fontSize: isMobileSmall(context)? 10 : 14),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 30,
                        width:  isMobileSmall(context) ? 50 : 75,
                        child:  Center(
                          child: TextFormField(
                            key: _formKey,
                            validator: (value) {
                              if (value == null || value.isEmpty || int.parse(value.toString()) <= 0) {
                                return 'Put a natural number';
                              }
                              return null;
                            },
                            controller: minutesCon,
                            maxLength: 2,
                            cursorColor: Colors.lime,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 20.0,color: Colors.orange),
                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: 
                              Colors.orange)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lime, width: 0.0),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lime),borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              counterText: "",
                            ),
                          ) 
                        ),
                      ),
                    ]
                  ),
                  SizedBox(width:  isMobileSmall(context) ? 35 : 25,),
                  Column(
                    children: [
                      Text("Short Break",style: TextStyle(fontSize: isMobileSmall(context)? 10 : 14)),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 30,
                        width:  isMobileSmall(context) ? 50 : 75,
                        child:  Center(
                          child: TextFormField(
                            maxLength: 2,
                            controller: shortCon,
                            // initialValue: shortBreakTime.toString() ,
                            cursorColor: Colors.lime,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 20.0,color: Colors.orange),
                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: 
                              Colors.orange)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lime, width: 0.0),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.limeAccent),borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              counterText: "",
                            ),
                          ) 
                        ),
                      ),
                    ]
                  ),
                  
                  SizedBox(width:  isMobileSmall(context) ? 35 : 25,),
                  Column(
                    children: [
                      Text("Large Break",style: TextStyle(fontSize: isMobileSmall(context)? 10 : 14)),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 30,
                        width:  isMobileSmall(context) ? 50 : 75,
                        child:  Center(
                          child: TextFormField(
                            //initialValue:  largeBreakTime.toString(),
                            controller: largeCon,
                            maxLength: 2,
                            cursorColor: Colors.lime,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 20.0,color: Colors.orange),
                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: 
                              Colors.orange)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lime, width: 0.0),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lime),borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              counterText: "",
                            ),
                          ) 
                        ),
                      ),
                    ]
                  ),


                ],
              ),
              
              dividerSections(),
              Row(
                children: [
                  SizedBox(width: 5,),
                  Text("Long Break interval"),
                  Expanded(child: Container(),),
                  SizedBox(
                        height: 30,
                        width: isMobileSmall(context) ? 50 : 75,
                        child:  Center(
                          child: TextFormField(
                            //initialValue:breakInterval.toString(),
                            controller: intervalCon,
                            maxLength: 2,
                            cursorColor: Colors.lime,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 20.0,color: Colors.orange),
                              focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: 
                              Colors.orange)),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.lime, width: 0.0),
                              ),
                              contentPadding: EdgeInsets.all(0),
                             
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lime),borderRadius: BorderRadius.circular(20)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              counterText: "",
                            ),
                          ) 
                        ),
                      ),
                  SizedBox(width: 30,)
                ],
              ),
              dividerSections(),
              Row(
                children: [
                  SizedBox(width: 5,),
                  Text("Notifications"),
                  Expanded(child: Container()),
                  Switch(
                    value: _notifications,
                    onChanged: (bool isOn) {
                      print(isOn);
                      setState(() {
                        _notifications = !_notifications;
                        
                      });
                    },
                    activeColor: Colors.lime,
                  ),
                  SizedBox(width: 30,),
                ],),
              dividerSections(),
              Row(
                children: [
                  SizedBox(width: 5,),
                  Text("Alarm Sound"),
                  Expanded(child: Container()),
                  Switch(
                    value: _alarm,
                    onChanged: (bool val) { 
                        setState(() {
                          _alarm = val;
                        });
                     }, 
                    activeColor: Colors.lime,
                  ),
                  
                  SizedBox(width: 30,),
                ],
              ),
              Slider(
                activeColor: Colors.lime,
                label: _volumeAlarm.round().toString(),
                divisions: 20,
                onChanged: (double value) {
                  setState(() {
                    _volumeAlarm = value;
                  });
                },
                 max: 100,
                value: _volumeAlarm,
              ),
              dividerSections()
            ],
          )),
          actions: [
            MaterialButton(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.lime,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                    child : Center(child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),))
                  ),),
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                  pomodoroTime = int.parse(minutesCon.text.toString());
                  shortBreakTime = int.parse(shortCon.text.toString());
                  largeBreakTime = int.parse(largeCon.text.toString());
                  breakInterval = int.parse(intervalCon.text.toString());
                  Navigator.of(context).pop();
                }
                  
                //For Pass The String to another context
                // Navigator.of(context).pop(customController.text.toString());
              },
            ),
          ],
        );
      });
      }
    );
  }
  
  
  Widget dividerSections(){
    return Column(
      children: [
        SizedBox(height: 10,),
        Divider(),
        SizedBox(height: 10,)
      ],
    );
  }
  
  
  Widget buildButton(){
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0; 
    return Container(
      width: 450,
        decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:  Radius.circular(20))
        ) ,
        child: Stack(
        children: [
        Center(
          child: IconButton(
          color:Color(0xFF171717),
            icon:  isRunning ? Icon(Icons.pause_outlined) : Icon(Icons.play_arrow_outlined),
            onPressed: isRunning ? stopTimer : startTimer ,
            iconSize: 120,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              child: IconButton(
            icon : Icon(Icons.skip_next_outlined),
            onPressed:  () => confirmationDialog(context),
            iconSize: 60,
        ),
          ),),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   child: IconButton(
        //   icon: Icon(Icons.notifications),
        //   onPressed: () => {
        //     _showNotification()
        //   } 
        //   ))
        ],
      )
    );
      
  }


  Future confirmationDialog(BuildContext context){
    return showDialog(
      barrierDismissible: false, // user must tap button!
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure you want to finish the round early? '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                resetTimer();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}



