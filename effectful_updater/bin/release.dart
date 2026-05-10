import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'helper/copy.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'platform',
      abbr: 'p',
      allowed: ['macos', 'windows', 'linux'],
      mandatory: true,
      help: 'Target platform',
    )
    ..addFlag('help', abbr: 'h', negatable: false);

  final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(parser.usage);
    exit(1);
  }

  if (results['help'] as bool) {
    print(parser.usage);
    exit(0);
  }

  final platform = results['platform'] as String;
  final pubspecContent = await File('pubspec.yaml').readAsString();
  final appName = RegExp(
    r'^name:\s*(.+)$',
    multiLine: true,
  ).firstMatch(pubspecContent)!.group(1)!.trim();
  final semver = Version.parse(
    RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(pubspecContent)!.group(1)!.trim(),
  );
  final ver = '${semver.major}.${semver.minor}.${semver.patch}';

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null || flutterRoot.isEmpty) {
    stderr.writeln('FLUTTER_ROOT not set');
    exit(1);
  }
  final flutterBin = p.join(flutterRoot, 'bin', Platform.isWindows ? 'flutter.bat' : 'flutter');
  if (!File(flutterBin).existsSync()) {
    stderr.writeln('Flutter not found at $flutterBin');
    exit(1);
  }

  final buildCmd = [
    flutterBin,
    'build',
    platform,
    '--dart-define',
    'FLUTTER_BUILD_NAME=$ver',
    ...results.rest,
  ];
  print('Running: ${buildCmd.join(' ')}');
  final process = await Process.start(buildCmd.first, buildCmd.sublist(1));
  process.stdout.transform(utf8.decoder).listen(print);
  process.stderr.transform(utf8.decoder).listen(stderr.writeln);
  if (await process.exitCode != 0) {
    stderr.writeln('Build failed');
    exit(1);
  }

  final buildDir = platform == 'windows'
      ? Directory(p.join('build', 'windows', 'x64', 'runner', 'Release'))
      : platform == 'macos'
      ? Directory(p.join('build', 'macos', 'Build', 'Products', 'Release', '$appName.app'))
      : Directory(p.join('build', 'linux', 'x64', 'release', 'bundle'));

  if (!buildDir.existsSync()) {
    stderr.writeln('Build dir not found: ${buildDir.path}');
    exit(1);
  }

  final distPath = platform == 'macos'
      ? p.join('dist', ver, '$appName-$ver-$platform', '$appName.app')
      : p.join('dist', ver, '$appName-$ver-$platform');

  final distDir = Directory(distPath);
  if (distDir.existsSync()) distDir.deleteSync(recursive: true);
  await copyDirectory(buildDir, distDir);
  print('Release created at $distPath');
}
