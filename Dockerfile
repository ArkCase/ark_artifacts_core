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
ARG BASE_VER="1.6.4"
ARG BASE_VER_PFX=""
ARG BASE_IMG="${BASE_REGISTRY}/${BASE_REPO}:${BASE_VER_PFX}${BASE_VER}"

#
# The repo from which to pull everything
#
ARG ARKCASE_MVN_REPO="https://nexus.armedia.com/repository/arkcase/"

#
# ArkCase WAR and CONF files
#
ARG ARKCASE_SRC="com.armedia.acm.acm-standard-applications:arkcase:${VER}:war"
ARG ARKCASE_ROOT_SRC="com.armedia.acm.acm-standard-applications:arkcase-tomcat-redirect:${VER}:war"
ARG CONF_SRC="com.armedia.arkcase:arkcase-config-${EXT}:${VER}:zip"

#
# The PDFNet library and binaries
#
ARG PDFTRON_VER="9.3.0"
ARG PDFTRON_SRC="com.armedia.arkcase:arkcase-pdftron-bin:${PDFTRON_VER}:jar"

#
# The Reports binaries
#
ARG REPORTS_SRC="com.armedia.arkcase:arkcase-config-${EXT}:${VER}:zip:reports"

#
# Now build the actual container
#
FROM "${BASE_IMG}"

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
# The artifacts are pulled in this specific order to facilitate
# developers' lives when building the containers locally for testing,
# such that they can leverage layer caching as much as possible
#

# First, the ArkCase redirector, since it should NEVER change
ARG ARKCASE_ROOT_SRC
ENV ARKCASE_ROOT_TGT="${ARKCASE_WARS_DIR}/ROOT.war"
RUN mvn-get "${ARKCASE_ROOT_SRC}" "${ARKCASE_MVN_REPO}" "${ARKCASE_ROOT_TGT}"

# Next, PDFTron, since this is the artifact least likely to change
ARG PDFTRON_SRC
ENV PDFTRON_TGT="${ARKCASE_CONF_DIR}/00-pdftron.zip"
RUN mvn-get "${PDFTRON_SRC}" "${ARKCASE_MVN_REPO}" "${PDFTRON_TGT}"

# Then, the ArkCase config, since that's the 2nd least likely to change
ARG CONF_SRC
ENV CONF_TGT="${ARKCASE_CONF_DIR}/00-conf.zip"
RUN mvn-get "${CONF_SRC}"    "${ARKCASE_MVN_REPO}" "${CONF_TGT}"

# All types of Reports
ARG REPORTS_SRC
RUN mvn-get "${REPORTS_SRC}" "${ARKCASE_MVN_REPO}" "${PENTAHO_REPORTS_DIR}"

# Finally, ArkCase, since it's the likeliest to change
ARG ARKCASE_SRC
ENV ARKCASE_TGT="${ARKCASE_WARS_DIR}/arkcase.war"
RUN mvn-get "${ARKCASE_SRC}" "${ARKCASE_MVN_REPO}" "${ARKCASE_TGT}"
