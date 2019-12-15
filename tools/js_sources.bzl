load("@build_bazel_rules_nodejs//:providers.bzl", "DeclarationInfo", "js_ecma_script_module_info", "js_named_module_info")

def ts_providers_dict_to_struct(d):
    for key, value in d.items():
        if key != "output_groups" and type(value) == type({}):
            d[key] = struct(**value)
    return struct(**d)

def _filter_js_inputs(all_inputs):
    return [
        f
        for f in all_inputs
        if f.extension in ["js", "mjs", "json"]
    ]

def _filter_ts_inputs(all_inputs):
    return [
        f
        for f in all_inputs
        if f.extension in ["ts"]
    ]

def _js_library_impl(ctx):
    js_sources = _filter_js_inputs(ctx.files.srcs)
    decl_info = _filter_ts_inputs(ctx.files.srcs)

    return ts_providers_dict_to_struct({
        "providers": [
            DefaultInfo(
                runfiles = ctx.runfiles(
                    collect_default = True,
                    collect_data = True,
                ),
                files = depset(ctx.files.srcs),
            ),
            OutputGroupInfo(
                es5_sources = js_sources,
                es6_sources = js_sources,
            ),
            DeclarationInfo(
                declarations = depset(decl_info),
            ),
            js_named_module_info(
                sources = depset(js_sources),
            ),
            js_ecma_script_module_info(
                sources = depset(js_sources),
            ),
        ],
        "typescript": {
            "declarations": depset(decl_info),
            "devmode_manifest": None,
            "es5_sources": js_sources,
            "es6_sources": js_sources,
            "transitive_declarations": depset(),
            "type_blacklisted_declarations": depset(),
            "transitive_es6_sources": depset(),
        },
    })

"""
This is used as a work-around to include .js sources in ts_library
"""
js_sources = rule(
    implementation = _js_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [
                ".jsx",
                ".js",
                ".d.ts",
            ],
        ),
    },
)
