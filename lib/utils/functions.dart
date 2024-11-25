import 'package:car_time/utils/enums.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String title,
  required OperationState state,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        title,
      ),
      backgroundColor:
          state == OperationState.success ? Colors.green : Colors.red,
    ),
  );
}
