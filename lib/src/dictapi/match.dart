// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// A match result.
class DictMatch {
  /// Parses a match result.
  static DictMatch parse(String str) {
    var params = parseDictParameters(str);
    return new DictMatch(params[1], database: params[0]);
  }

  /// Word which was matched.
  final String word;

  /// Name of the database the match was found in.
  final String database;

  DictMatch(this.word, {this.database});

  /// Restore from JSON representation.
  DictMatch.fromJson(json)
      : word = json['word'],
        database = json['database'];

  @override
  bool operator ==(other) =>
      other is DictMatch && word == other.word && database == other.database;

  @override
  int get hashCode => hashObjects([word, database]);

  /// Convert to a JSON encodable object.
  toJson() => {'word': word, 'database': database};
}
