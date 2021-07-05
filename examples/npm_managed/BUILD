load("//tools:executable_archive.bzl", "executable_archive")

executable_archive(
    name = "archive",
    entry_point = ":index.js",
    data = [
        ":package.json",
        ":yarn.lock",
        "@examples_npm_managed//camelcase"
    ]
)
