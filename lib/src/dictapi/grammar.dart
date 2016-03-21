// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// Grammar of DICT parameter lists.
class DictGrammar extends GrammarDefinition {
  Parser get DQ => char('"');
  Parser get SQ => char("'");
  Parser get BACKSLASH => char('\\');
  Parser get SPACE => char(' ');

  Parser get dqString => DQ & dqText.star() & DQ;
  Parser get dqText => quotedPair | (BACKSLASH | DQ).neg();
  Parser get sqString => SQ & sqText.star() & SQ;
  Parser get sqText => quotedPair | (BACKSLASH | SQ).neg();
  Parser get quotedPair => BACKSLASH & any();

  Parser get atom => (SPACE | SQ | DQ | BACKSLASH).neg().plus();
  Parser get string => dqString | sqString | quotedPair;
  Parser get word => (atom | string).plus();

  Parser start() => word.trim().plus();
}
