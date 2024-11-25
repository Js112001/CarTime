import 'package:car_time/domain/models/car_entry_model.dart';
import 'package:car_time/domain/view_models/car_entry_view_model.dart';
import 'package:car_time/presentation/widgets/record_widget.dart';
import 'package:car_time/utils/enums.dart';
import 'package:car_time/utils/functions.dart';
import 'package:car_time/utils/strings.dart';
import 'package:flutter/material.dart';

class CarsNotCheckedOutView extends StatefulWidget {
  const CarsNotCheckedOutView({super.key});

  @override
  State<CarsNotCheckedOutView> createState() => _CarsNotCheckedOutViewState();
}

class _CarsNotCheckedOutViewState extends State<CarsNotCheckedOutView> {
  @override
  void initState() {
    super.initState();
    carEntryProvider.isLoading = true;
    carEntryProvider.getAllEntries();
  }

  void onCheckOut({required CarEntryModel carEntry}) async {
    final res = await carEntryProvider.checkOut(
      carEntry: carEntry,
    );
    var snackBarTitle = '';
    if (res == OperationState.success) {
      snackBarTitle = 'Succesfully checked out';
    } else {
      snackBarTitle = 'Failed to check out';
    }

    if (mounted) {
      showCustomSnackBar(
        context: context,
        title: snackBarTitle,
        state: res,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appTitle),
      ),
      body: ListenableBuilder(
        listenable: carEntryProvider,
        builder: (context, child) {
          final noRecords = (!carEntryProvider.isLoading &&
              carEntryProvider.carEntryList.isEmpty);
          return Center(
            child: carEntryProvider.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (noRecords) ...[
                        const Icon(
                          Icons.search,
                          size: 100,
                          color: Colors.grey,
                        ),
                        const Text(
                          'No cars are checked in yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: RecordWidget(
                            id: 'Id',
                            carNumber: 'CarNumber',
                            checkInTime: 'CheckInTime',
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: carEntryProvider.carEntryList.length,
                            itemBuilder: (context, index) {
                              final item = carEntryProvider.carEntryList[index];
                              final checkInTime = item.checkInTime;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: RecordWidget(
                                  id: '${item.id}',
                                  carNumber: item.carNumber,
                                  checkInTime:
                                      '${checkInTime.year}/${checkInTime.month}/${checkInTime.day}\n${checkInTime.hour}:${checkInTime.minute}:${checkInTime.second}',
                                  onCheckOut: () => onCheckOut(carEntry: item),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}
