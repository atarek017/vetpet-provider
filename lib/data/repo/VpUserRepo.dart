import 'package:vetwork_partner/model/ActiveProvideStatusRespond.dart';
import 'package:vetwork_partner/model/UserModel.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:vetwork_partner/model/login_provider/UserLoginModel.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmModel.dart';
import 'package:vetwork_partner/model/confirm_provider/ConfirmRespond.dart';
import 'package:vetwork_partner/model/verify_provider/UserRequestModel.dart';
import 'package:vetwork_partner/model/verify_provider/VerifyResponseModel.dart';
abstract class VpUserRepo {

  Future<UserModel> requestToken();
  Future<dynamic> confirmToken(ConfirmModel confirm);
  Future<dynamic> registerUser(UserModel userModel);
  Future<dynamic> signInUser(UserLoginModel userLoginModel);
  Future<VerifyResponseModel> verifyUser(UserRequestModel userRequestModel);
  Future<ActiveProvideStatusRespond> onlineProviderStatus();
  Future<ActiveProvideStatusRespond> offlineProviderStatus();
  Future<bool> updatePushToken();

  Future<dynamic> lookupsMsg();

}

