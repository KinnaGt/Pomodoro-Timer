import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MaterialApp(
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
  static const maxSeconds = 60;
  int seconds = 0;
  bool isBreakTime = false;
  int minutes = 25;
  int breakTime = 5;
  int breaksCounter = 0;
  List<Color> gradientStudiying = [const Color(0xff7659FF),const Color(0xff7298D9)];
  List<Color> gradientBreak = [const Color(0xff171717),const Color(0xff252525)];
  Timer? timer;

 bool isInstructionView = true;
  @override
  void initState() {
    isInstructionView = isInstructionView;
    super.initState();
  }
  startTimer(){
    timer = Timer.periodic(Duration(milliseconds: 1), (timer) { 
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

  resetTimer(){
    setState(() {
      isBreakTime = !isBreakTime;
      seconds = 0;
      if (isBreakTime)
      {
        if(breaksCounter == 3){
        breakTime = 15;
        breaksCounter = 0;
        }
        else {
          breakTime = 5;
          breaksCounter++;
        }
      }
      minutes = isBreakTime ? breakTime : 25;
      
      timer?.cancel();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return SafeArea(
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
                  SizedBox(width: 70,),
                  Center(child: Text(
                  "Pomodoro",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
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
                  percent: isBreakTime ? minutes/breakTime : minutes/25,
                  backgroundColor: Colors.white,
                  animateFromLastPercent: true,
                  animation: true ,
                  radius:250,
                  lineWidth: 20.0,
                  progressColor: isBreakTime ? Colors.indigo : Color(0xFFF9B384),
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
                    fontSize: 26 ),
                ),
              ),
              buildButton(),
            ]
          )
        )
      ),
    );
  }
  
  Future aboutPopUp(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("About Pomodoro",style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. It uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.​\n"),
              SizedBox(height: 15,),
              Center(child: Text("5 Steps for Using the Pomodoro Technique\n",style: TextStyle(fontWeight: FontWeight.bold),)),
              Text("1 - Choose your task and total time to work on it.\n"),
              Text("2 - Set a timer to 25 minutes\n"),
              Text("3 - Work on the task for 25 minutes\n"),
              Text("4 - Take a 5-minute break for energy renewal, start another Pomodoro.\n"),
              Text("5 - Take a 20-30 minute break after completing four Pomodoros.")
            ]
          ),
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
    TextEditingController minutes = TextEditingController();
    TextEditingController short = TextEditingController();
    TextEditingController large = TextEditingController();

    int minutesStudiying,shortBreak,largeBreak;
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Timer Settings",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF171717)),),
          content: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      Text("Pomodoro",style: TextStyle(fontSize: 16),),
                      SizedBox(height: 10,),
                      Container(
                        height: 30,
                        width: 75,
                        child: Center(child: Text("25")),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lime),
                          borderRadius: BorderRadius.all(Radius.circular(20)) 
                        ),
                      )
                    ]
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      Text("Short Break",style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10,),
                      Container(
                        height: 30,
                        width: 75,
                        
                        child: Center(child: Text("5")),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lime),
                          borderRadius: BorderRadius.all(Radius.circular(20)) 
                        ),
                      )
                    ]
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      Text("Large Break",style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10,),
                      Container(
                        height: 30,
                        width: 75,
                        child: Center(child: Text("15")),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lime),
                          borderRadius: BorderRadius.all(Radius.circular(20)) 
                        ),
                      )
                    ]
                  ),
                  SizedBox(width: 25,)
                ],
              ),
              
              dividerSections(),
              Row(
                children: [
                  
                  SizedBox(width: 25,),
                  Text("Long Break interval"),
                  Expanded(child: Container(),),
                  Container(
                        height: 30,
                        width: 75,
                        child: Center(child: Text("4")),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lime),
                          borderRadius: BorderRadius.all(Radius.circular(20)) 
                        ),
                      ),
                  SizedBox(width: 30,)
                ],
              ),
              dividerSections(),
              Row(
                children: [
                  SizedBox(width: 25,),
                  Text("Notifications"),
                  Expanded(child: Container()),
                  Switch(
                    value: isInstructionView,
                    onChanged: (bool isOn) {
                      print(isOn);
                      setState(() {
                      isInstructionView = !isInstructionView;
                      print(isInstructionView);
                      });
                    },
                    activeColor: Colors.lime,
                  ),
                  SizedBox(width: 30,),
                ],),
              dividerSections(),
              // Row(
              //   children: [
              //     SizedBox(width: 25,),
              //     Text("Alarm Sound"),
              //     Expanded(child: Container()),
              //     Switch(
              //       value: notifications,
              //       onChanged: (bool val) { 
                        // setState(() {
                        //   notifications = val;
                        // });
              //        }, 
              //       activeColor: Colors.lime,
              //     ),
                  
              //     SizedBox(width: 30,),
              //   ],
              // ),
            ],
          ),

        );
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
          child: Container(
            child: IconButton(
            color:Color(0xFF171717),
              icon:  isRunning ? Icon(Icons.pause_outlined) : Icon(Icons.play_arrow_outlined),
              onPressed: isRunning ? stopTimer : startTimer ,
              iconSize: 120,
            ),

          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              child: IconButton(
            icon : Icon(Icons.skip_next_outlined),
            onPressed: resetTimer,
            iconSize: 60,
        ),
          ),)
        ],
      )
    );
      
  }
}


