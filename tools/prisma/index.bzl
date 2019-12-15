load(":generator.bzl", _prisma_generator = "prisma_generator")
load(":datamodel.bzl", _prisma_datamodel = "prisma_datamodel")
load(":datasource.bzl", _prisma_datasource = "prisma_datasource")
load(":photon.bzl", _photon_generate_macro = "photon_generate_macro")

prisma_generator = _prisma_generator
prisma_datamodel = _prisma_datamodel
prisma_datasource = _prisma_datasource
photon_generate = _photon_generate_macro