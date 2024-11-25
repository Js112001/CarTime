import 'package:car_time/domain/view_models/car_entry_view_model.dart';
import 'package:car_time/utils/enums.dart';
import 'package:car_time/utils/functions.dart';
import 'package:car_time/utils/strings.dart';
import 'package:flutter/material.dart';

import 'cars_not_checked_out_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _formKey = GlobalKey();
  }

  void onFormSubmit() async {
    final validate = _formKey.currentState?.validate() ?? false;
    if (validate) {
      final result = await carEntryProvider.checkIn(
        carNumber: _controller.value.text,
      );
      var snackBarText = '';
      if (result.$1 == OperationState.success) {
        snackBarText = 'Successfully checked in!';
        _controller.text = '';
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        snackBarText = result.$2 == -1
            ? 'Car already checked in!'
            : 'Something went wrong. Try again.';
      }
      if (context.mounted) {
        showCustomSnackBar(
          context: context,
          title: snackBarText,
          state: result.$1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appTitle),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: 'Please enter a car number of length 6'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car number';
                    } else if (value.length < 6) {
                      return 'Please enter a valid car number of length 6';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: onFormSubmit,
                child: const Text('Check In'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: OutlinedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CarsNotCheckedOutView();
                        },
                      ),
                    );
                  },
                  child: const Text('See all Checked In Cars'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
