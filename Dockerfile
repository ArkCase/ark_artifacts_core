###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/artifacts-core:latest .
#
###########################################################################################################

#
# Basic Definitions
#
ARG EXT="core"
ARG VER="25.09.01"

#
# Basic Parameters
#
ARG PUBLIC_REGISTRY="public.ecr.aws"

ARG BASE_REGISTRY="${PUBLIC_REGISTRY}"
ARG BASE_REPO="arkcase/artifacts"
ARG BASE_VER="1.6.5"
ARG BASE_VER_PFX=""
ARG BASE_IMG="${BASE_REGISTRY}/${BASE_REPO}:${BASE_VER_PFX}${BASE_VER}"

#
# The repo from which to pull everything
#
ARG ARTIFACTS_MVN_REPO="https://nexus.armedia.com/repository/arkcase/"

#
# The artifacts descriptor
#
ARG ARTIFACTS_SRC="com.armedia.arkcase:arkcase-config-${EXT}:${VER}:yaml:artifacts"

#
# Now build the actual container
#
FROM "${BASE_IMG}"

ARG ARTIFACTS_MVN_REPO
ARG ARTIFACTS_SRC

ARG EXT
ENV EXT="${EXT}"
ARG VER
ENV VER="${VER}"

#
# Basic Parameters
#
LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer / Core" \
      VERSION="${VER}"

#
# Pull all the artifacts
#
RUN --mount=type=secret,id=mvn_get_auth \
    source /run/secrets/mvn_get_auth && \
    mvn-get "${ARTIFACTS_SRC}" "${ARTIFACTS_MVN_REPO}" "${ARTIFACTS_MANIFEST}" && \
    download-artifacts "${ARTIFACTS_MANIFEST}"
