import "dart:convert";

import "package:crclib/catalog.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../screens/login.dart";
import "secure_store.dart";

String generateQrString(String bnb, String customerId, double transactionAmount,
    String transactionInfo) {
  const initIndicator = "000201";
  const initMethod = "010212";
  const guid = "0010A000000727";
  const serviceId = "0208QRIBFTTA";
  const currency = "5303704";
  const countryCode = "5802VN";

  final bnbString = '00${bnb.length.toString().padLeft(2, '0')}$bnb';
  final customerIdString =
      '01${customerId.length.toString().padLeft(2, '0')}$customerId';
  final bnbAndCustomerIdString = '$bnbString$customerIdString';
  final userInfoString =
      '01${bnbAndCustomerIdString.length.toString().padLeft(2, '0')}$bnbAndCustomerIdString';
  final resultInfo = '$guid$userInfoString$serviceId';
  final userInfoResult =
      '38${resultInfo.length.toString().padLeft(2, '0')}$resultInfo';

  final amountString = NumberFormat("###").format(transactionAmount).toString();
  final amountLength = amountString.length.toString().padLeft(2, "0");
  final amountResult = '54$amountLength$amountString';

  final transactionInfoString =
      '08${transactionInfo.length.toString().padLeft(2, '0')}$transactionInfo';
  final transactionInfoResult =
      '62${transactionInfoString.length.toString().padLeft(2, '0')}$transactionInfoString';

  var resultString =
      '$initIndicator$initMethod$userInfoResult$currency$amountResult$countryCode${transactionInfoResult}6304';

  final crc = Crc16CcittFalse()
      .convert(utf8.encode(resultString))
      .toRadixString(16)
      .toUpperCase();

  resultString = resultString + crc;

  return resultString;
}

void handleLogout(BuildContext context) async {
  await SecureStorage().deleteSecureData("logged_in");
  await SecureStorage().deleteSecureData("access_token");

  Navigator.pushAndRemoveUntil(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
}
