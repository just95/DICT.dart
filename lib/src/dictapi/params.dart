// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

final DictParser _parser = new DictParser();

/// Parses a parameter list.
List<String> parseDictParameters(String str) => _parser.parse(str).value;

/// Adds double quotes around a parameter if necassary.
String stringifyDictParameter(String param) {
  if ([' ', r'\', '"', "'"].any(param.contains)) {
    var escaped = param.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
    return '"$escaped"';
  }
  return param;
}

/// Converts a list of parameters to a parameter string.
String stringifyDictParameters(List<String> params) =>
    params.map(stringifyDictParameter).join(' ');
