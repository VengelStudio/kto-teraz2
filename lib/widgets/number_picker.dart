import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/question.dart';

class NumberPicker extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int initial;
  final int min;
  final int max;

  NumberPicker(
      {Key? key,
      required this.onChanged,
      this.initial = 1,
      this.min = 1,
      this.max = 20})
      : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  final TextEditingController textFieldController = new TextEditingController();
  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();

    _currentNumber = widget.initial;
    _refreshTextField();
  }

  void _handleAdd() {
    if (_currentNumber == widget.max) {
      return;
    }

    setState(() {
      _currentNumber = _currentNumber + 1;
      widget.onChanged(_currentNumber);
    });

    _refreshTextField();
  }

  void _handleRemove() {
    if (_currentNumber == widget.min) {
      return;
    }

    setState(() {
      _currentNumber = _currentNumber - 1;
      widget.onChanged(_currentNumber);
    });

    _refreshTextField();
  }

  void _refreshTextField() {
    textFieldController.text = _currentNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: [
          Container(
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1.0, color: Colors.grey),
            )),
            child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.black87,
                  size: 24,
                ),
                onPressed: _handleRemove),
          ),
          Container(
            width: 48,
            child: TextField(
                textAlign: TextAlign.center,
                controller: textFieldController,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                readOnly: true),
          ),
          Container(
            width: 48,
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(width: 1.0, color: Colors.grey),
            )),
            child: IconButton(
                icon: Icon(Icons.add, color: Colors.black87, size: 24),
                onPressed: _handleAdd),
          )
        ],
      ),
    );
  }
}
