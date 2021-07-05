workspace(
    name = "nodejs_fat_binary",
    managed_directories = {"@examples_npm_managed": ["examples/npm_managed/node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "10f534e1c80f795cffe1f2822becd4897754d18564612510c59b3c73544ae7c6",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/3.5.0/rules_nodejs-3.5.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")

yarn_install(
    name = "examples_npm_managed",
    package_json = "//examples/npm_managed:package.json",
    yarn_lock = "//examples/npm_managed:yarn.lock"
)
