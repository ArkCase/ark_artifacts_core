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
ARG BASE_VER="1.3.0"
ARG BASE_BLD="01"
ARG BASE_TAG="${BASE_VER}-${BASE_BLD}"

ARG EXT="core"
ARG VER="2021.03.34"
ARG BLD="02"

#
# The main WAR and CONF artifacts
#
ARG CONF_VER="${VER}"
ARG CONF_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-${EXT}/${CONF_VER}/arkcase-config-${EXT}-${CONF_VER}.zip"
ARG ARKCASE_VER="${VER}"
ARG ARKCASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/acm/acm-standard-applications/arkcase/${ARKCASE_VER}/arkcase-${ARKCASE_VER}.war"

#
# The PDFNet library and binaries
#
ARG PDFTRON_VER="9.3.0"
ARG PDFTRON_SRC="https://project.armedia.com/nexus/repository/arkcase.release/com/armedia/arkcase/arkcase-pdftron-bin/${PDFTRON_VER}/arkcase-pdftron-bin-${PDFTRON_VER}.zip"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

ARG VER
ARG BLD

#
# Basic Parameters
#

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer" \
      VERSION="${VER}-${BLD}"

#
# The ArkCase WAR file
#
ARG ARKCASE_VER
ARG ARKCASE_SRC
ENV ARKCASE_TGT="${WARS_DIR}/arkcase.war"
RUN pull-artifact "${ARKCASE_SRC}" "${ARKCASE_TGT}" "${ARKCASE_VER}"

#
# The contents of .arkcase
#
ARG CONF_VER
ARG CONF_SRC
ENV CONF_TGT="${CONF_DIR}/00-base.zip"
RUN pull-artifact "${CONF_SRC}" "${CONF_TGT}" "${CONF_VER}"

#
# PDFTron stuff for .arkcase
#
ARG PDFTRON_VER
ARG PDFTRON_SRC
ENV PDFTRON_TGT="${CONF_DIR}/00-pdftron.zip"
RUN pull-artifact "${PDFTRON_SRC}" "${PDFTRON_TGT}" "${PDFTRON_VER}"
