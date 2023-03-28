###########################################################################################################
#
# How to build:
#
# docker build -t ${BASE_REGISTRY}/arkcase/core:latest .
# docker push ${BASE_REGISTRY}/arkcase/core:latest
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
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="2021.03.25"
ARG CONFIG_SRC="https://project.armedia.com/nexus/repository/arkcase/com/armedia/arkcase/arkcase-config-core/${VER}/arkcase-config-core-${VER}.zip"
ARG BASE_REGISTRY
ARG BASE_REPO="arkcase/base"
ARG BASE_TAG="8.7.0"

FROM "${BASE_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG CONFIG_SRC
ARG APP_UID="1997"
ARG APP_GID="${APP_UID}"
ARG APP_USER="config"
ARG APP_GROUP="${APP_USER}"
ARG ACM_GID="10000"
ARG ACM_GROUP="acm"
ARG BASE_DIR="/app"
ARG HOME_DIR="${BASE_DIR}/home"
ARG CONF_DIR="${HOME_DIR}/conf"
ARG INIT_DIR="${HOME_DIR}/init"

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Configuration" \
      VERSION="${VER}"

#
# Environment variables
#
ENV APP_UID="${APP_UID}" \
    APP_GID="${APP_GID}" \
    APP_USER="${APP_USER}" \
    APP_GROUP="${APP_GROUP}" \
    JAVA_HOME="/usr/lib/jvm/java" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    BASE_DIR="${BASE_DIR}" \ 
    HOME_DIR="${HOME_DIR}" \
    CONF_DIR="${CONF_DIR}" \
    INIT_DIR="${INIT_DIR}"

WORKDIR "${BASE_DIR}"

#
# Create the requisite user and group
#
RUN groupadd --system --gid "${ACM_GID}" "${ACM_GROUP}" && \
    groupadd --system --gid "${APP_GID}" "${APP_GROUP}" && \
    useradd  --system --uid "${APP_UID}" --gid "${APP_GROUP}" --groups "${ACM_GROUP}" --create-home --home-dir "${HOME_DIR}" "${APP_USER}"

RUN rm -rf /tmp/* && \
    chown -R "${APP_USER}:${APP_GROUP}" "${BASE_DIR}" && \
    chmod -R "u=rwX,g=rX,o=" "${BASE_DIR}" 

##################################################### ARKCASE: BELOW ###############################################################

ARG VER

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
ADD --chown="${APP_USER}:${APP_GROUP}" "${CONFIG_SRC}" "${BASE_DIR}/.arkcase.zip"

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
    pip3 install openpyxl

##################################################### ARKCASE: ABOVE ###############################################################

COPY --chown="${APP_USER}:${APP_GROUP}" "entrypoint" "fixExcel" "/"

RUN chown -R "${APP_USER}:${APP_GROUP}" "${CONF_DIR}" && \
    chmod -R u=rwX,g=rX,o= "${CONF_DIR}"

USER "${APP_USER}"
WORKDIR "${CONF_DIR}"

# These may have to disappear in openshift
VOLUME [ "${CONF_DIR}" ]
VOLUME [ "${INIT_DIR}" ]

ENTRYPOINT [ "/entrypoint" ]
