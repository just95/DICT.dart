// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// A status response code.
class DictStatusCode {
  /// Parses a status response code.
  static DictStatusCode parse(String str) => new DictStatusCode(int.parse(str));

  /// Indicates that at least one database is present.
  static const DictStatusCode DATABASES_PRESENT = const DictStatusCode(110);

  /// Indicates that at least one strategy is available.
  static const DictStatusCode STRATEGIES_AVAILABLE = const DictStatusCode(111);

  /// Indicates that the database information follows.
  static const DictStatusCode DATABASE_INFO = const DictStatusCode(112);

  /// Indicates that the help text follows.
  static const DictStatusCode HELP_TEXT = const DictStatusCode(113);

  /// Indicates that the server information follows.
  static const DictStatusCode SERVER_INFO = const DictStatusCode(114);

  /// Indicates that a word has been found and at least one [DEFINITION]
  /// follows.
  static const DictStatusCode WORD_FOUND = const DictStatusCode(150);

  /// For each definition, status code 151 is sent, followed by the textual
  /// body of the definition.
  static const DictStatusCode DEFINITION = const DictStatusCode(151);

  /// Indicates that at least on match was found.
  static const DictStatusCode MATCH_FOUND = const DictStatusCode(152);

  /// Server-specific timing or debugging information.
  static const DictStatusCode STATUS = const DictStatusCode(210);

  /// Indicates that connection to the server was established successfully.
  static const DictStatusCode INITIAL_CONNECT = const DictStatusCode(220);

  /// Indicates that the server is closing the connection.
  static const DictStatusCode CLOSING_CONNECTION = const DictStatusCode(221);

  /// Indicates that a command has been executed successfully.
  static const DictStatusCode OK = const DictStatusCode(250);

  /// Indicates that the specified search database is not available.
  static const DictStatusCode INVALID_DATABASE = const DictStatusCode(550);

  /// Indicates that the specified search strategy is invalid.
  static const DictStatusCode INVALID_STRATEGY = const DictStatusCode(551);

  /// Indicates that a word has not been found.
  static const DictStatusCode NO_MATCH = const DictStatusCode(552);

  /// Indicates that there are no databases available.
  static const DictStatusCode NO_DATABASES_PRESENT = const DictStatusCode(554);

  /// Indicates that there are no strategies available.
  static const DictStatusCode NO_STRATEGIES_AVAILABLE =
      const DictStatusCode(555);

  /// The first digit of this code.
  final int x;

  /// The first digit of this code.
  final int y;

  /// The first digit of this code.
  final int z;

  const DictStatusCode(int code)
      : x = (code ~/ 100) % 10,
        y = (code ~/ 10) % 10,
        z = code % 10;

  factory DictStatusCode.fromString(String code) =>
      new DictStatusCode(int.parse(code));

  @override
  bool operator ==(other) =>
      other is DictStatusCode && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => hashObjects([x, y, z]);

  /// Tests whether this is the [expected] code.
  ///
  /// Throws an [UnexpectedDictResponseError] otherwise.
  void expect(DictStatusCode expected) => expectAnyOf([expected]);

  /// Tests whether this is one of the [expected] codes.
  ///
  /// Throws an [UnexpectedDictResponseError] otherwise.
  void expectAnyOf(Iterable<DictStatusCode> expected) {
    if (!expected.contains(this)) {
      throw new UnexpectedDictResponseError(expected: expected, got: this);
    }
  }

  /// Tests whether this code indicates a positive reply.
  bool get isPositive => x <= 3;

  /// Tests whether this code indicates a negative reply.
  bool get isNegative => x >= 3;

  /// Tests whether this code indicates a positive preliminary reply.
  bool get isPreliminary => x == 1;

  /// Tests whether this code indicates a positive completion reply.
  bool get isCompletion => x == 2;

  /// Tests whether this code indicates a positive intermediate reply.
  bool get isIntermediate => x == 3;

  /// Tests whether this code indicates a transient negative completion reply.
  bool get isTransient => x == 4;

  /// Tests whether this code indicates a permanent negative completion reply.
  bool get isPermanent => x == 5;

  /// Get the numeric representation of this code.
  int toInt() => x * 100 + y * 10 + z;

  @override
  String toString() => '$x$y$z';
}
