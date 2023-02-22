import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 對非open的接口的請求參數全部增加userId
    if (!options.path.contains("open")) {
      options.queryParameters["userId"] = "xxx";
    }

    // 頭部添加token
    options.headers["token"] = "xxx";

    // 更多商業邏輯
    handler.next(options);

    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
      response.data =
          DioResponse(code: 0, message: "请求成功啦", data: response.data);
    } else {
      response.data =
          DioResponse(code: 1, message: "请求失败啦", data: response.data);
    }

    // 对某些单独的url返回数据做特殊处理
    if (response.requestOptions.baseUrl.contains("???????")) {
      //....
    }

    // 根据公司的业务需求进行定制化处理

    // 重点
    handler.next(response);
  }
}
