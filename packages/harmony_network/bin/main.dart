import 'dart:io';
import 'dart:isolate';

import 'package:harmony_network/command.dart';
import 'package:harmony_network/constants.dart';
import 'package:harmony_network/exceptions.dart';
import 'package:harmony_network/utils.dart';
import 'package:path/path.dart';

//example openapi cli command
//generate -i files/openapi-spec.yaml -g dart -o api/petstore_api --additional-properties=pubAuthor=Johnny dep,pubName=petstore_api
void main(List<String> arguments) async {
  //fetching arguments from command line
  var useSnapshotJar = arguments.contains('--use-snapshot-jar') || arguments.contains('-s');
  var useVersion6Jar = arguments.contains('--use-version-6') || arguments.contains('-v6');
  if (useVersion6Jar && useSnapshotJar) {
    throw InvalidConfigException('ERROR: multiple versions for openapi-generator defined');
  }
  //fetching arguments from configuration inside pybspec.yaml
  var config = loadYamlFileConfig('pubspec.yaml');
  var inputFilePath = config['openapi_file_path'];
  var outputPath = config['output_path'];
  //fetching optional arguments from configuration inside pubspec.yaml
  var skipValidation = false;
  if (config.containsKey('skip_validation')) {
    skipValidation = config['skip_validation'];
  }
  String? moduleName;
  if (config.containsKey('module_name')) {
    moduleName = config['module_name'];
  }
  String? authorName;
  if (config.containsKey('author_name')) {
    authorName = config['author_name'];
  }

  //making sure input path contains a file and exists
  var inputFile = File(inputFilePath);
  if (!inputFile.existsSync()) {
    throw InvalidConfigException('no file found in path ($inputFilePath) as openapi file path');
  }

  //deleting old generated module if it exists
  var outputPathDirectory = Directory(outputPath);
  if (await outputPathDirectory.exists()) {
    await deleteModule(outputPath);
  }

  // generating network module from openapi spec .yaml file with 3 steps
  // 1- generate module dart code in output directory
  // 2- run `pub get` in the generated module
  // 3- run source generation in generated module
  var exitCode = await generateModule(
    inputFilePath,
    outputPath,
    useSnapshotJar: useSnapshotJar,
    useVersion6Jar: useVersion6Jar,
    skipValidation: skipValidation,
    moduleName: moduleName,
    authorName: authorName,
  );
  if (exitCode == 0) {
    exitCode = await runPubGet(directory: outputPath);
  }
  if (exitCode == 0) {
    exitCode = await runBuildRunner(directory: outputPath);
  }
  if (exitCode == 0) {
    logToConsole('ALL DONE , YOU\'RE GOOD TO GO');
  } else {
    logToConsole('ERROR : something went wrong generating network module ');
  }
}

/// runs a process and deletes all the files in the given [directory] recursively
///
Future<int> deleteModule(String directory) async {
  exitCode = 0;
  logToConsole('trying to delete previous build in directory -> $directory');
  var processResult = await Process.run('rm', ['-r', directory], runInShell: Platform.isWindows);
  exitCode = processResult.exitCode;
  logToConsole(processResult.stdout);
  logToConsole(processResult.stderr);
  return exitCode;
}

/// generates network module from the openapi specification file (which must be in yaml) from the given [inputFilePath]
/// into the [outputDir] using openapi-generator-cli taken from https://github.com/OpenAPITools/openapi-generator
/// if flag [useSnapshotJar] is true it will use the snapshot version of the openapi-generator library
Future<int> generateModule(
  String inputFilePath,
  String outputDir, {
  bool useSnapshotJar = false,
  bool useVersion6Jar = false,
  bool skipValidation = false,
  String? moduleName = 'network',
  String? authorName = 'six solution technologies',
}) async {
  exitCode = 0; // presume success
  var openApiJarUri = Uri.parse(OPENAPI_STABLE_JAR_PATH);
  if (useSnapshotJar) {
    openApiJarUri = Uri.parse(OPENAPI_SNAPSHOT_JAR_PATH);
  } else if (useVersion6Jar) {
    openApiJarUri = Uri.parse(OPENAPI_V6_JAR_PATH);
  }
  if (skipValidation) {
    logToConsole('skipping spec file validation');
  }
  logToConsole('using openapi generator jar file from ${basename(openApiJarUri.path)}');
  var binPath = (await Isolate.resolvePackageUri(openApiJarUri))!.toFilePath(windows: Platform.isWindows);
  var JAVA_OPTS = Platform.environment['JAVA_OPTS'] ?? '';

  var additionalProperties = '--additional-properties=pubAuthor=$authorName,pubName=$moduleName';

  var args = <String>[
    'generate',
    '-i',
    inputFilePath,
    '-g',
    'dart-dio-next',
    '-o',
    outputDir,
    if (skipValidation) '--skip-validate-spec',
    additionalProperties
  ];

  var commands = [
    '-jar',
    "${"${binPath}"}",
    ...args,
  ];
  logToConsole(commands);
  if (JAVA_OPTS.isNotEmpty) {
    commands.insert(0, JAVA_OPTS);
  }
  var pr = await Process.run('java', commands);
  logToConsole(pr.exitCode);
  logToConsole(pr.stdout);
  logToConsole(pr.stderr);
  return pr.exitCode;
}

/// starts a new dart process and runs `flutter pub get` command in give [directory]
Future<int> runPubGet({required String directory}) async {
  logToConsole('running `flutter pub get` in directory -> $directory');
  exitCode = 0;
  final command = Command('flutter', ['pub', 'get']);
  var installOutput = await Process.run(
    command.executable,
    command.arguments,
    runInShell: Platform.isWindows,
    workingDirectory: '$directory',
  );
  logToConsole(installOutput.stdout);
  logToConsole(installOutput.stderr);
  logToConsole('harmony_network ran (flutter pub get) exit code was ${installOutput.exitCode}');
  exitCode = installOutput.exitCode;
  return exitCode;
}

/// starts a new dart process and runs `flutter pub run build_runner build --delete-conflicting-outputs`
///  command in give [directory]
Future<int> runBuildRunner({directory}) async {
  logToConsole('running code generation in directory -> $directory');
  exitCode = 0;
  var args = 'pub run build_runner build --delete-conflicting-outputs';
  final command = Command('flutter', args.split(' ').toList());
  ProcessResult runnerOutput;
  runnerOutput = await Process.run(
    command.executable,
    command.arguments,
    runInShell: Platform.isWindows,
    workingDirectory: '$directory',
  );
  logToConsole(runnerOutput.stdout);
  logToConsole(runnerOutput.stderr);
  logToConsole(
    'harmony_network ran (flutter pub run build_runner build --delete-conflicting-outputs)'
    ' exit code was ${runnerOutput.exitCode}',
  );
  return exitCode;
}
