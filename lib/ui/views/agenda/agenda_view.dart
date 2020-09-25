import 'package:flutter/material.dart';
import 'package:meenforquei/models/agenda_model.dart';
import 'package:meenforquei/viewmodel/agenda_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class AgendaView extends StatefulWidget {
  final PageController pageController;
  AgendaView(this.pageController);

  @override
  _AgendaViewState createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
//  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
//    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<AgendaModel> events){
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event){
      DateTime date = DateTime(event.date.year, event.date.month, event.date.day, 12);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    print('| => Agenda View'); // ToDo: print agenda

    bool _podeEditar = true;

    final agendaProvider = Provider.of<AgendaViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: !agendaProvider.busy ? Icon(Icons.add) : CircularProgressIndicator(),
          onPressed: agendaProvider.newAgenda,
      ),
      drawer: CustomDrawer(widget.pageController),
      appBar: AppBar(
        title: Text(MEString.titleAgenda),
        centerTitle: true,
      ),
      body: StreamBuilder<List<AgendaModel>>(
        stream: agendaProvider.fetchAgendaListAsStream(),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: <Widget>[
                    Text(MEString.carregando),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    MEString.errorLoadAgenda,
                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                  ),
                );
              }else{
                if (! snapshot.hasData){
                  return Expanded(
                    child: Center(
                      child: Text(
                          MEString.emptyAgenda,
                          style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                      ),
                    ),
                  );
                }
                List<AgendaModel> allEvents = snapshot.data;
                if (allEvents.isNotEmpty){
                  _events = _groupEvents(allEvents);
                }
                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /*
                          TableCalendar(
                            events: _events,
                            initialCalendarFormat: CalendarFormat.week,
                            calendarStyle: CalendarStyle(
                                canEventMarkersOverflow: true,
                                todayColor: Colors.orange,
                                selectedColor: Theme.of(context).primaryColor,
                                todayStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white)),
                            headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              formatButtonTextStyle: TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onDaySelected: (date, events) {
                              setState(() {
                                _selectedEvents = events;
                              });
                            },
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, events) => Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                              todayDayBuilder: (context, date, events) => Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            calendarController: _controller,
                          ),
                          ..._selectedEvents.map((event) => ListTile(
                            title: Text(event.title),
                            onTap: () {
                              _podeEditar ?
                                agendaProvider.editAgenda(event)
                                :
                                agendaProvider.detailAgenda(event);
                            },
                          )),
                           */
                        ]
                    )
                );
              }
              break;
            default:
              return Container(child: Text(MEString.errorLoadAgenda));
          }
        }
      )
    );
  }
}
