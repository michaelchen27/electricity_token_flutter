import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:electricity_token/api_error.dart';
import 'package:electricity_token/thera_model.dart';
import 'package:http/http.dart';

class TheraRepository {
  static const String GET_LIST_URL =
      "https://mocki.io/v1/01ad95aa-7d92-40d4-a04b-d4ed06c30bbd";

  static const String GET_DETAIL_URL =
      "https://mocki.io/v1/94123a55-5a63-4a65-bd17-3cd4fe75260a";

  Future<dynamic> getElectricityTokens({required int unitId}) async {
    int errCode = -1;

    try {
      final response = await get(Uri.parse(GET_LIST_URL));
      Map body = jsonDecode(response.body);
      if (response.statusCode != 200) {
        errCode = response.statusCode;
        throw Exception();
      }
      return Thera.fromJson(body['data']);

    } on SocketException {
      return SocketTimeoutError();
    } on HttpException {
      return HttpError();
    } on FormatException {
      return FormatError();
    } catch (e) {
      return switch(errCode) {
        403 => UnknownError(errCode, "FORBIDDEN"),
        404 => UnknownError(errCode, "NOT FOUND"),
        int() => UnknownError(errCode, ""),
      };
    }
  }

  Future<dynamic> getDetail({required String trx_code}) async {
    int errCode = -1;

    final sendBody = json.encode({"trx_code": trx_code});
    // final response = await post(Uri.parse(GET_DETAIL_URL), body: sendBody);

    try {
      final response = await get(Uri.parse(GET_DETAIL_URL));
      Map body = jsonDecode(response.body);
      if (response.statusCode != 200) {
        errCode = response.statusCode;
        throw Exception();
      }
      return TheraDetail.fromJson(body['data']);

    } on SocketException {
      return SocketTimeoutError();
    } on HttpException {
      return HttpError();
    } on FormatException {
      return FormatError();
    } catch (e) {

      return switch(errCode) {
        403 => UnknownError(errCode, "FORBIDDEN"),
        404 => UnknownError(errCode, "NOT FOUND"),
        int() => UnknownError(errCode, ""),
      };
    }
  }

  Future<dynamic> createTrx(
      {required String meterNumber,
      required int unitId,
      required int amount}) async {
    return "1237129031298312";
    // final Uri request = Uri.https(GET_TRX);
    // final body = json.encode(
    //     {"meter_number": meterNumber, "unit_id": unitId, "amount": amount});
    // final response = await post(request, body: body);

    // return response is ApiError ? response : response['trx_code'];

    // final response = await get(Uri.parse(GET_TRX));
    // Map body = jsonDecode(response.body);
    // return body['trx_code'];
  }

  Future<dynamic> checkOutstanding() async {
    return false;
    // final response = await get(Uri.parse(GET_OUTSTANDING));
    // Map body = jsonDecode(response.body);
    // return (body['data']);
  }
}
