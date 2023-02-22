import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_util.dart';

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class DioCacheInterceptors extends Interceptor {
  // 為確保迭代器順序和對象插入時間一致順序一致，我們使用LinkedHashMap
  var cache = LinkedHashMap<String, CacheObject>();
  // sp
  SharedPreferences? preferences;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!DioUtil.CACHE_ENABLE) return super.onRequest(options, handler);
    // 是否刷新缓存
    bool refresh = options.extra["refresh"] == true;

    if (refresh) {
      // 刪除本地緩存
      delete(options.uri.toString());
    }
    // 只有GET請求才開啟緩存
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        // 内存缓存
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            DioUtil.MAX_CACHE_AGE) {
          return handler.resolve(cache[key]!.response);
        } else {
          //若已過期則刪除緩存，繼續向服務器請求
          cache.remove(key);
        }

        // disk cache
      }
    }
    super.onRequest(options, handler);
  }

  _saveCache(Response object) {
    RequestOptions options = object.requestOptions;
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 如果緩存數量超過最大數量限制，則先移除最早的一條記錄
      if (cache.length == DioUtil.MAX_CACHE_COUNT) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}
