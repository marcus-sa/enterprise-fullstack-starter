load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")
load("@build_bazel_rules_nodejs//:providers.bzl", "js_named_module_info", "js_ecma_script_module_info")
load("//tools/prisma:providers.bzl", "DATA_SOURCES_ATTR", "DATA_MODELS_ATTR", "PrismaDataModel", "PrismaDataSource", "PrismaGenerator", "PRISMA_BIN_ATTR")

def _collect_datasources(ctx):
    return [
        ds[PrismaDataSource].datasource
        for ds in ctx.attr.datasources
    ]

def _collect_generator(ctx):
    return ctx.attr.generator[PrismaGenerator].data

def _declare_output(ctx):
    output = ctx.attr.generator[PrismaGenerator].output
    return ctx.actions.declare_directory(output)

def _collect_datamodels(ctx):
    datamodels = []

    for _datamodels in ctx.attr.datamodels:
        datamodels += _datamodels[PrismaDataModel].datamodels

    return datamodels

def _photon_generate_impl(ctx):
    output = _declare_output(ctx)
    # datasources = _collect_datasources(ctx)
    datamodels = _collect_datamodels(ctx)
    generator = _collect_generator(ctx)

    schema = ctx.actions.declare_file(ctx.label.name + ".prisma")

    # echo '{TMPL_datasources}' >> {TMPL_schema}
    ctx.actions.run_shell(
        outputs = [schema],
        use_default_shell_env = True,
        inputs = datamodels,
        command = """
set -eu

echo '{TMPL_generator}' >> {TMPL_schema}

for file in {TMPL_models}; do
  cat "$file" >> {TMPL_schema}
done
        """.format(
            TMPL_schema = schema.path,
            TMPL_generator = generator,
            # TMPL_datasources = " ".join(datasources),
            TMPL_models = " ".join([model.path for model in datamodels]),
        )
    )

    args = ctx.actions.args()
    args.add("generate")
    args.add_all(["--schema", schema])

    ctx.actions.run(
        outputs = [output],
        inputs = [schema],
        executable = ctx.executable.bin,
        use_default_shell_env = True,
        arguments = [args],
    )

    return [DefaultInfo(files = depset([output, schema]))]

photon_generate = rule(
    implementation = _photon_generate_impl,
    attrs = {
        "datamodels": DATA_MODELS_ATTR,
        # "datasources": DATA_SOURCES_ATTR,
        "bin": PRISMA_BIN_ATTR,
        "generator": attr.label(
            doc = "prisma_generator target to include",
            mandatory = True,
            providers = [PrismaGenerator],
            allow_files = False,
        ),
    },
)

def photon_generate_macro(name, datamodels, datasources, generator, **kwargs):
    nodejs_binary(
        name = "%s_bin" % name,
        data = ["@npm//prisma2", "@npm//@prisma/photon"],
        entry_point = "@npm//:node_modules/prisma2/build/index.js",
        visibility = ["//visibility:private"],
        **kwargs
    )

    photon_generate(
        name = name,
        bin = ":%s_bin" % name,
        datamodels = datamodels,
        # datasources = datasources,
        generator = generator,
        **kwargs,
    )