load("//tools:executable_archive.bzl", "executable_archive")

executable_archive(
    name = "archive",
    entry_point = ":index.js",
    data = glob(["*.js"])
)
