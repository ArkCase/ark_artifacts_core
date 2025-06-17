###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/artifacts:latest .
#
###########################################################################################################

#
# Basic Definitions
#
ARG EXT="core"
ARG VER="24.09.02"

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
ARG ARKCASE_MVN_REPO="https://nexus.armedia.com/repository/arkcase/"

#
# The artifacts descriptor
#
ARG ARTIFACTS_SRC="com.armedia.arkcase:arkcase-config-${EXT}:${VER}:yaml:artifacts"

#
# Now build the actual container
#
FROM "${BASE_IMG}"

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
# Maven auth details
#
ARG MVN_GET_ENCRYPTION_KEY
ARG MVN_GET_USERNAME
ARG MVN_GET_PASSWORD

#
# Import the repo
#
ARG ARKCASE_MVN_REPO

#
# Pull all the artifacts
#
ARG ARTIFACTS_SRC
ENV ARTIFACTS_TGT="${FILE_DIR}/artifacts.yaml"
RUN mvn-get "${ARTIFACTS_SRC}" "${ARKCASE_MVN_REPO}" "${ARTIFACTS_TGT}" && \
    download-artifacts "${ARTIFACTS_TGT}"
