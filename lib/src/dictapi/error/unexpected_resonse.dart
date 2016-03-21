// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// An error which is thrown when an unexpected status code is received.
class UnexpectedDictResponseError {
  final List<DictStatusCode> expected;
  final DictStatusCode got;

  UnexpectedDictResponseError({Iterable<DictStatusCode> expected, this.got})
      : expected = new List.from(expected);

  @override
  String toString() {
    var joined = new StringBuffer();
    for (int i = 0; i < expected.length; i++) {
      if (i != 0) {
        joined.write(i == expected.length - 1 ? ' or ' : ', ');
      }
      joined.write(expected[i]);
    }
    return 'Expected status response code $joined. Got $got.';
  }
}
