load(":providers.bzl", "PrismaGenerator")

def _prisma_generator_impl(ctx):
    provider = ctx.attr.provider

    data = """
generator %s {
  provider = "%s"
  output = "%s"
    """ % (
        provider,
        provider,
        ctx.attr.output,
    )

    data = data.strip()

    if len(ctx.attr.binary_targets) > 0:
        data += """
  binaryTargets = ["{TMPL_binary_targets}"]
        """.format(
            TMPL_binary_targets = '", "'.join([
                bt
                for bt in ctx.attr.binary_targets
            ]),
        )
        data = data.strip()

    data += """
}
    """

    return [PrismaGenerator(
        data = data.strip(),
        output = ctx.attr.output,
    )]

prisma_generator = rule(
    implementation = _prisma_generator_impl,
    attrs = {
        "provider": attr.string(
            values = ["photonjs"],
            default = "photonjs",
        ),
        "output": attr.string(
            # output
            mandatory = True,
        ),
        "binary_targets": attr.string_list(
            # allow_empty = False,
            # mandatory = False,
        ),
    },
)
