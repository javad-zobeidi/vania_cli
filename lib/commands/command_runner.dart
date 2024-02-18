import 'package:vania_cli/commands/build_command.dart';
import 'package:vania_cli/commands/command.dart';
import 'package:vania_cli/commands/create_controller_command.dart';
import 'package:vania_cli/commands/create_middleware_command.dart';
import 'package:vania_cli/commands/create_migration_command.dart';
import 'package:vania_cli/commands/migrate_command.dart';
import 'package:vania_cli/commands/new_project.dart';
import 'package:vania_cli/commands/serve_command.dart';
import 'package:vania_cli/commands/update_command.dart';

class CommandRunner {
  final Map<String, Command> _commands = {
    'serve': ServeCommand(),
    'new': NewProject(),
    'build': BuildCommand(),
    'update': UpdateCommand(),
    'make:controller': CreateControllerCommand(),
    'make:middleware': CreateMiddlewareCommand(),
    'make:migration': CreateMigrationCommand(),
    'migrate': MigrateCommand(),
  };

  void run(List<String> arguments) {
    if (arguments.isEmpty) {
      print(
          '\x1B[32m -V, --version  \x1B[0m\t\t Display this application version');
      _commands.forEach((name, command) {
        print('\x1B[32m$name\x1B[0m\t\t${command.description}');
      });
      return;
    }

    final commandName = arguments[0];

    if (commandName == '-V' ||
        commandName == '--version' ||
        commandName == '--v') {
      print(' \x1B[1mVania Dart Framework Alpha \x1B[32m 0.0.1  \x1B[0m');
      return;
    }

    final command = _commands[commandName];

    if (command == null) {
      print(
          ' \x1B[41m\x1B[37m ERROR \x1B[0m Command "$commandName" is not defined.');
      return;
    }

    final commandArguments = arguments.sublist(1);
    command.execute(commandArguments);
  }
}