import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StoreVersionService {
  final dio = Dio();

  /// 25-03-02
  ///
  /// 플레이스토어 앱 버전 가져오기
  Future<Map<String, dynamic>> fetchPlayStoreAppVersion() async {
    Map<String, dynamic> queryParams = {
      "id": dotenv.env["ANDROID_BUNDLE_ID"],
      "gl": "US",
    };

    try {
      final response = await dio.get(
        "https://play.google.com/store/apps/details",
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final RegExp regexp = RegExp(r'\[\[\[\"(\d+\.\d+(\.[a-z]+)?(\.([^"]|\\")*)?)\"\]\]');
        String? version = regexp.firstMatch(response.data)?.group(1);
        return {
          "bool": true,
          "data": {
            "version": version,
          },
        };
      } else {
        return {
          "bool": false,
          "msg": "스토어 버전을 가져오지 못했습니다.",
        };
      }
    } catch (e) {
      debugPrint("Fetch play store app verson ERROR: $e");
      return {
        "bool": false,
        "msg": "스토어 버전을 가져오는 중 에러가 발생했습니다.",
      };
    }
  }
}
