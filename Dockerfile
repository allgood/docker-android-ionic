FROM openjdk:8-jdk-bullseye
MAINTAINER Claudemir Todo Bom <claudemir@todobom.com>

# update package lists
RUN apt-get update && apt-get upgrade -y

# install dependencies
RUN apt-get install -y --no-install-recommends curl wget tar unzip lib32stdc++6 lib32z1 build-essential ruby-dev xmlstarlet

# install Android SDK
ENV ANDROID_COMPILE_SDK 29
ENV ANDROID_BUILD_TOOLS 29.0.3
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
ENV ANDROID_HOME ${PWD}/android-sdk-linux
ENV ANDROID_SDKMANAGER ${ANDROID_HOME}/cmdline-tools/tools/bin/sdkmanager

RUN wget --quiet --output-document=android-tools.zip ${ANDROID_SDK_URL}
RUN mkdir -p android-sdk-linux/cmdline-tools
RUN unzip ./android-tools.zip -d android-sdk-linux/cmdline-tools
RUN echo y | ${ANDROID_SDKMANAGER} "platforms;android-${ANDROID_COMPILE_SDK}" "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
RUN yes | ${ANDROID_SDKMANAGER} --licenses || /bin/true

# add nodejs repo
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -

# install nodejs
RUN apt-get install -y nodejs

# install yarn
RUN npm -g install yarn

# clean cache
RUN apt-get clean

# install ionic tools
RUN npm -g install @ionic/cli @angular/cli cordova-res

# install fastlane
RUN gem install rake
RUN gem install fastlane -NV
