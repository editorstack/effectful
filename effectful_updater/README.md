# effectful_updater

A Flutter desktop self-updater plugin for macOS, Windows, and Linux. Downloads delta updates (only changed files), verifies them with Blake2b hashes, and restarts the app to apply changes.

Built with `flutter_hooks`, `pub_semver`, and `dio`. Designed as a pluggable, unstyled alternative to `flutter_desktop_updater`.

## Features

- Delta downloads — only changed files are fetched
- Blake2b file hashing for integrity verification
- Semantic versioning via `pub_semver`
- Pluggable update source (`EffectfulUpdateSource` abstract class)
- `flutter_hooks`-based API — no `ChangeNotifier`, no `InheritedWidget`
- Raw, unstyled widgets — you control the UI
- CLI tools for building releases and generating hash manifests
- Platforms: macOS (Swift), Windows (C++), Linux (C)

## Installation

```yaml
dependencies:
  effectful_updater:
    git:
      url: https://github.com/editorstack/effectful
      path: effectful_updater
```

## Quick Start

### 1. Host a manifest

Upload a JSON manifest to a URL accessible from your app:

```json
{
  "appName": "MyApp",
  "description": "Optional release notes",
  "items": [
    {
      "version": "1.2.0",
      "platform": "macos",
      "mandatory": true,
      "url": "https://cdn.example.com/releases/1.2.0/macos/",
      "date": "2026-03-29",
      "changes": [
        { "type": "feat", "message": "New feature" },
        { "type": "fix", "message": "Bug fix" }
      ]
    }
  ]
}
```

The `url` field is the base URL where the update files and `hashes.json` are hosted.

### 2. Use `EffectfulUpdateBuilder`

```dart
import 'package:effectful_updater/effectful_updater.dart';

EffectfulUpdateBuilder(
  currentVersion: '1.1.0',
  source: EffectfulJsonManifestUpdateSource('https://cdn.example.com/manifest.json'),
  builder: (context, handle) {
    return switch (handle.status.phase) {
      EffectfulUpdatePhase.idle      => const SizedBox.shrink(),
      EffectfulUpdatePhase.checking  => const Text('Checking for updates...'),
      EffectfulUpdatePhase.upToDate  => const Text('Up to date'),
      EffectfulUpdatePhase.available => Column(children: [
          Text('Update ${handle.status.availableUpdate?.version} available'),
          Text('Download size: ${handle.status.downloadSizeKB.toStringAsFixed(1)} KB'),
          ElevatedButton(onPressed: handle.downloadUpdate, child: const Text('Update')),
          TextButton(onPressed: handle.skipUpdate, child: const Text('Skip')),
        ]),
      EffectfulUpdatePhase.downloading => LinearProgressIndicator(
          value: handle.status.progress?.let((p) => p.receivedBytes / p.totalBytes),
        ),
      EffectfulUpdatePhase.ready     => ElevatedButton(
          onPressed: handle.restartApp,
          child: const Text('Restart to apply update'),
        ),
      EffectfulUpdatePhase.error     => Text('Error: ${handle.status.error}'),
      _                              => const SizedBox.shrink(),
    };
  },
)
```

### 3. Use the hook directly

```dart
class MyWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final handle = useEffectfulUpdater(
      currentVersion: '1.1.0',
      source: EffectfulJsonManifestUpdateSource('https://cdn.example.com/manifest.json'),
      autoCheck: true, // default — checks on mount
    );

    // handle.status.phase, handle.checkForUpdate(), handle.downloadUpdate(), etc.
    return const Placeholder();
  }
}
```

### 4. Side-effect listener

```dart
EffectfulUpdateListener(
  currentVersion: '1.1.0',
  source: EffectfulJsonManifestUpdateSource('https://cdn.example.com/manifest.json'),
  onUpdateAvailable: (update) => showUpdateDialog(context, update),
  onUpdateDownloaded: (update) => promptRestart(context),
  onError: (error) => logError(error),
  child: const MyAppBody(),
)
```

## API

### `EffectfulUpdater`

Low-level facade. Use hooks/widgets for most cases.

```dart
const updater = EffectfulUpdater();

// Check for an update
final update = await updater.checkForUpdate(
  currentVersion: '1.1.0',
  source: mySource,
);

// Stream download progress
if (update != null) {
  await for (final progress in updater.downloadUpdate(
    remoteUpdateFolder: update.url,
    changedFiles: update.changedFiles ?? [],
  )) {
    print('${progress.completedFiles}/${progress.totalFiles} files');
  }

  await updater.restartApp();
}
```

### `EffectfulUpdaterHandle` (from `useEffectfulUpdater`)

| Field / Method | Type | Description |
|---|---|---|
| `status` | `EffectfulUpdateStatus` | Current update state |
| `checkForUpdate()` | `Future<void>` | Manually trigger a check |
| `downloadUpdate()` | `Future<void>` | Start downloading |
| `skipUpdate()` | `void` | Move to `skipped` phase |
| `restartApp()` | `Future<void>` | Apply update and relaunch |

### `EffectfulUpdatePhase`

`idle` → `checking` → `available` → `downloading` → `ready` → *(restart)*

Other states: `upToDate`, `skipped`, `error`

## Update Source

Implement `EffectfulUpdateSource` to fetch manifests from any backend:

```dart
class MyUpdateSource implements EffectfulUpdateSource {
  @override
  Future<EffectfulUpdateManifest> fetchManifest() async {
    // fetch and return manifest
  }
}
```

The built-in `EffectfulJsonManifestUpdateSource` fetches a JSON manifest from a URL via `dio`.

## CLI Tools

Run from your **app's** package directory (not this plugin).

### Build a release

```sh
dart run effectful_updater:release -p macos
dart run effectful_updater:release -p windows
dart run effectful_updater:release -p linux
```

Outputs to `dist/<version>/<appName>-<version>-<platform>/`.

### Generate hashes for an update archive

```sh
dart run effectful_updater:archive -p macos
```

Walks the build output, computes Blake2b hashes for every file, and writes `hashes.json` into the archive directory. Upload that directory to the URL referenced in your manifest's `url` field.

## How updates work

1. App calls `checkForUpdate` — fetches the manifest and compares versions using `pub_semver`
2. If a newer version exists, `prepare` downloads the remote `hashes.json` and diffs it against local file hashes (Blake2b)
3. Only the changed files are downloaded into an `update/` subdirectory inside the app bundle
4. On `restartApp`, the native plugin copies files from `update/` over the existing bundle and relaunches the executable

## Key differences from `flutter_desktop_updater`

| | `flutter_desktop_updater` | `effectful_updater` |
|---|---|---|
| State management | `ChangeNotifier` | `flutter_hooks` |
| Versioning | Integer `shortVersion` | `pub_semver` semantic versions |
| HTTP client | `http` | `dio` |
| UI | 5 styled widgets | 2 raw builder/listener widgets |
| Update source | Hardcoded JSON fetch | Pluggable `EffectfulUpdateSource` |
| Current version | Native `getCurrentVersion()` | Consumer-provided string |
| Platform methods | 7 | 2 (`restartApp`, `getExecutablePath`) |
| Localization | Bundled | None — consumer provides strings |

## License

[MIT](./LICENSE)
