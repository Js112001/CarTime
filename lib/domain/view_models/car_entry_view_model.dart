import 'package:car_time/domain/models/car_entry_model.dart';
import 'package:car_time/data/services/local/local_db.dart';
import 'package:car_time/utils/enums.dart';
import 'package:flutter/cupertino.dart';

final carEntryProvider = CarEntryViewModel();

class CarEntryViewModel extends ChangeNotifier {
  List<CarEntryModel>? _carEntryList;
  bool _isLoading = false;

  List<CarEntryModel> get carEntryList => _carEntryList ?? [];

  set carEntryList(List<CarEntryModel> value) {
    _carEntryList = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(state) {
    _isLoading = state;
    notifyListeners();
  }

  Future<void> getAllEntries() async {
    final result = await LocalDatabase.getAllUncheckedCars();
    carEntryList = result;
    isLoading = false;
    notifyListeners();
  }

  Future<(OperationState, int)> checkIn({required String carNumber}) async {
    final carEntry = CarEntryModel(
      carNumber: carNumber,
      checkInTime: DateTime.now(),
    );
    final result = await LocalDatabase.checkIn(carEntry: carEntry);
    notifyListeners();
    if (result > 0) {
      return (OperationState.success, result);
    } else {
      return (OperationState.failure, result);
    }
  }

  Future<OperationState> checkOut({required CarEntryModel carEntry}) async {
    final result = await LocalDatabase.checkOut(carEntryModel: carEntry);
    notifyListeners();
    if (result > 0) {
      carEntryList.removeWhere(
        (element) => element.id == carEntry.id,
      );
      return OperationState.success;
    } else {
      return OperationState.failure;
    }
  }
}
