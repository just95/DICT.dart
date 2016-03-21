// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi.web;

/// Implementation of the [DictApi] which uses XHR to communicate with
/// the HTTP back-end.
class DictXhr implements DictApi {
  /// Base URI of the DICT HTTP server.
  final Uri base;

  DictXhr(this.base);

  /// Sends a GET request.
  Future _GET(List<String> path,
      {String type, Map<String, String> query: const {}}) async {
    var uri = base.resolve(joinAll(path)).replace(queryParameters: query);
    var req = await HttpRequest.request(uri.toString(), responseType: type);
    return req.response;
  }

  /// Sends a GET request for `text/plain`.
  Future<String> _getString(List<String> path, {Map<String, String> query}) =>
      _GET(path, query: query, type: 'string');

  /// Sends a GET request for `application/json`.
  Future<Map> _getJson(List<String> path, {Map<String, String> query}) =>
      _GET(path, query: query, type: 'json');

  @override
  Stream<DictDefinition> define(String word, {String database: '*'}) async* {
    var definitions = await _getJson(['define', database, word]);
    for (var definition in definitions) {
      yield new DictDefinition.fromJson(definition);
    }
  }

  @override
  Stream<DictMatch> match(String word,
      {String database: '*', String strategy: '.'}) async* {
    var matches = await _getJson(['match', database, word],
        query: {'strategy': strategy});
    for (var match in matches) {
      yield new DictMatch.fromJson(match);
    }
  }

  @override
  Stream<DictDefinition> matchDefine(String word,
      {String database: '*', String strategy: '.'}) async* {
    var definitions = await _getJson(['match-define', database, word],
        query: {'strategy': strategy});
    for (var definition in definitions) {
      yield new DictDefinition.fromJson(definition);
    }
  }

  @override
  Stream<DictDatabase> showDatabases() async* {
    var databases = await _getJson(['databases']);
    for (var databases in databases) {
      yield new DictDatabase.fromJson(databases);
    }
  }

  @override
  Stream<DictStrategy> showStrategies() async* {
    var strategies = await _getJson(['strategies']);
    for (var strategy in strategies) {
      yield new DictStrategy.fromJson(strategy);
    }
  }

  @override
  Future<String> showInfo(String database) => _getString(['info', database]);

  @override
  Future<String> showServer() => _getString(['server']);

  @override
  Future<String> status() => _getString(['status']);

  @override
  Future<String> help() => _getString(['help']);
}
