import 'dart:io';
import 'package:vania_cli/common/recase.dart';

import 'command.dart';

String controllerStubs = '''
import 'package:vania/vania.dart';

class controllerName extends Controller {

     Future<Response> index() async {
          return Response.json({'message':'Hello World'});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          return Response.json({});
     }

     Future<Response> show(int id) async {
          return Response.json({});
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          return Response.json({});
     }

     Future<Response> destroy(int id) async {
          return Response.json({});
     }
}

final controllerName varName = controllerName();

''';

class CreateControllerCommand implements Command {
  @override
  String get name => 'make:controller';

  @override
  String get description => 'Create a new controller class';

  @override
  void execute(List<String> arguments) {
    if (arguments.isEmpty) {
      print('  What should the controller be named?');
      stdout.write('\x1B[1m > \x1B[0m');
      arguments.add(stdin.readLineSync()!);
    }

    RegExp alphaRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_/\\]*$');

    if (!alphaRegex.hasMatch(arguments[0])) {
      print(
          ' \x1B[41m\x1B[37m ERROR \x1B[0m Controller must contain only letters a-z, numbers 0-9 and optional _');
      exit(0);
    }

    List fileName = arguments[0].split(RegExp(r'[/]'));

    String controllerName = fileName[fileName.length - 1];

    String secondPath = "";

    if (fileName.length > 1) {
      fileName.remove(fileName[fileName.length - 1]);
      secondPath = fileName.join("/");
      secondPath = secondPath.endsWith("/") ? secondPath : "$secondPath/";
    }

    String controllerPath =
        '${Directory.current.path}/lib/app/http/controllers/$secondPath${controllerName.snakeCase}.dart';
    File newFile = File(controllerPath);

    if (newFile.existsSync()) {
      print(' \x1B[41m\x1B[37m ERROR \x1B[0m Controller already exists.');
      exit(0);
    }

    newFile.createSync(recursive: true);

    String str = controllerStubs
        .replaceAll('controllerName', controllerName.pascalCase)
        .replaceFirst('varName', controllerName.camelCase);

    newFile.writeAsString(str);

    print(
        ' \x1B[44m\x1B[37m INFO \x1B[0m Controller [$controllerPath] created successfully.');
  }
}
