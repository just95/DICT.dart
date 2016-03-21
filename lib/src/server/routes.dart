// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi.server;

/// Base URI of additional resources.
final Uri _resourceBaseUri = Uri.parse('package:dictapi/res');

/// The `conn` attribute of the current request.
DictConnection get conn => app.request.attributes['conn'];

@app.Interceptor(r'/.*')
Future<shelf.Response> connectionInterceptor(
    @app.Inject() ServerConfig config) async {
  var connection = await DictConnection.connect(config.dictUri,
      clientInfo: config.clientInfo);
  try {
    app.request.attributes['conn'] = connection;
    await app.chain.next();
  } finally {
    await connection.quit();
  }
  return app.response;
}

@app.Interceptor(r'/.*')
Future<shelf.Response> corsHeaderInterceptor() async {
  if (app.request.method != "OPTIONS") {
    await app.chain.next();
  }
  return app.response.change(headers: {"Access-Control-Allow-Origin": "*"});
}

@app.Route('/', responseType: 'text/html')
Future<String> homeRoute() {
  var res = new Resource(_resourceBaseUri.resolve('home.html'));
  return res.readAsString();
}

@app.Route('/define/:database/:word')
@app.Route('/define/:word')
Future<List> defineRoute(String word, {String database: '*'}) {
  var definitions = conn.define(word, database: database);
  return definitions.map((definition) => definition.toJson()).toList();
}

@app.Route('/match/:database/:word')
@app.Route('/match/:word')
Future<List> matchRoute(String word,
    {String database: '*', @app.QueryParam() String strategy: '.'}) {
  var matches = conn.match(word, database: database, strategy: strategy);
  return matches.map((match) => match.toJson()).toList();
}

@app.Route('/match-define/:database/:word')
@app.Route('/match-define/:word')
Future<List> matchDefineRoute(String word,
    {String database: '*', @app.QueryParam() String strategy: '.'}) {
  var definitions =
      conn.matchDefine(word, database: database, strategy: strategy);
  return definitions.map((definition) => definition.toJson()).toList();
}

@app.Route('/databases')
Future<List> showDatabasesRoute() async {
  var databases = conn.showDatabases();
  return databases.map((database) => database.toJson()).toList();
}

@app.Route('/strategies')
Future<List> showStrategiesRoute() async {
  var strategies = conn.showStrategies();
  return strategies.map((strategy) => strategy.toJson()).toList();
}

@app.Route('/info/:database')
Future<String> showInfoRoute(String database) async {
  return await conn.showInfo(database);
}

@app.Route('/server')
Future<String> showServerRoute() async {
  return await conn.showServer();
}

@app.Route('/status')
Future<String> statusRoute() async {
  return await conn.status();
}

@app.Route('/help')
Future<String> helpRoute(on) async {
  return await conn.help();
}
