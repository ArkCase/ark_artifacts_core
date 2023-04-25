###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/deploy:latest .
#
###########################################################################################################

#
# Basic Parameters
#
ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG BASE_REPO="arkcase/deploy-base"
ARG BASE_TAG="latest"

ARG VER="2021.03.26"
ARG CONFIG_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-core/${VER}/arkcase-config-core-${VER}.zip"
ARG ARKCASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/acm/acm-standard-applications/arkcase/${VER}/arkcase-${VER}.war"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG CONFIG_SRC
ARG ARKCASE_SRC

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer" \
      VERSION="${VER}"

#
# Download and checksum the configuration file
#
ADD "${CONFIG_SRC}" "${CONF_FILE}"
RUN sha256sum "${CONF_FILE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${CONF_FILE}.sum"

#
# Download and checksum the WAR file
#
ADD "${ARKCASE_SRC}" "${WAR_FILE}"
RUN sha256sum "${WAR_FILE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${WAR_FILE}.sum"
