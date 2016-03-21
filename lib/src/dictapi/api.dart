// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// Asynchronous API to communicate with a DICT server.
abstract class DictApi {
  /// Looks up the specified word in the specified [database].
  Stream<DictDefinition> define(String word, {String database: '*'});

  /// Searches an index for the [database], and reports words which were found
  /// using a particular [strategy].
  Stream<DictMatch> match(String word,
      {String database: '*', String strategy: '.'});

  /// First searches an index for the [database] using the specified search
  /// [strategy] and then looks up the matches in the specified [database].
  Stream<DictDefinition> matchDefine(String word,
      {String database: '*', String strategy: '.'});

  /// Lists all currently accessible databases.
  Stream<DictDatabase> showDatabases();

  /// Lists all currently available search strategies.
  Stream<DictStrategy> showStrategies();

  /// Shows the source, copyright, and licensing information about the
  /// specified database.
  Future<String> showInfo(String database);

  /// Shows information about the DICT server.
  Future<String> showServer();

  /// Server-specific timing or debugging information.
  Future<String> status();

  /// Provides a short summary of commands that are understood by the server.
  Future<String> help();
}
