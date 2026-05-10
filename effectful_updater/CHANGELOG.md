## 0.1.0

* Initial release.
* Delta downloads with Blake2b file hashing — only changed files are fetched.
* Pluggable update source via `EffectfulUpdateSource`, with built-in `EffectfulJsonManifestUpdateSource` for JSON manifests.
* `flutter_hooks`-based API: `useEffectfulUpdater`, `EffectfulUpdateBuilder`, and `EffectfulUpdateListener`.
* Native plugin implementations for macOS (Swift), Windows (C++), and Linux (C).
* CLI tools: `effectful_updater:release` for build packaging and `effectful_updater:archive` for hash manifest generation.
