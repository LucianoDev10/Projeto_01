import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    //final httpClient = super.createHttpClient(context);
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
