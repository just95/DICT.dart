// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi.vm;

/// A connection to a DICT server via a socket.
class DictConnection implements DictApi {
  /// Connects to a DICT server.
  ///
  /// Sends the [client] command initially if [clientInfo] has
  /// been specified.
  static Future<DictConnection> connect(Uri uri, {String clientInfo}) async {
    // Validate URI.
    if (uri.scheme != 'dict') {
      throw new UnsupportedError('URI scheme must be "dict".');
    }
    if (uri.hasFragment || !uri.hasEmptyPath) {
      throw new UnsupportedError('URI path and fragment must be empty.');
    }
    if (uri.userInfo.isNotEmpty) {
      throw new UnsupportedError('Authentification is not yet supported.');
    }

    // Establish connection.
    var socket = await Socket.connect(uri.host, uri.port);
    var connection = new DictConnection(socket);
    await connection.fetchResponse(
        expectedCode: DictStatusCode.INITIAL_CONNECT);

    // Send client information if specified.
    if (clientInfo != null) {
      await connection.client(clientInfo);
    }

    return connection;
  }

  /// The socket connected to the server.
  final Socket _socket;

  /// Subscription to stream of the response lines of the server.
  final StreamSubscription<String> _lines;

  DictConnection(Socket socket)
      : _socket = socket,
        _lines = socket
            .transform(new Utf8Decoder())
            .transform(new LineSplitter())
            .listen(null)..pause();

  /// Receives a line from the server.
  Future<String> fetchLine() {
    var completer = new Completer();
    _lines.onData((String line) {
      completer.complete(line);
      _lines.pause();
    });
    _lines.resume();
    return completer.future;
  }

  /// Receives a status response line.
  ///
  /// Throws an error if [expectedCode] has been specified but does not match.
  Future<DictResponse> fetchResponse({DictStatusCode expectedCode}) async {
    var line = await fetchLine();
    var code = new DictStatusCode.fromString(line.substring(0, 3));
    if (expectedCode != null) code.expect(expectedCode);
    return new DictResponse(code, message: line.substring(4));
  }

  /// Receives lines until a line contains only a period.
  Stream<String> fetchTextBodyLines() async* {
    while (true) {
      var line = await fetchLine();
      if (line == '.') break;
      yield line;
    }
  }

  /// Receives text until a line contains only a period.
  Future<String> fetchTextBody() => fetchTextBodyLines().join('\n');

  /// Sends a command.
  Future<DictResponse> command(String name,
      [List<String> args = const []]) async {
    var data = "$name ${stringifyDictParameters(args)}\n";
    _socket.add(UTF8.encode(data));
    return fetchResponse();
  }

  /// Provides information about the client for possible logging and
  /// statistical purposes.
  Future client(String clientInfo) async {
    var response = await command('CLIENT', [clientInfo]);
    response.code.expect(DictStatusCode.OK);
  }

  @override
  Stream<DictDefinition> define(String word, {String database: '*'}) async* {
    var response = await command('DEFINE', [database, word]);
    if (response.code == DictStatusCode.WORD_FOUND) {
      var n = int.parse(response.parameters[0]);
      for (var i = 0; i < n; i++) {
        var def = await fetchResponse(expectedCode: DictStatusCode.DEFINITION);
        yield new DictDefinition(
            word: def.parameters[0],
            database: new DictDatabase(def.parameters[1],
                description: def.parameters[2]),
            text: await fetchTextBody());
      }
      await fetchResponse(expectedCode: DictStatusCode.OK);
    } else {
      response.code.expect(DictStatusCode.NO_MATCH);
    }
  }

  @override
  Stream<DictMatch> match(String word,
      {String database: '*', String strategy: '.'}) async* {
    var response = await command('MATCH', [database, strategy, word]);
    if (response.code == DictStatusCode.MATCH_FOUND) {
      await for (var line in fetchTextBodyLines()) {
        yield DictMatch.parse(line);
      }
      await fetchResponse(expectedCode: DictStatusCode.OK);
    } else {
      response.code.expect(DictStatusCode.NO_MATCH);
    }
  }

  @override
  Stream<DictDefinition> matchDefine(String word,
      {String database: '*', String strategy: '.'}) async* {
    var matches = match(word, database: database, strategy: strategy);
    for (var m in await matches.toList()) {
      yield* define(m.word, database: m.database);
    }
  }

  @override
  Stream<DictDatabase> showDatabases() async* {
    var response = await command('SHOW DATABASES');
    if (response.code == DictStatusCode.DATABASES_PRESENT) {
      await for (var line in fetchTextBodyLines()) {
        yield DictDatabase.parse(line);
      }
      await fetchResponse(expectedCode: DictStatusCode.OK);
    } else {
      response.code.expect(DictStatusCode.NO_DATABASES_PRESENT);
    }
  }

  @override
  Stream<DictStrategy> showStrategies() async* {
    var response = await command('SHOW STRATEGIES');
    if (response.code == DictStatusCode.STRATEGIES_AVAILABLE) {
      await for (var line in fetchTextBodyLines()) {
        yield DictStrategy.parse(line);
      }
      await fetchResponse(expectedCode: DictStatusCode.OK);
    } else {
      response.code.expect(DictStatusCode.NO_STRATEGIES_AVAILABLE);
    }
  }

  @override
  Future<String> showInfo(String database) async {
    var response = await command('SHOW INFO', [database]);
    response.code.expect(DictStatusCode.DATABASE_INFO);
    var text = await fetchTextBody();
    await fetchResponse(expectedCode: DictStatusCode.OK);
    return text;
  }

  @override
  Future<String> showServer() async {
    var response = await command('SHOW SERVER');
    response.code.expect(DictStatusCode.SERVER_INFO);
    var text = await fetchTextBody();
    await fetchResponse(expectedCode: DictStatusCode.OK);
    return text;
  }

  @override
  Future<String> status() async {
    var response = await command('STATUS');
    response.code.expect(DictStatusCode.STATUS);
    return response.message;
  }

  @override
  Future<String> help() async {
    var response = await command('HELP');
    response.code.expect(DictStatusCode.HELP_TEXT);
    var text = await fetchTextBody();
    await fetchResponse(expectedCode: DictStatusCode.OK);
    return text;
  }

  /// Exits the server cleanly.
  Future<DictResponse> quit() async {
    var response = await command('QUIT');
    response.code.expect(DictStatusCode.CLOSING_CONNECTION);
    _socket.close();
    _lines.cancel();
    return response;
  }
}
