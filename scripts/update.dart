import 'dart:io';

/// update.dart — Cross-platform Dart equivalent of update.sh
///
/// Usage: dart run scripts/update.dart
///
/// Reads pubspec.yaml, extracts version (e.g. "10.1.2+177"),
/// increments the build number (part after +), writes back
/// pubspec.yaml and regenerates lib/constants/version.dart.
void main() {
  const pubspecPath = 'pubspec.yaml';
  const versionDartPath = 'lib/constants/version.dart';

  try {
    // -------------------------------------------------------
    // 1. Read and parse pubspec.yaml
    // -------------------------------------------------------
    final pubspecContent = File(pubspecPath).readAsStringSync();

    // Match: ^version:  10.1.2  +  177  # comment...
    //        ^prefix  ^semver  ^build ^suffix
    final versionRegex =
        RegExp(r'^(version:\s*)(\d+\.\d+\.\d+)\+(\d+)(.*)$', multiLine: true);

    final match = versionRegex.firstMatch(pubspecContent);
    if (match == null) {
      _fail('Could not parse version from pubspec.yaml');
    }

    final prefix = match.group(1)!; // "version: "
    final semver = match.group(2)!; // "10.1.2"
    final buildStr = match.group(3)!; // "177"
    final suffix = match.group(4)!; // " # run update.sh..."

    final buildNumber = int.tryParse(buildStr);
    if (buildNumber == null) {
      _fail('Build number "$buildStr" is not a valid integer');
    }

    final newBuildNumber = buildNumber + 1;
    final newVersion = '$semver+$newBuildNumber';

    // -------------------------------------------------------
    // 2. Write updated pubspec.yaml (temp -> rename for safety)
    // -------------------------------------------------------
    final newPubspec = pubspecContent.replaceFirst(
      match.group(0)!,
      '$prefix$semver+$newBuildNumber$suffix',
    );

    _writeAtomically(pubspecPath, newPubspec);

    // -------------------------------------------------------
    // 3. Write lib/constants/version.dart (temp -> rename)
    // -------------------------------------------------------
    final newVersionDart = "const appVersion = '$semver';\n";
    _writeAtomically(versionDartPath, newVersionDart);

    // -------------------------------------------------------
    // 4. Print result
    // -------------------------------------------------------
    print('Updated to version $newVersion');
  } catch (e) {
    _fail(e.toString());
  }
}

/// Writes [content] to a temporary sibling file, then atomically
/// renames it over [path].  This prevents partial/corrupt files if
/// the process is killed mid-write.
void _writeAtomically(String path, String content) {
  final file = File(path);
  final dir = file.parent;
  final tempPath = '${dir.path}${Platform.pathSeparator}$path.tmp';

  // Overwrite any stale .tmp from a previous failed run.
  File(tempPath).writeAsStringSync(content, flush: true);
  File(tempPath).renameSync(path);
}

/// Prints [message] to stderr and exits with code 1.
Never _fail(String message) {
  stderr.writeln('Error: $message');
  exit(1);
}
