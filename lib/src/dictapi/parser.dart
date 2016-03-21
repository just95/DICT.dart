// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// Definition of [DictParser].
class DictParserDefinition extends DictGrammar {
  @override
  Parser get dqString => super.dqString.pick(1).map((chars) => chars.join());

  @override
  Parser get sqString => super.sqString.pick(1).map((chars) => chars.join());

  @override
  Parser get quotedPair => super.quotedPair.pick(1);

  @override
  Parser get atom => super.atom.flatten();

  @override
  Parser get word => super.word.map((chars) => chars.join());
}

/// Parser for dict parameter lists.
class DictParser extends GrammarParser {
  DictParser() : super(new DictParserDefinition());
}
