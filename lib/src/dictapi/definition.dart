// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// Definition of a word.
class DictDefinition {
  /// The defined word.
  final String word;

  /// The database the definition was obtained from.
  final DictDatabase database;

  /// The text of the definition.
  final String text;

  DictDefinition({this.word, this.database, this.text});

  /// Restore from JSON representation.
  DictDefinition.fromJson(json)
      : word = json['word'],
        database = new DictDatabase.fromJson(json['database']),
        text = json['text'];

  @override
  bool operator ==(other) =>
      other is DictDefinition &&
      word == other.word &&
      database == other.database &&
      text == other.text;

  @override
  int get hashCode => hashObjects([word, database, text]);

  /// Convert to a JSON encodable object.
  toJson() => {'word': word, 'database': database.toJson(), 'text': text};
}
