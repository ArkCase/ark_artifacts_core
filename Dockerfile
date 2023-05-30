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
ARG BASE_TAG="1.1.0"

ARG VER="2021.03.30"

#
# The main WAR and CONF artifacts
#
ARG CONF_BASE_VER="${VER}"
ARG CONF_BASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-core/${CONF_BASE_VER}/arkcase-config-core-${CONF_BASE_VER}.zip"
ARG WAR_BASE_VER="${VER}"
ARG WAR_BASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/acm/acm-standard-applications/arkcase/${WAR_BASE_VER}/arkcase-${WAR_BASE_VER}.war"

#
# The PDFNet library and binaries
#
ARG CONF_PDFTRON_BIN_VER="9.3.0"
ARG CONF_PDFTRON_BIN_SRC="https://project.armedia.com/nexus/repository/arkcase.release/com/armedia/arkcase/arkcase-pdftron-bin/${CONF_PDFTRON_BIN_VER}/arkcase-pdftron-bin-${CONF_PDFTRON_BIN_VER}.zip"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG VER
ARG CONF_BASE_VER
ARG CONF_BASE_SRC
ARG CONF_PDFTRON_BIN_VER
ARG CONF_PDFTRON_BIN_SRC
ARG WAR_BASE_VER
ARG WAR_BASE_SRC

ARG CONF_BASE="${FILE_DIR}/conf/00-base.zip"
ARG CONF_PDFTRON_BIN="${FILE_DIR}/conf/01-pdftron.zip"
ARG WAR_BASE="${FILE_DIR}/war/00-war.zip"

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer" \
      VERSION="${VER}"

#
# Download and checksum the configuration file
#
ADD "${CONF_BASE_SRC}" "${CONF_BASE}"
RUN sha256sum "${CONF_BASE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${CONF_BASE}.sum" && \
    echo -n "${CONF_BASE_VER}" > "${CONF_BASE}.ver"

#
# Download and checksum the configuration file
#
ADD "${CONF_PDFTRON_BIN_SRC}" "${CONF_PDFTRON_BIN}"
RUN sha256sum "${CONF_PDFTRON_BIN}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${CONF_PDFTRON_BIN}.sum" && \
    echo -n "${CONF_PDFTRON_BIN_VER}" > "${CONF_PDFTRON_BIN}.ver"

#
# Download and checksum the WAR file
#
ADD "${WAR_BASE_SRC}" "${WAR_BASE}"
RUN sha256sum "${WAR_BASE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${WAR_BASE}.sum" && \
    echo -n "${WAR_BASE_VER}" > "${WAR_BASE}.ver"
