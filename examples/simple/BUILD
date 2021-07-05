load("//tools:nodejs_fat_binary.bzl", "nodejs_fat_binary")

nodejs_fat_binary(
    name = "bin",
    entry_point = ":index.js"
)

sh_test(
    name = "test",
    size = "small",
    srcs = [":bin"],
)
