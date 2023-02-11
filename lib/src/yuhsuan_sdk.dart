import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart'
    show AuthMessages, AuthenticationOptions, IOSAuthMessages;

/// {@template yuhsuan_sdk}
/// Yuhsuan sdk
/// {@endtemplate}
class MySdk {
  /// {@macro yuhsuan_sdk}
  MySdk();

  ///[Utils]
  static final BioAuth bioAuth = BioAuth._();
  static final Networking networking = Networking._();

  ///[Provier]
  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class Networking {
  Networking._();

  Future<Response> request({
    required String method,
    required String path,
    required String site,
    Map<String, String>? parameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.https(site, path, parameters);
    switch (method) {
      case 'get':
        return http.get(uri);
      case 'post':
        return http.post(uri, headers: headers, body: body);
      case 'put':
        return http.put(uri);
      case 'delete':
        return http.delete(uri);
    }
    throw Exception('Invalid method');
  }
}

class BioAuth {
  BioAuth._();
  static final _auth = LocalAuthentication();

  Future<bool> canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  Future<List<BiometricType>> getAvailableBiometrics() async =>
      _auth.getAvailableBiometrics();

  Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) {
        return false;
      }
      final bioType = await getAvailableBiometrics();
      if (bioType.contains(BiometricType.face)) {
        return await _auth.authenticate(
          localizedReason: 'the reason you want to use face id',
          authMessages: const <AuthMessages>[
            IOSAuthMessages(cancelButton: 'No thanks'),
            AndroidAuthMessages(
              signInTitle: 'Allow biometric',
              cancelButton: 'No Thanks',
            ),
          ],
          options: const AuthenticationOptions(stickyAuth: true),
        );
      } else if (bioType.contains(BiometricType.fingerprint)) {
        return await _auth.authenticate(
          localizedReason: 'the reason you want to use fingerprint',
          authMessages: const <AuthMessages>[
            IOSAuthMessages(cancelButton: 'No thanks'),
            AndroidAuthMessages(
              signInTitle: 'Allow biometric',
              cancelButton: 'No Thanks',
            ),
          ],
          options: const AuthenticationOptions(stickyAuth: true),
        );
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricSupported(BiometricType type) async {
    final bioType = await getAvailableBiometrics();
    return bioType.contains(type);
  }
}
