import 'dart:io';

String fixture(String fileName) => 
  File('test/fixtures/user.json').readAsStringSync();