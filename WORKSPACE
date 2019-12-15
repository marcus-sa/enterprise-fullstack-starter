workspace(
    # Must match the name in package.json
    name = "enterprise_fullstack_starter",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Fetch rules_nodejs so we can install our npm dependencies
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "a54b2511d6dae42c1f7cdaeb08144ee2808193a088004fc3b464a04583d5aa2e",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.42.3/rules_nodejs-0.42.3.tar.gz"],
)

# Setup the Node.js toolchain
load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    quiet = False,
    yarn_lock = "//:yarn.lock",
)

# Install any Bazel rules which were extracted earlier by the yarn_install rule.
load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")

install_bazel_dependencies()

http_archive(
    name = "bazel_skylib",
    sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel_skylib-0.9.0.tar.gz",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

####################################################
# Support for using proto buffers
####################################################
http_archive(
    name = "rules_proto",
    sha256 = "73ebe9d15ba42401c785f9d0aeebccd73bd80bf6b8ac78f74996d31f2c0ad7a6",
    strip_prefix = "rules_proto-2c0468366367d7ed97a1f702f9cd7155ab3f73c5",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/2c0468366367d7ed97a1f702f9cd7155ab3f73c5.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/2c0468366367d7ed97a1f702f9cd7155ab3f73c5.tar.gz",
    ],
)

load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()

rules_proto_toolchains()

####################################################
# Support for using TypeScript
####################################################
load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")

ts_setup_workspace()

http_archive(
    name = "rules_typescript_proto",
    # TODO: Update these values to the latest version
    sha256 = "ebbe2de31cbc2cef4e6d6533bd51c3a9b2b43b76f00cf1146e81b5a2f71089b0",
    strip_prefix = "rules_typescript_proto-0ae5d5aab03366269a511d2d74ffe2b86de3812d",
    urls = [
        "https://github.com/Dig-Doug/rules_typescript_proto/archive/0ae5d5aab03366269a511d2d74ffe2b86de3812d.tar.gz",
    ],
)

load("@rules_typescript_proto//:index.bzl", "rules_typescript_proto_dependencies")

rules_typescript_proto_dependencies()

################################
# Support for Remote Execution #
################################
git_repository(
    name = "bazel_toolchains",
    commit = "f2709de075dba8a439c4d55aa8219e2c0aed170c",
    remote = "https://github.com/bazelbuild/bazel-toolchains",
)

####################################################
# Support creating Docker images for our node apps #
####################################################
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "14ac30773fdb393ddec90e158c9ec7ebb3f8a4fd533ec2abbfd8789ad81a284b",
    strip_prefix = "rules_docker-0.12.1",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.12.1/rules_docker-v0.12.1.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load(
    "@io_bazel_rules_docker//nodejs:image.bzl",
    nodejs_image_repos = "repositories",
)

nodejs_image_repos()
