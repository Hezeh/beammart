import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OperatingHoursWidget extends StatefulWidget {
  final bool? isMondayOpen;
  final bool? isTuesdayOpen;
  final bool? isWednesdayOpen;
  final bool? isThursdayOpen;
  final bool? isFridayOpen;
  final bool? isSaturdayOpen;
  final bool? isSundayOpen;
  final String? mondayOpeningTime;
  final String? mondayClosingTime;
  final String? tuesdayOpeningTime;
  final String? tuesdayClosingTime;
  final String? wednesdayOpeningTime;
  final String? wednesdayClosingTime;
  final String? thursdayOpeningTime;
  final String? thursdayClosingTime;
  final String? fridayOpeningTime;
  final String? fridayClosingTime;
  final String? saturdayOpeningTime;
  final String? saturdayClosingTime;
  final String? sundayOpeningTime;
  final String? sundayClosingTime;

  const OperatingHoursWidget({
    Key? key,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.mondayOpeningTime,
    this.mondayClosingTime,
    this.tuesdayOpeningTime,
    this.tuesdayClosingTime,
    this.wednesdayOpeningTime,
    this.wednesdayClosingTime,
    this.thursdayOpeningTime,
    this.thursdayClosingTime,
    this.fridayOpeningTime,
    this.fridayClosingTime,
    this.saturdayOpeningTime,
    this.saturdayClosingTime,
    this.sundayOpeningTime,
    this.sundayClosingTime,
  }) : super(key: key);

  @override
  _OperatingHoursWidgetState createState() => _OperatingHoursWidgetState();
}

class _OperatingHoursWidgetState extends State<OperatingHoursWidget> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (context, _isPanelExpanded) {
              // TODO: Change this dynamically
              return ListTile(
                title: Text(
                  'Operating Hours',
                  style: GoogleFonts.gelasio(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            body: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Day',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Opening',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Closing',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                widget.isMondayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Monday')),
                          DataCell(
                            (widget.mondayOpeningTime != null)
                                ? Text(widget.mondayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.mondayClosingTime != null)
                                ? Text(widget.mondayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Monday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isTuesdayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Tuesday')),
                          DataCell(
                            (widget.tuesdayOpeningTime != null)
                                ? Text(widget.tuesdayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.tuesdayClosingTime != null)
                                ? Text(widget.tuesdayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Tuesday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isWednesdayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Wednesday')),
                          DataCell(
                            (widget.wednesdayOpeningTime != null)
                                ? Text(widget.wednesdayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.wednesdayClosingTime != null)
                                ? Text(widget.wednesdayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Wednesday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isThursdayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Thursday')),
                          DataCell(
                            (widget.thursdayOpeningTime != null)
                                ? Text(widget.thursdayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.thursdayClosingTime != null)
                                ? Text(widget.thursdayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Thursday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isFridayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Friday')),
                          DataCell(
                            (widget.fridayOpeningTime != null)
                                ? Text(widget.fridayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.fridayClosingTime != null)
                                ? Text(widget.fridayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Friday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isSaturdayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Saturday')),
                          DataCell(
                            (widget.saturdayOpeningTime != null)
                                ? Text(widget.saturdayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.saturdayClosingTime != null)
                                ? Text(widget.saturdayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Saturday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
                widget.isSundayOpen!
                    ? DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Sunday')),
                          DataCell(
                            (widget.sundayOpeningTime != null)
                                ? Text(widget.sundayOpeningTime!)
                                : Container(),
                          ),
                          DataCell(
                            (widget.sundayClosingTime != null)
                                ? Text(widget.sundayClosingTime!)
                                : Container(),
                          ),
                        ],
                      )
                    : DataRow(cells: [
                        DataCell(
                          Text('Sunday'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                        DataCell(
                          Text('Closed'),
                        ),
                      ]),
              ],
            ),
            isExpanded: _isExpanded,
            // backgroundColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}
