import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'dio_cache_interceptors.dart';

class DioUtil {
  /// 連接超時時間
  static const CONNECT_TIMEOUT = Duration(seconds: 6);

  /// 響應超時時間
  static const RECEIVE_TIMEOUT = Duration(seconds: 6);

  /// 請求的URL前綴
  static String BASE_URL = "http://localhost:8080";

  /// 是否開啟網路緩存，默認為關閉
  static bool CACHE_ENABLE = false;

  /// 最大緩存時間(默認7天)，可自行調節
  static int MAX_CACHE_AGE = 7 * 24 * 60 * 60;

  /// 最大緩存數量(默認100)
  static int MAX_CACHE_COUNT = 100;

  static DioUtil? _instance;
  static Dio _dio = Dio();
  Dio get dio => _dio;
  DioUtil._internal() {
    _instance = this;
    _instance!._init();
  }

  factory DioUtil() => _instance ?? DioUtil._internal();
  static DioUtil? getInstance() {
    _instance ?? DioUtil._internal();
    return _instance;
  }

  /// 取消請求TOKEN
  CancelToken _cancelToken = CancelToken();

  /// cookie
  CookieJar cookieJar = CookieJar();

  _init() {
    /// 初始化基本選項
    BaseOptions options = BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT);

    /// 初始化dio
    _dio = Dio(options);

    /// 添加攔截器
    _dio.interceptors.add(DioInterceptors());

    /// 添加轉換器
    _dio.transformer = DioTransformer();

    /// 添加cookie管理器
    _dio.interceptors.add(CookieManager(cookieJar));

    /// 刷新token攔截器(lock/unlock)
    _dio.interceptors.add(DioTokenInterceptors());

    /// 間加緩存攔截器
    _dio.interceptors.add(DioCacheInterceptors());
  }

  /// 設置http代理(設置即開啟)
  void setProxy({String? proxyAddress, bool enable = false}) {
    if (enable) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.findProxy = (uri) {
          return proxyAddress ?? "";
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /// 設置https證書驗證
  void setHttpsCertificateVerification({String? pem, bool enable = false}) {
    if (enable) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          if (cert.pem == pem) {
            // 驗證證書
            return true;
          }
          return false;
        };
      };
    }
  }

  /// 開啟日誌打印
  void openLog() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// 請求類
  Future<T> request<T>(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const _methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };

    options ??= Options(method: _methodValues[method]);
    try {
      Response response;
      response = await _dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken ?? _cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response.data;
    } on DioError catch (e) {
      throw e;
    }
  }

  /// 取消網路請求
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }
}
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

