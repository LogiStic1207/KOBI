import 'dart:async';
import 'dart:io';

//import 'package:flutter/material.dart';

class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return '인터넷 연결이 끊겼습니다.';
    } else if (error is TimeoutException) {
      return '정보시스템 서버에 접속할 수 없습니다.';
    } else {
      return '알 수 없는 에러가 발생했습니다.';
    }
  }
}
