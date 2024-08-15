// localhost
import 'dart:io';

const emulatorIp = '10.0.2.2:8000';
const simulatorIp = '127.0.0.1:8000';
final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;
