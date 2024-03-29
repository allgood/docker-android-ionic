FROM openjdk:17-jdk-slim-bullseye
MAINTAINER Claudemir Todo Bom <claudemir@todobom.com>

# environment
ENV ANDROID_COMPILE_SDK 34
ENV ANDROID_BUILD_TOOLS 34.0.0
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
ENV ANDROID_HOME ${PWD}/android-sdk-linux
ENV ANDROID_SDKMANAGER ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager
ENV NODE_VERSION lts

# install everything
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends curl wget tar unzip cpio gzip openssh-client build-essential ruby-dev xmlstarlet \
 && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
 && apt-get install -y nodejs \
 && npm -g update --no-audit --no-fund npm \
 && apt-get clean \
 && wget --quiet --output-document=android-tools.zip ${ANDROID_SDK_URL} \
 && mkdir -p android-sdk-linux \
 && unzip ./android-tools.zip -d android-sdk-linux \
 && echo y | ${ANDROID_SDKMANAGER} --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}" "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null \
 && ( yes | ${ANDROID_SDKMANAGER} --sdk_root=${ANDROID_HOME} --licenses || /bin/true ) \
 && npm -g install --no-audit --no-fund yarn @ionic/cli @angular/cli cordova-res \
 && gem install rake \
 && gem install fastlane -NV
