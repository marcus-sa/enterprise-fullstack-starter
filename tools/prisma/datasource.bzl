load(":providers.bzl", "PrismaDataSource")

def _prisma_datasource_impl(ctx):
    url = '"%s"' % ctx.attr.url

    datasource = """
datasource %s {
  provider = "%s"
  url = %s
    """ % (
        ctx.attr.provider,
        ctx.attr.provider,
        "env(%s)" % url if ctx.attr.url_env else url,
    )

    datasource = datasource.strip()

    if ctx.attr.enabled:
        datasource += """
  enabled = true
        """
        datasource = datasource.strip()

    datasource += """
}
    """

    return [PrismaDataSource(datasource = datasource.strip())]

prisma_datasource = rule(
    implementation = _prisma_datasource_impl,
    attrs = {
        "provider": attr.string(
            values = [
                "postgresql",
                "mysql",
                "sqlite",
            ],
            mandatory = True,
        ),
        "url": attr.string(
            mandatory = True,
        ),
        "url_env": attr.bool(
            # Is url an environment variable ?
            default = True,
        ),
        "enabled": attr.bool(
            doc = "Can be a boolean or an environment variable",
            default = True,
        ),
        #        "enabled_env": attr.bool(
        #            # Is enabled an environment variable ?
        #            default = True,
        #        ),
    },
)
