#!/bin/bash

# Fail on any error.
set -e
# Display commands to stderr.
set -x

# workaround for gcloud update failures (remove in future) [https://issuetracker.google.com/issues/119096137]
sudo /opt/google-cloud-sdk/bin/gcloud components remove container-builder-local

sudo /opt/google-cloud-sdk/bin/gcloud components update
sudo /opt/google-cloud-sdk/bin/gcloud components install app-engine-java

cd github/appengine-plugins-core
./mvnw -Prelease -B -U verify

# copy pom with the name expected in the Maven repository
ARTIFACT_ID=$(mvn -B help:evaluate -Dexpression=project.artifactId 2>/dev/null | grep -v "^\[")
PROJECT_VERSION=$(mvn -B help:evaluate -Dexpression=project.version 2>/dev/null| grep -v "^\[")
cp pom.xml target/${ARTIFACT_ID}-${PROJECT_VERSION}.pom

