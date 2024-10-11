import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gym_master_fontend/model/ProfileModel.dart';
import 'package:gym_master_fontend/model/UserModel.dart';
import 'package:gym_master_fontend/model/UserProfileEditModel.dart';
import 'package:gym_master_fontend/services/app_const.dart';

class EditService {
  String ip = AppConstants.BASE_URL;
  final dio = Dio();
  Future<List<UserProfileEditModel>> getProfileEdit(
      int uid, String tokenJwt) async {
    // log(ip);
    var json = {"uid": uid};

    try {
      final response = await dio.post("$ip/user/getDataUserById",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      if (response.statusCode == 200) {
        // Parse the JSON data and convert it to a list of UserProfileEditModel objects
        final List<dynamic> data = response.data;
        return data.map((e) => UserProfileEditModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log("Fetching data error: $e");
      throw Exception("Failed to load data1S $e");
    }
  }

  Future<int> updatePassword(int uid, String password, String tokenJwt) async {
    var json = {
      "uid": uid,
      "password": password,
    };

    try {
      final response = await dio.post("$ip/user/update/password",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));

      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      throw Exception('Failed to load stutus: $e');
    }
  }

  Future<int> updateHeight(int uid, int height, String tokenJwt) async {
    var json = {
      "uid": uid,
      "height": height,
    };
    try {
      final response = await dio.post("$ip/user/update/height",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw Exception('Failed to update height');
      }
    } catch (e) {
      throw Exception('Failed to load stutus: $e');
    }
  }

  Future<int> updateWeight(int uid, double weight, String tokenJwt) async {
    var json = {
      "uid": uid,
      "weight": weight,
    };
    try {
      final response = await dio.post("$ip/progress/weightInsert",
          data: json,
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenJwt',
            },
            validateStatus: (status) {
              return status! < 500; // Accept status codes less than 500
            },
          ));
      if (response.statusCode == 200) {
        return 1;
      } else {
        throw Exception('Failed to update weight');
      }
    } catch (e) {
      throw Exception('Failed to load stutus: $e');
    }
  }
}
