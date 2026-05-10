# Effectful

A small collection of Dart and Flutter packages, mirrored from the [editorstack](https://github.com/editorstack/editorstack) monorepo as a one-way public sync.

| Package | Description |
| --- | --- |
| [`effectful_ui`](./effectful_ui) | shadcn-inspired Flutter widget library with direct style provisioning |
| [`effectful_utils`](./effectful_utils) | Dart utility extensions for strings, collections, numbers, time, ranges, and function composition |
| [`effectful_updater`](./effectful_updater) | Flutter desktop self-updater plugin for macOS, Windows, and Linux |

## Mirror, not a contribution destination

This repository is a downstream mirror of [editorstack](https://github.com/editorstack/editorstack). Pull requests opened here are not merged directly. If you'd like to propose a change, please file an issue describing it, or open a PR against editorstack if you have access.

## Usage

Each package is consumed as a git dependency. Add to your `pubspec.yaml`:

```yaml
dependencies:
  effectful_ui:
    git:
      url: https://github.com/editorstack/effectful
      path: effectful_ui
  effectful_utils:
    git:
      url: https://github.com/editorstack/effectful
      path: effectful_utils
  effectful_updater:
    git:
      url: https://github.com/editorstack/effectful
      path: effectful_updater
```

Pin to a specific commit by adding `ref: <sha>` under each entry.

## License

[MIT](./LICENSE)
