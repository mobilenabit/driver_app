import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "secure_store.dart";

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  static const String _apiUrl = "https://pumplogapi.petronet.vn";

  Future<Map<String, dynamic>> login(String username, String password) async {
    Map<String, String> details = {
      "grant_type": "password",
      "scope": "openid profile email",
      "client_id": "nabit-client",
      "username": username,
      "password": password,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/core/connect/token",
        data: details,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response = await _dio.get(
        "$_apiUrl/core/Users/GetMyInfo",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
      );
      //   if (response.statusCode == 200) {
      //     final data = response.data;
      //     final userId = data["user"].toString();
      //     await SecureStorage().writeSecureData("user_id", userId);
      //   }
      //   return response.data;
      // } on DioException catch (e) {
      //   return e.response!.data;
      // }
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getPumps() async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response = await _dio.get(
        "$_apiUrl/MD/PumpStation/GetsInUse",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getProductNames() async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response = await _dio.get(
        "$_apiUrl/MD/Product/GetsInUse",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getFinishedLogs(
      int branchId, String toDate, String fromDate, String pumpIds) async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    Map<String, dynamic> details = {
      "keyword": "",
      "status": -1,
      "pageIndex": 1,
      "pageSize": 20,
      "orderCol": "",
      "isDesc": true,
      "workshiftId": 0,
      "branchId": branchId,
      "tankIds": "",
      "productIds": "",
      "pumpIds": pumpIds,
      "toDate": toDate,
      "fromDate": fromDate,
      "isPaid": 1,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/IA/PumpTranLog/Find",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
          contentType: Headers.jsonContentType,
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getPumpLogs(int branchId, String pumpId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final now = DateTime.now().copyWith(hour: 23, minute: 59, second: 59);
    final before = now
        .subtract(const Duration(days: 30))
        .copyWith(hour: 0, minute: 0, second: 0);

    Map<String, dynamic> details = {
      "keyword": "",
      "status": 0,
      "pageIndex": 1,
      "pageSize": 10,
      "orderCol": "",
      "isDesc": true,
      "workshiftId": 0,
      "branchId": branchId,
      "tankIds": "",
      "productIds": "",
      "pumpIds": pumpId,
      "toDate": now.toIso8601String(),
      "fromDate": before.toIso8601String(),
      "isPaid": 0,
    };
    try {
      final response = await _dio.post(
        "$_apiUrl/IA/PumpTranLog/Find",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
          contentType: Headers.jsonContentType,
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTaxCodeFromDB(String taxNumber) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response = await _dio.get(
          "$_apiUrl/MD/CustomerRetail/FindByTaxCode?taxCode=$taxNumber",
          options: Options(headers: {
            "Authorization": "Bearer $apiToken",
          }));
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTaxCodeFromGlobal(String taxNumber) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response =
          await _dio.get("$_apiUrl/TR/CompanyInfo/Enterprise/$taxNumber",
              options: Options(headers: {
                "Authorization": "Bearer $apiToken",
              }));
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTaxCode(String taxNumber) async {
    final getFromDB = await getTaxCodeFromDB(taxNumber);
    if (getFromDB["data"] != null) {
      return {
        "id": getFromDB["data"]["id"],
        "name": getFromDB["data"]["customerName"],
        "taxCode": getFromDB["data"]["taxNumber"],
        "address": getFromDB["data"]["address"],
        "shortName": getFromDB["data"]["shortName"],
        "email": getFromDB["data"]["email"],
        "new": false,
      };
    }
    final getFromGlobal = await getTaxCodeFromGlobal(taxNumber);
    if (getFromGlobal["data"] != null) {
      return {
        "name": getFromGlobal["data"]["name"],
        "taxCode": getFromGlobal["data"]["taxCode"],
        "address": getFromGlobal["data"]["address"],
        "new": true
      };
    }
    return {"error": "Không tìm thấy thông tin"};
  }

  Future<Map<String, dynamic>> createReceiptStep1(
      Map<String, dynamic> logData, Map<String, dynamic> userData) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    Map<String, dynamic> details = {
      "status": 1,
      "trDir": -1,
      "trTypeId": 1132,
      "trType": "2ZP101",
      "isOrder": false,
      "tags": [],
      "customerId": 1,
      "trDate": DateTime.now().toIso8601String(),
      "invoiceDate": logData["endFuelingTime"],
      "trInvoice": {
        "serialParamId": 1,
        "branchConfigId": 4,
        "invoicePattern": "1",
        "invoiceSerial": "1C24MAA",
        "businessId": 94080,
        "invoiceDate": logData["endFuelingTime"],
        "invoiceBuyer": userData["shortName"],
        "invoiceEmail": userData["email"],
        "invoicePaymentMethod": "TM/CK",
      },
      "trpr": [
        {
          "productId": logData["productId"],
          "qty": logData["volume"],
          "tienHang": logData["amount"] * 0.9,
          "tienVAT": logData["amount"] - (logData["amount"] * 0.9),
          "unitId": 1,
          "vatCode": 10,
          "unitPrice": logData["unitPrice"],
          "basePrice": logData["unitPrice"] * 0.9,
        },
      ],
      "pumpTranLogId": logData["id"],
      "paymentMethod": "TM/CK",
      "invoiceAcct": userData["taxCode"],
      "invoiceName": userData["customerName"],
      "invoiceAddress": userData["address"],
      "invoiceEmail": userData["email"],
      "invoiceBuyer": userData["shortName"],
      "exchRate": 1,
      "trTagsList": [],
    };
    try {
      final response = await _dio.post(
        "$_apiUrl/TR/TR",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> createReceiptStep2(Map<String, dynamic> logData,
      Map<String, dynamic> userData, bool newData) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final Map<String, dynamic> details = {
      "id": userData["id"],
      "taxNumber": userData["taxCode"],
      "customerName": userData["customerName"],
      "customerCode": "",
      "address": userData["address"],
      "idBranch": userData["branchId"],
      "email": userData["email"],
      "shortName": userData["shortName"],
      "startDate": DateTime.now().toIso8601String(),
    };
    try {
      Response<dynamic> response;
      if (!newData) {
        response = await _dio.put(
          '$_apiUrl/MD/CustomerRetail/${userData['id']}',
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        );
      } else {
        response = await _dio.post(
          "$_apiUrl/MD/CustomerRetail",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        );
      }
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> createReceiptStep3(Map<String, dynamic> logData,
      Map<String, dynamic> userData, String trID) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final Map<String, dynamic> details = {
      "trInvoiceData": [
        {
          "trId": trID,
          "serialParamId": 1,
          "branchConfigId": 4,
          "invoicePattern": "1",
          "invoiceSerial": "1C24MAA",
          "businessId": 94080,
          "invoiceDate": logData["endFuelingTime"],
          "invoiceBuyer": userData["shortName"],
          "invoiceEmail": userData["email"],
          "invoicePaymentMethod": "TM/CK",
        },
      ],
    };
    try {
      final response = await _dio.post(
        "$_apiUrl/EInvoice/EInvoice/ImportInvoice",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> createReceiptStep4(String trID) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final Map<String, dynamic> details = {
      "listTrId": [trID],
    };
    try {
      final response = await _dio.post(
        "$_apiUrl/EInvoice/EInvoice/IssueInvoice",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> userData,
      String oldPassword, String newPassword, String verificationCode) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    var details = userData;

    details["oldPassword"] = oldPassword;
    details["newPassword"] = newPassword;
    details["otp"] = verificationCode;

    try {
      final response = await _dio.post(
        "$_apiUrl/core/Users/ChangeMyPasswordWithOTP",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> userData,
      String newPassword, String verificationCode) async {
    var details = userData;

    details["newPassword"] = newPassword;
    details["otp"] = verificationCode;

    try {
      final response = await _dio.post(
        "$_apiUrl/core/CorePublic/ResetPasswordWithOtp",
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOtp() async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    try {
      final response = await _dio.post(
        "$_apiUrl/SMS/Sms/OtpSelf",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOtpAnonymous(String username) async {
    try {
      final response = await _dio.post(
        "$_apiUrl/SMS/Sms/Otp/$username",
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
      Map<String, dynamic> userData, String verificationCode) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    var details = userData;

    details["otp"] = verificationCode;

    try {
      final response = await _dio.post(
        "$_apiUrl/core/CorePublic/CheckOtp",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> togglePaymentStatus(int logId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    try {
      final response = await _dio.post(
        "$_apiUrl/IA/PumpTranLog/UpdatePaymentStatus/$logId",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getCompanies() async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final Map<String, dynamic> details = {
      "keyword": "",
      "status": 1,
      "pageIndex": 1,
      "pageSize": 20,
      "orderColl": "",
      "isDesc": false
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/MD/OrgUnit/Find",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getSLDT(
      DateTime fromDate, DateTime toDate, int branchId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(fromDate).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(toDate).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.SL.NGAY.TheoLog",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getSLDTLastMonth(int branchId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final lastMonthFirstDay =
        DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    final lastMonthLastDay =
        DateTime(DateTime.now().year, DateTime.now().month, 0);

    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthFirstDay).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthLastDay).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.SL.THANG.TheoLog",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTimeStamps() async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    try {
      final response = await _dio.get(
        "$_apiUrl/MD/PriceList/GetListTime",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiToken",
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getFuelReport(String timeStamp) async {
    const productCodes = ["1101001", "1103001"];
    final apiToken = await SecureStorage().readSecureData("access_token");
    final Map<String, dynamic> details = {
      "keyword": "",
      "status": 1,
      "pageSize": 999999,
      "orderCol": "",
      "isDesc": false,
      "validFrom": timeStamp,
      "priceRegionId": 1,
      "productSourceId": 0,
      "priceCategoryId": 1,
      "productGroupId": 35,
    };
    try {
      final response = await _dio.post(
        "$_apiUrl/MD/PriceList/Find",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTKTBLastMonth(int branchId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final lastMonthFirstDay =
        DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    final lastMonthLastDay =
        DateTime(DateTime.now().year, DateTime.now().month, 0);
    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthFirstDay).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthLastDay).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.TonKhoTrongBe",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTHCN(int branchId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final lastMonthFirstDay =
        DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    final lastMonthLastDay =
        DateTime(DateTime.now().year, DateTime.now().month, 0);
    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthFirstDay).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(lastMonthLastDay).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.TienHangCongNo",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTKTB(int branchId, DateTime now) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final toDate = now.subtract(const Duration(days: 1));
    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(firstDayOfMonth).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(toDate).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.TonKhoTrongBe",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getLeaderBoards(int type) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    const types = [
      "DASHBOARD.Top5_DoanhThu",
      "DASHBOARD.Top5_LuongKhach",
      "DASHBOARD.Top5_LuongDon"
    ];
    final now = DateTime.now();
    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(DateTime(now.year, now.month, 1)).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(now).toString()}\"}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": types[type],
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getDebtsOthers(int branchId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final parameters =
        "{\"fromDate\":\"${DateFormat("yyyy/MM/dd").format(firstDayOfMonth).toString()}\",\"toDate\":\"${DateFormat("yyyy/MM/dd").format(now).toString()}\",\"BranchId\":$branchId}";
    final Map<String, dynamic> details = {
      "reportId": 0,
      "reportCode": "DASHBOARD.THCN_TheoKhach",
      "parameters": parameters,
    };

    try {
      final response = await _dio.post(
        "$_apiUrl/RPT/Report/ExportJSON",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
        data: details,
      );

      return response.data;
    } on DioException catch (e) {
      // return full error response
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getTrByInvoiceId(int invoiceId) async {
    final apiToken = await SecureStorage().readSecureData("access_token");

    try {
      final response = await _dio.get(
        "$_apiUrl/TR/TR/$invoiceId",
        options: Options(headers: {
          "Authorization": "Bearer $apiToken",
        }),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}
