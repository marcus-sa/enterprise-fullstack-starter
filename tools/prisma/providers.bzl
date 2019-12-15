PrismaDataSource = provider(
    doc = "Collects files from prisma_datasource for use in downstream prisma_generate and prisma_lift",
    fields = {
        "datasource": "",
    },
)

PrismaGenerator = provider(
    doc = "Collects files from prisma_generator for use in downstream prisma_generate and prisma_lift",
    fields = {
        "data": "",
        "output": "",
    },
)

PrismaDataModel = provider(
    doc = "Collects files from prisma_datamodel for use in downstream prisma_generate and prisma_lift",
    fields = {
        "datamodels": "",
    },
)

DATA_SOURCES_ATTR = attr.label_list(
    doc = "prisma_datasource targets to include",
    mandatory = True,
    allow_empty = False,
    providers = [PrismaDataSource],
    allow_files = False,
)

DATA_MODELS_ATTR = attr.label_list(
    doc = "prisma_datamodel targets to include",
    mandatory = True,
    allow_empty = False,
    providers = [PrismaDataModel],
    allow_files = False,
)

PRISMA_BIN_ATTR = attr.label(
    executable = True,
    default = Label("@npm//prisma2/bin:prisma2"),
    cfg = "host",
)
