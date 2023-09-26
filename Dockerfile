###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/artifacts:latest .
#
###########################################################################################################

#
# Basic Parameters
#
ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG BASE_REPO="arkcase/artifacts"
ARG BASE_VER="1.4.0"
ARG BASE_BLD="01"
ARG BASE_TAG="${BASE_VER}-${BASE_BLD}"

ARG EXT="core"
ARG VER="2023.01.05"
ARG BLD="01"

#
# The repo from which to pull everything
#
ARG ARKCASE_MVN_REPO="https://project.armedia.com/nexus/repository/arkcase/"

#
# ArkCase WAR and CONF files
#
ARG ARKCASE_VER="${VER}"
ARG ARKCASE_SRC="com.armedia.acm.acm-standard-applications:arkcase:${ARKCASE_VER}:war"

ARG CONF_VER="${VER}"
ARG CONF_SRC="com.armedia.arkcase:arkcase-config-${EXT}:${CONF_VER}:zip"

#
# The PDFNet library and binaries
#
ARG PDFTRON_VER="9.3.0"
ARG PDFTRON_SRC="com.armedia.arkcase:arkcase-pdftron-bin:${PDFTRON_VER}:jar"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

ARG VER
ARG BLD
ENV VER="${VER}"
ENV BLD="${BLD}"

#
# Basic Parameters
#

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer" \
      VERSION="${VER}-${BLD}"

ENV ARKCASE_DIR="${FILE_DIR}/arkcase"
ENV ARKCASE_CONF_DIR="${ARKCASE_DIR}/conf"
ENV ARKCASE_WARS_DIR="${ARKCASE_DIR}/wars"

ENV PENTAHO_DIR="${FILE_DIR}/pentaho"

#
# Import the repo
#
ARG ARKCASE_MVN_REPO

#
# Pull all the artifacts
#
ARG ARKCASE_SRC
ARG CONF_SRC
ARG PDFTRON_SRC

ENV ARKCASE_TGT="${ARKCASE_WARS_DIR}/arkcase.war"
ENV CONF_TGT="${ARKCASE_CONF_DIR}/00-conf.zip"
ENV PDFTRON_TGT="${ARKCASE_CONF_DIR}/00-pdftron.zip"

RUN mvn-get \
        "${ARKCASE_SRC}@${ARKCASE_MVN_REPO}=${ARKCASE_TGT}" \
        "${CONF_SRC}@${ARKCASE_MVN_REPO}=${CONF_TGT}" \
        "${PDFTRON_SRC}@${ARKCASE_MVN_REPO}=${PDFTRON_TGT}"
