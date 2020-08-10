import 'package:vetwork_partner/model/PedningRequest.dart';
import 'package:vetwork_partner/model/RequestModel.dart';
import 'package:vetwork_partner/model/accept_request/accept_model.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/active_requests/root_response_model.dart';
import 'package:vetwork_partner/model/cancel_request/cancelReqestModel.dart';
import 'package:vetwork_partner/model/change_request_status/changeRequestStatusModel.dart';

// Data Abstract CLass
abstract class VpRequestRepo {
  Future<RequestModel> connect();

  Future<dynamic> getPendingRequests(PendingRequest pendingRequest);

  Future<List<ActiveRequest>> getActiveRequests(ActiveRequestBody activebody);
  Future<List<ActiveRequest>> getCompletedRequests(ActiveRequestBody activebody);

  Future<dynamic> acceptRequest(AcceptModel acceptModel);

  Future<dynamic> cancelRequest(CancelRequestStatusModel cancelRequestStatusModel);

  Future<dynamic> changeRequestStatus(ChangeRequestStatusModel changeRequestStatusModel);

  Future<RequestModel> getServices();

  Future<RequestModel> getPrices();
} //end of class.
