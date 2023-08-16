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
ARG BASE_VER="1.0.1"
ARG BASE_BLD="01"
ARG BASE_TAG="${BASE_VER}-${BASE_BLD}"

ARG EXT="core"
ARG VER="2023.01.03"
ARG BLD="01"

#
# The main WAR and CONF artifacts
#
ARG CONF_VER="${VER}"
ARG CONF_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-${EXT}/${CONF_VER}/arkcase-config-${EXT}-${CONF_VER}.zip"
ARG ARKCASE_VER="${VER}"
ARG ARKCASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/acm/acm-standard-applications/arkcase/${ARKCASE_VER}/arkcase-${ARKCASE_VER}.war"
ARG NEO4J_VER="${VER}"
ARG NEO4J_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/neo4j-demo/${NEO4J_VER}/neo4j-demo-${NEO4J_VER}.zip"

#
# The PDFNet library and binaries
#
ARG PDFTRON_VER="9.3.0"
ARG PDFTRON_SRC="https://project.armedia.com/nexus/repository/arkcase.release/com/armedia/arkcase/arkcase-pdftron-bin/${PDFTRON_VER}/arkcase-pdftron-bin-${PDFTRON_VER}.zip"

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
# The ArkCase WAR file
#
ARG ARKCASE_VER
ARG ARKCASE_SRC
ENV ARKCASE_TGT="${ARKCASE_WARS_DIR}/arkcase.war"
RUN prep-artifact "${ARKCASE_SRC}" "${ARKCASE_TGT}" "${ARKCASE_VER}"

#
# The contents of .arkcase
#
ARG CONF_VER
ARG CONF_SRC
ENV CONF_TGT="${ARKCASE_CONF_DIR}/00-conf.zip"
RUN prep-artifact "${CONF_SRC}" "${CONF_TGT}" "${CONF_VER}"

#
# PDFTron stuff for .arkcase
#
ARG PDFTRON_VER
ARG PDFTRON_SRC
ENV PDFTRON_TGT="${ARKCASE_CONF_DIR}/00-pdftron.zip"
RUN prep-artifact "${PDFTRON_SRC}" "${PDFTRON_TGT}" "${PDFTRON_VER}"

#
# The Neo4J Demo Stuff
#
ARG NEO4J_VER
ARG NEO4J_SRC
ENV NEO4J_TGT="${PENTAHO_DIR}/analytical/neo4j-demo.zip"
RUN prep-artifact "${NEO4J_SRC}" "${NEO4J_TGT}" "${NEO4J_VER}"
