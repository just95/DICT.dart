#!/usr/bin/env dart

// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

import 'package:args/command_runner.dart';
import 'package:dictapi/server.dart';

void main(List<String> args) {
  var runner = new CommandRunner('pub [global] run dictapi', 'DICT.dart');
  runner.addCommand(new DictServeCommand());
  runner.run(args);
}
