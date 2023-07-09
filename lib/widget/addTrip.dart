import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytravel/model/trip.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';

class newTrip extends StatefulWidget {
  final Function addTrip;

  newTrip(this.addTrip);

  @override
  State<StatefulWidget> createState() => _NewTripState();
}

class _NewTripState extends State<newTrip> {
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _descController = TextEditingController();

  late String destination;
  late DateTime dateTime;
  late String desc;

  void _submitData() {
    if (_destinationController.text.isEmpty) {
      return;
    }

    final desctination1 = _destinationController.text;
    final datetime1 = DateTime.parse(_dateController.text);
    final desc1 = _descController.text;

    final newTrip = Trip(
      id: nanoid(5),
      dateTime: datetime1,
      destination: desctination1,
      desc: desc1,
    );
    widget.addTrip(newTrip);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(labelText: "Дестинација:"),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(labelText: "Датум:"),
            keyboardType: TextInputType.datetime,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final pickedDateTime = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                  );
                  _dateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDateTime);
                }
              }
            },
          ),
          TextField(
            controller: _descController,
            decoration: InputDecoration(labelText: "Опис:"),
            onSubmitted: (_) => _submitData(),
          ),
          ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
            ),
            child: Text("Додади"),
          ),
        ],
      ),
    );
  }
}
