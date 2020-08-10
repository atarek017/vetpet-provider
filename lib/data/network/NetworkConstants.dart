import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/repo/VpPill.dart';
import 'package:vetwork_partner/model/services/Service.dart';

class NetworkConstants {
  static String baseAddress = "https://papi-dev.vetwork.co/";
  static String connect = "auth/KFB9368N-1XE5-4Z4E-R62A-9W4E26927J9G";
  static String REGISTERUSER = baseAddress + "auth/register";
  static String LOGIN = baseAddress + "auth/login";
  static String requestToken = baseAddress + "verify/request";
  static String confirmToken = baseAddress + "verify/confirm";
  static String pendingRequests = baseAddress + "provider/requests";
  static String acceptRequest = baseAddress + "provider/accept";
  static String online = baseAddress + "provider/online";
  static String offline = baseAddress + "provider/offline";
  static String activeRequests = baseAddress + "provider/activereqs";
  static String inActiveRequests = baseAddress + "provider/Inactivereqs";

  static String changeStatus = baseAddress + "provider/changereqstatus";
  static String cancelRequest = baseAddress + "provider/cancel";
  static String requestStatus = "provider/requeststatus";

  static String services = baseAddress + "provider/services";
  static String prices = baseAddress + "provider/prices";
  static String confirminvoice = baseAddress + "provider/confirminvoice";
  static String billInvoices=baseAddress+"provider/beforeinvoice";
  static String Lookups = baseAddress + "auth/Lookups/" + appid;
  static String update_token = baseAddress + "provider/updatetoken";

  static const String appid = 'KFB9368N-1XE5-4Z4E-R62A-9W4E26927J9G';

  static int statusCode;
  static List<Services> billServices;
  static double total = 0;
  static String requestId;

  static getBaseIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString('envireonmentSellected');
    if (ip == null) {
      baseAddress = "https://papi-dev.vetwork.co/";
    } else {
      baseAddress = "https://papi-dev.vetwork.co/";
    }
  }
}
