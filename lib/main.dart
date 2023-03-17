import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wan phra',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 240, 135, 8),
      ),
      home: const MyHomePage(title: 'วันพระ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<String> _backgroundImages = [
    'assets/background11.jpg',
    'assets/background21.jpg',
    'assets/background31.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  String get currentBackgroundImage {
    int currentMonth = _focusedDay.month - 1;
    int index = currentMonth % _backgroundImages.length;
    return _backgroundImages[index];
  }

  BoxDecoration get backgroundDecoration {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(currentBackgroundImage),
        fit: BoxFit.cover,
      ),
    );
  }

  CalendarStyle get calendarStyle {
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        shape: BoxShape.circle,
      ),
      outsideDaysVisible: false,
      defaultTextStyle: const TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'OpenSans',),
      weekendTextStyle: const TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'OpenSans',),
    );
  }

  CalendarBuilders get calendarBuilders {
    return CalendarBuilders(
      markerBuilder: (context, date, events) {
        if (isWanPhra(date)) {
          return Positioned(
            right: 1,
            bottom: 1,
            child: Icon(
              Icons.star,
              size: 18.0,
              color: Colors.amber.shade800,
            ),
          );
        }
        return Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(
      fontSize: 30, color: Colors.grey.shade200, fontFamily: 'OpenSans',fontWeight: FontWeight.bold,

        ),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month - 1,
                                _focusedDay.day,
                              );
                            });
                          },
                        ),
                        Text(
                          DateFormat.yMMMM().format(_focusedDay),
                          style: const TextStyle(fontSize: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month + 1,
                                _focusedDay.day,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 16),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: calendarStyle,
                  calendarBuilders: calendarBuilders,
                      // ... existing properties ...
                      headerVisible: false,
                    ),
                  ],
                ),
              ),
              if (isWanPhra(_focusedDay))
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'วันนี้วันพระ รักษากาย วาจา ใจ',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'OpenSans', 
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool isWanPhra(DateTime date) {
    // Implement your logic to calculate Wan Phra based on the lunar calendar
    // Here's a simple example to demonstrate the concept
    int dayOfMonth = date.day;
    return dayOfMonth % 7 == 0;
  }
}