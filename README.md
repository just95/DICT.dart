# DICT.dart

This package provides APIs to communicate with [DICT][rfc] servers.

From server-side applications it's possible to communicate directly with DICT
servers via a `dart:io` socket, but it's also possible to use XHR to receive
translations from a client-side application via the included HTTP server.

Because of the HTTP interface provided by this package you are not required to
use dart. Any programming language which allows you to create HTTP requests
and parse the JSON responses can be used.

## Installation

Simply add the `dictapi` package as a dependency to the `pubspec.yaml` file of
your application and run the `pub get` command.

```yaml
dependencies:
  dictapi: ^0.1.0
```

If you only want to set up the HTTP server, you can skip the step above and
activate the `dictapi` package instead.

```sh
pub global activate dictapi
```

## Usage

### Server-side

If your code runs in the dart virtual machine, add the following import
directive:

```dart
import 'package:dictapi/vm.dart';
```

Then you can connect to the DICT server using the `DictConnection.connect`
method. The first argument is an `URI` pointing to the DICT server.
The method returns a future which will complete with the instance of
`DictConnection` once a connection has been established.
If the optional named `clientInfo` argument is passed, the `CLIENT` command
will be send first.

```dart
var uri = Uri.parse('dict://example.com:2628');
var dict = await DictConnection.connect(uri, clientInfo: 'My Dictionary');
```

### Client-side

If your code runs in the browser, add the following import directive:

```dart
import 'package:dictapi/web.dart';
```

Then create an instance of the `DictXhr` class and pass the base URI of the
HTTP server to the constructor.

```dart
var uri = Uri.parse('http://example.com:8080');
var dict = new DictXhr(uri);
```

### Common API

The `DictConnection` and `DictXhr` classes both implement the `DictApi`
interface. The components of your application which work independently of
the target platform can import the following library

```dart
import 'package:dictapi/dictapi.dart';
```

to communicate with DICT servers.

### HTTP interface

To run the HTTP server change into your package directory and run the
`pub run dictapi serve` command. If you've activated the `dictapi` package, run
the `pub global run dictapi serve` instead.

By default the HTTP server listens for incoming requests on port `8080` and
connects to the local DICT server on port `2628`. You can pass command
line arguments to change this behavior.
Type `pub [global] run dictapi serve --help` to see a list of all available
options.

When open a browser and and navigate to `localhost` on the configured port,
e.g. <http://localhost:8080>. The server should respond with a list of
available routes.

## License

DICT.dart is licensed under the MIT license agreement.
See the LICENSE file for details.

[rfc]: https://tools.ietf.org/html/rfc2229 "A Dictionary Server Protocol"
