FROM registry.gitlab.com/fdroid/fdroidserver:buildserver-bookworm
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_SDK=${ANDROID_HOME}
ENV ANDROID_NDK=/opt/android-ndk-r23c
ENV FDROIDSERVER=/home/vagrant/fdroidserver
ENV PATH="/opt/gradle/bin:${FDROIDSERVER}:${PATH}"
ENV PYTHONPATH="${FDROIDSERVER}:${FDROIDSERVER}/examples"
ENV PYTHONUNBUFFERED=true
RUN apt-get update
RUN apt-get dist-upgrade
RUN mkdir ${FDROIDSERVER}
RUN curl --silent https://gitlab.com/fdroid/fdroidserver/-/archive/master/fdroidserver-master.tar.gz | tar -xz --directory=${FDROIDSERVER} --strip-components=1
RUN sdkmanager "platform-tools" "build-tools;31.0.0"
RUN apt-get install --yes openjdk-17-jdk-headless build-essential ant cmake clang python-is-python3 wget swig zip vim
RUN update-alternatives --auto java
WORKDIR /
RUN curl "https://dl.google.com/android/repository/android-ndk-r23c-linux.zip" --output android-ndk-r23c-linux.zip
RUN unzip android-ndk-r23c-linux -d /opt/
COPY setup-volume.sh /usr/bin/setup-volume.sh
RUN chmod +x /usr/bin/setup-volume.sh
USER vagrant
