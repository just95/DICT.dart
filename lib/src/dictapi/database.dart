// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi;

/// A dictionary database.
class DictDatabase {
  /// Parses a database.
  static DictDatabase parse(String str) {
    var params = parseDictParameters(str);
    return new DictDatabase(params[0], description: params[1]);
  }

  /// Name of the database.
  final String name;

  /// Short description of the database.
  final String description;

  DictDatabase(this.name, {this.description});

  /// Restore from JSON representation.
  DictDatabase.fromJson(json)
      : name = json['name'],
        description = json['description'];

  @override
  bool operator ==(other) =>
      other is DictDatabase &&
      name == other.name &&
      description == other.description;

  @override
  int get hashCode => hashObjects([name, description]);

  /// Convert to a JSON encodable object.
  toJson() => {'name': name, 'description': description};
}
