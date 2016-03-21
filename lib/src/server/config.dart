// Copyright (c) 2016 Justin Andresen. All rights reserved.
// This software may be modified and distributed under the terms
// of the MIT license. See the LICENSE file for details.

part of dictapi.server;

/// Configuration
class ServerConfig {
  /// URI of the DICT server.
  final Uri dictUri;

  /// URI of the http server.
  final Uri httpUri;

  /// Additional information about this client for possible logging
  /// and statistical purposes.
  final String clientInfo;

  ServerConfig({this.dictUri, this.httpUri, this.clientInfo});
}
