FROM openjdk:11-jdk-bullseye
MAINTAINER Claudemir Todo Bom <claudemir@todobom.com>

# environment
ENV ANDROID_COMPILE_SDK 31
ENV ANDROID_BUILD_TOOLS 31.0.0
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
ENV ANDROID_HOME ${PWD}/android-sdk-linux
ENV ANDROID_SDKMANAGER ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager

# install everything
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends curl wget tar unzip lib32stdc++6 lib32z1 build-essential ruby-dev xmlstarlet \
 && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y nodejs \
 && apt-get clean \
 && wget --quiet --output-document=android-tools.zip ${ANDROID_SDK_URL} \
 && mkdir -p android-sdk-linux \
 && unzip ./android-tools.zip -d android-sdk-linux \
 && echo y | ${ANDROID_SDKMANAGER} --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}" "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null \
 && ( yes | ${ANDROID_SDKMANAGER} --sdk_root=${ANDROID_HOME} --licenses || /bin/true ) \
 && npm -g install yarn \
 && npm -g install @ionic/cli @angular/cli cordova-res \
 && gem install rake \
 && gem install fastlane -NV
