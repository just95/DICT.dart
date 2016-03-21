// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

class DictResponse {
  /// Parses a match result.
  static DictResponse parse(String str) {
    var code = DictStatusCode.parse(str.substring(0, 3));
    return new DictResponse(code, message: str.substring(4));
  }

  /// A three digit status response code.
  final DictStatusCode code;

  /// The status text.
  final String message;

  /// The parameters of the response.
  final List<String> parameters;

  DictResponse(this.code, {String message})
      : message = message,
        parameters = parseDictParameters(message);

  /// Restore from JSON representation.
  factory DictResponse.fromJson(json) =>
      new DictResponse(new DictStatusCode(json['code']),
          message: json['message']);

  @override
  bool operator ==(other) =>
      other is DictResponse && code == other.code && message == other.message;

  @override
  int get hashCode => hashObjects([code, message]);

  /// Convert to a JSON encodable object.
  toJson() => {'code': code.toInt(), 'message': message};
}
