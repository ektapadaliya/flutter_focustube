import 'package:focus_tube_flutter/model/user_intrest_model.dart';
import 'package:get/get.dart';

import '../model/interest_model.dart';

class InterestController extends GetxController {
  static List<InterestModel> _interests = <InterestModel>[];
  List<InterestModel> get interests => _interests;
  List<InterestModel> get selectedInterests => _interests
      .where((e) => _userInterests.any((u) => u.interestId == e.id.toString()))
      .toList();
  void replaceInterests(List<InterestModel> interests) {
    _interests = interests;
    update();
  }

  static List<UserInterestModel> _userInterests = <UserInterestModel>[];
  List<UserInterestModel> get userInterests => _userInterests;

  void replaceUserInterests(List<UserInterestModel> interests) {
    _userInterests = interests;
    update();
  }

  void clear() {
    _userInterests.clear();
    update();
  }
}
