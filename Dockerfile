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
ARG ARKCASE_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/acm/acm-standard-applications/arkcase/${VER}/arkcase-${VER}.war"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG CONFIG_SRC
ARG ARKCASE_SRC
ARG BASE_DIR="/app"
ARG FILE_DIR="${BASE_DIR}/file"
ARG INIT_DIR="${BASE_DIR}/init"
ARG CONF_DIR="${BASE_DIR}/conf"
ARG WAR_DIR="${BASE_DIR}/war"

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
    FILE_DIR="${FILE_DIR}" \
    INIT_DIR="${INIT_DIR}" \
    CONF_DIR="${CONF_DIR}" \
    VER="${VER}" \
    CONF_FILE="${FILE_DIR}/conf.zip" \
    WAR_FILE="${FILE_DIR}/war.zip"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

#################
# Build Arkcase
#################
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

ADD "${CONFIG_SRC}" "${CONF_FILE}"
ADD "${ARKCASE_SRC}" "${WAR_FILE}"

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
    sha256sum "${CONF_FILE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${CONF_FILE}.sum" \
    && \
    sha256sum "${WAR_FILE}" | \
        sed -e 's;\s.*$;;g' | \
        tr -d '\n' \
        > "${WAR_FILE}.sum"

COPY "entrypoint" "/"
COPY "fixExcel" "realm-fix" "/usr/local/bin/"
RUN chmod -Rv a+rX "/entrypoint" "/usr/local/bin"

WORKDIR "${APP_DIR}"

ENTRYPOINT [ "/entrypoint" ]
