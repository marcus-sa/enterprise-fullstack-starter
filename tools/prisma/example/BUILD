load("//tools/prisma:index.bzl", "photon_generate", "prisma_datamodel", "prisma_datasource", "prisma_generator")
load("@npm_bazel_typescript//:index.bzl", "ts_library")
load("//tools:js_sources.bzl", "js_sources")

prisma_datasource(
    name = "postgres_datasource",
    provider = "postgresql",
    url = "PRISMA_POSTGRES_URL",
    visibility = ["//visibility:private"],
)

prisma_generator(
    name = "photonjs_generator",
    output = "client",
    provider = "photonjs",
    visibility = ["//visibility:private"],
)

prisma_datamodel(
    name = "models",
    srcs = [
        "post.prisma",
        "user.prisma",
    ],
)

photon_generate(
    name = "photonjs",
    datamodels = [":models"],
    datasources = [":postgres_datasource"],
    generator = ":photonjs_generator",
)

js_sources(
    name = "client",
    srcs = glob([
        "client/**/*.js",
        "client/**/*.d.ts",
    ]),
)

ts_library(
    name = "example",
    srcs = ["index.ts"],
    tsconfig = "//:tsconfig.node.json",
    deps = [":client"],
)
