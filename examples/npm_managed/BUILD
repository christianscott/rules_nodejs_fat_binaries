load("//tools:nodejs_fat_binary.bzl", "nodejs_fat_binary")

nodejs_fat_binary(
    name = "bin",
    entry_point = ":index.js",
    data = [
        ":package.json",
        ":yarn.lock",
        "@examples_npm_managed//camelcase"
    ]
)

sh_test(
    name = "test",
    size = "small",
    srcs = [":bin"],
)
