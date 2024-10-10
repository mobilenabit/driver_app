import "dart:convert";
import "dart:io";
import "dart:typed_data";
import 'package:http/http.dart' as http;
import "package:dio/dio.dart";
import "package:http_parser/http_parser.dart";
import "package:retry/retry.dart";
import "secure_store.dart";

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  final RetryOptions _r = const RetryOptions(maxAttempts: 4);
  final SecureStorage _ss = const SecureStorage();
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
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/core/connect/token",
          data: details,
          options: Options(contentType: Headers.formUrlEncodedContentType),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/core/Users/GetMyInfo",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
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
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/core/CorePublic/ResetPasswordWithOtp",
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOtp() async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/SMS/Sms/OtpSelf",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
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
    final apiToken = await _ss.readSecureData("access_token");
    var details = userData;

    details["otp"] = verificationCode;

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/core/CorePublic/CheckOtp",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> verifyOldPassword(
    Map<String, dynamic> userData,
    String password,
  ) async {
    final apiToken = await _ss.readSecureData("access_token");
    var details = userData;

    details["oldPassword"] = password;
    details["newPassword"] = password;

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/core/Users/ChangeMyPassword",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> changePasswordWithoutOTP(
    Map<String, dynamic> userData,
    String oldPassword,
    String newPassword,
  ) async {
    final apiToken = await _ss.readSecureData("access_token");
    var details = userData;

    details["oldPassword"] = oldPassword;
    details["newPassword"] = newPassword;

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "/core/Users/ChangeMyPassword",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  // Get all News
  Future<Map<String, dynamic>> getNews() async {
    final apiToken = await _ss.readSecureData("access_token");

    final Map<String, dynamic> details = {
      'keyword': '',
      'status': 0,
      'pageIndex': 1,
      'pageSize': 50,
      'orderCol': '',
      'isDesc': true,
      'idLanguage': 0,
      'idCategory': 0,
    };
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/CMS/CmsNews/Find",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  // Get News by Id
  Future<Map<String, dynamic>> getNewsById(id) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/CMS/CmsNews/$id",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  // Change avatar
  Future<Map<String, dynamic>> uploadImage(
      Uint8List bytes, String fileName) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          contentType: MediaType.parse("image/jpeg"),
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        "$_apiUrl/Storage/StorageFileItem/UploadFiles",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $apiToken",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  // Update avatar
  Future<Map<String, dynamic>> updateImage(
      Map<String, dynamic> oldUserData, int imageId) async {
    final apiToken = await _ss.readSecureData("access_token");
    final data = oldUserData;

    data["avatar"] = "$_apiUrl/Storage/StorageFileItem/GetFileById/$imageId";

    try {
      final response = await _dio.put(
        "$_apiUrl/core/Users/UpdateMyInfo",
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apiToken",
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> generateQrCode(int id) async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/MD/QrCode/GenerateQrCode",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: id,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getVehiclesAlt(int id) async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/Driver2Vehicle/GetByDriverId/$id",
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getCustomer(int customerId) async {
    final apiToken = await _ss.readSecureData("access_token");
    print(customerId);
    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/Customer/$customerId",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
              "Content-Type": "application/json",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      print(e);
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getVehicles(int id) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/Driver2Vehicle/GetByDriverId/$id",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getActiveVehicle(int id) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/Driver2Vehicle/GetActiveVehicle/$id",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> setActiveVehicle(
      int userId, int vehicleId) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/MD/Driver2Vehicle/SetActiveVehicle",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: {
            "driverId": userId,
            "vehicleId": vehicleId,
          },
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getMapDestinations() async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/OrgUnit/GetMapDestinations",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getConfirmation(int driverId) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/MD/OrderRequest/GetLatestOrderRequest/$driverId",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getProductNames() async {
    final apiToken = await _ss.readSecureData("access_token");
    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/MD/Product/GetAll",
          options: Options(
            headers: {
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getLog(int orderId) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.get(
          "$_apiUrl/IA/PumpTranLog/$orderId",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(
      int status, int orderId) async {
    final apiToken = await _ss.readSecureData("access_token");

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/MD/OrderRequest/UpdateOrderRequestStatus",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: {
            "orderId": orderId,
            "status": status,
          },
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getHistory(
      DateTime fromDate, DateTime toDate, int driverId, int VehicleId) async {
    final apiToken = await _ss.readSecureData("access_token");

    final Map<String, dynamic> details = {
      "status": -1,
      "pageSize": 30,
      "pageIndex": 1,
      "isDesc": true,
      "fromDate": fromDate.toIso8601String(),
      "toDate": toDate.toIso8601String(),
      "driverId": driverId,
      "vehicleId": VehicleId,
      "workshiftId": 0,
      "trDir": -1,
    };

    try {
      final response = await _r.retry(
        () async => await _dio.post(
          "$_apiUrl/TR/TR/Find",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $apiToken",
            },
          ),
          data: details,
        ),
        retryIf: (e) {
          if (e is DioException) {
            return e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout;
          }

          return false;
        },
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}

final apiClient = ApiClient();
