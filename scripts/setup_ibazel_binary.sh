#!/bin/bash
set -eo pipefail

bazelBin=$(node -p "require('@bazel/ibazel').getNativeBinary()")

# Provide the bazel binary globally. We don't want to access the binary
# through Node as it could result in limited memory.
sudo chmod a+x ${bazelBin}
sudo ln -fs ${bazelBin} /usr/local/bin/ibazel
