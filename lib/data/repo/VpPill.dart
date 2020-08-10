import 'package:vetwork_partner/model/confirm_invoice/BillInvoice.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoicModel.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoiceRespond.dart';
import 'package:vetwork_partner/model/prices/GetPricesRespond.dart';
import 'package:vetwork_partner/model/prices/PriceRequestModel.dart';
import 'package:vetwork_partner/model/services/Service.dart';

abstract class VpPill {
  Future<List<Services>> getAllServices();
  Future<GetPricesRespond> getPrices(PriceRequestModel priceRequestModel);
  Future<ConfirmInvoiceRespond> confirmInvoice(ConfirmInvoiceModel confirmInvoiceModel);
  Future<ConfirmInvoiceRespond> billInvoice(BillInvoice billInvoice);
}
