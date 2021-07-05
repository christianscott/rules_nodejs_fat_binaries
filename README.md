# POC: Bazel rules to build fat Node JS binaries via zip files

## Examples

Simple

```sh
$ bazel run examples/simple:archive
INFO: Analyzed target //examples/simple:archive (5 packages loaded, 8 targets configured).
INFO: Found 1 target...
Target //examples/simple:archive up-to-date:
  bazel-bin/examples/simple/archive
INFO: Elapsed time: 0.301s, Critical Path: 0.11s
INFO: 6 processes: 4 internal, 2 darwin-sandbox.
INFO: Build completed successfully, 6 total actions
INFO: Build completed successfully, 6 total actions
hello from NodeJS v12.22.0!
```

Require

```sh
$ bazel run examples/require:archive
INFO: Analyzed target //examples/require:archive (1 packages loaded, 3 targets configured).
INFO: Found 1 target...
Target //examples/require:archive up-to-date:
  bazel-bin/examples/require/archive
INFO: Elapsed time: 0.265s, Critical Path: 0.14s
INFO: 6 processes: 4 internal, 2 darwin-sandbox.
INFO: Build completed successfully, 6 total actions
INFO: Build completed successfully, 6 total actions
hello from the foo.js module
```
