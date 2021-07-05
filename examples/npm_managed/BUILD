load("//tools:nodejs_fat_binary.bzl", "nodejs_fat_binary")

nodejs_fat_binary(
    name = "archive",
    entry_point = ":index.js",
    data = [
        ":package.json",
        ":yarn.lock",
        "@examples_npm_managed//camelcase"
    ]
)
