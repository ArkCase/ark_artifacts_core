###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/core:latest .
#
# How to run: (Helm)
#
# helm repo add arkcase https://arkcase.github.io/ark_helm_charts/
# helm install core arkcase/core
# helm uninstall core
#
###########################################################################################################

#
# Basic Parameters
#
ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG BASE_REPO="arkcase/base"
ARG BASE_TAG="8.7.0"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="2021.03.26"
ARG CONFIG_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-core/${VER}/arkcase-config-core-${VER}.zip"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG CONFIG_SRC
ARG BASE_DIR="/app"
ARG HOME_DIR="${BASE_DIR}/home"
ARG CONF_DIR="${BASE_DIR}/conf"
ARG INIT_DIR="${BASE_DIR}/init"

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Configuration" \
      VERSION="${VER}"

#
# Environment variables
#
ENV JAVA_HOME="/usr/lib/jvm/java" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    BASE_DIR="${BASE_DIR}" \ 
    HOME_DIR="${HOME_DIR}" \
    CONF_DIR="${CONF_DIR}" \
    INIT_DIR="${INIT_DIR}" \
    VER="${VER}" \
    ARCHIVE="${BASE_DIR}/.arkcase.zip"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

#################
# Build Arkcase
#################
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

#
# TODO: This is done much more cleanly with Maven and its dependency retrieval mechanisms
#
ADD "${CONFIG_SRC}" "${ARCHIVE}"

#  \
RUN yum -y update && \
    yum -y install \
        epel-release && \
    yum -y install \
        java-11-openjdk-devel \
        openssl \
        python3-pip \
        unzip \
        wget \
        zip \
    && \
    yum -y clean all && \
    pip3 install openpyxl && \
    rm -rf /tmp/* && \
    sha256sum "${ARCHIVE}" | \
        sed -e 's;\s.*$;;g' \
        > "${ARCHIVE}.sum"

##################################################### ARKCASE: ABOVE ###############################################################

COPY "entrypoint" "fixExcel" "/"

RUN mkdir -p "${CONF_DIR}" "${INIT_DIR}"

WORKDIR "${CONF_DIR}"

# These may have to disappear in openshift
VOLUME [ "${CONF_DIR}" ]
VOLUME [ "${INIT_DIR}" ]

ENTRYPOINT [ "/entrypoint" ]
