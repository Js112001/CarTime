import 'package:flutter/material.dart';

class RecordWidget extends StatelessWidget {
  const RecordWidget({
    super.key,
    required this.id,
    required this.carNumber,
    required this.checkInTime,
    this.onCheckOut,
  });

  final String id;
  final String carNumber;
  final String checkInTime;
  final void Function()? onCheckOut;

  @override
  Widget build(BuildContext context) {
    final textStyle = (onCheckOut == null)
        ? const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          )
        : null;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              id,
              style: textStyle,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            carNumber,
            style: textStyle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            checkInTime,
            style: textStyle,
          ),
        ),
        if (onCheckOut != null)
          Flexible(
            flex: 3,
            child: ElevatedButton(
              onPressed: onCheckOut,
              child: const Text('Check out'),
            ),
          ),
        if (onCheckOut == null)
          Expanded(
            flex: 3,
            child: Text(
              'Action',
              style: textStyle,
            ),
          )
      ],
    );
  }
}
