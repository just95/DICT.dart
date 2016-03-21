// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

library dictapi.server;

import 'dart:async';
import "dart:core" hide Resource;

import 'package:args/command_runner.dart';
import 'package:di/di.dart';
import 'package:redstone/redstone.dart' as app;
import 'package:resource/resource.dart' show Resource;
import 'package:shelf/shelf.dart' as shelf;

import 'vm.dart';

part 'src/server/command/serve.dart';
part 'src/server/config.dart';
part 'src/server/routes.dart';
