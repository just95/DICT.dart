// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi.server;

/// Implementation of the `listen` command.
class DictServeCommand extends Command {
  final String name = 'serve';
  final String description = 'Exposes the DICT protocol as a HTTP server.';

  DictServeCommand() {
    argParser.addOption('http-addr',
        abbr: 'a',
        defaultsTo: '0.0.0.0',
        help: 'Address to bind the HTTP server to.');
    argParser.addOption('http-port',
        abbr: 'p',
        defaultsTo: '8080',
        help: 'Port to listen on for HTTP requests.');
    argParser.addOption('dict-client-info',
        abbr: 'c',
        defaultsTo: 'DICT.dart',
        help: 'Information about this client.');
    argParser.addOption('dict-addr',
        abbr: 'A',
        defaultsTo: 'localhost',
        help: 'Address of the DICT server.');
    argParser.addOption('dict-port',
        abbr: 'P',
        defaultsTo: '2628',
        help: 'Port the DICT server listens on.');
  }

  @override
  void run() {
    var config = new ServerConfig(
        dictUri: new Uri(
            scheme: 'dict',
            host: argResults['dict-addr'],
            port: int.parse(argResults['dict-port'])),
        httpUri: new Uri(
            scheme: 'http',
            host: argResults['http-addr'],
            port: int.parse(argResults['http-port'])),
        clientInfo: argResults['dict-client-info']);

    app.addModule(new Module()..bind(ServerConfig, toValue: config));

    app.setupConsoleLog();
    app.start(address: config.httpUri.host, port: config.httpUri.port);
  }
}
