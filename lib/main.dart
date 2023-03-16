import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wan Phra App',
      theme: ThemeData(
        primaryColor: const Color(0xFF8AB4F8),
        accentColor: const Color(0xFFB39DDB),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: MyHomePage(title: 'Wan Phra App'),
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _backgroundImages = [
    'assets/background1.jpg',
    'assets/background2.jpg',
    'assets/background3.jpg',
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
      defaultTextStyle: TextStyle(fontSize: 18, color: Colors.white),
      weekendTextStyle: TextStyle(fontSize: 18, color: Colors.white),
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
              color: Colors.white,
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
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              ),
              if (isWanPhra(_focusedDay))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'วันนี้วันพระ รักษากาย วาจา ใจ',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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