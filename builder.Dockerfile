FROM norionomura/swiftlint:0.39.2_swift-5.2.3

MAINTAINER Orta Therox

LABEL "com.github.actions.name"="Danger Swift"
LABEL "com.github.actions.description"="Runs Swift Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

# Install nodejs
RUN apt-get update -q \
  && apt-get install -qy curl \
  && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
  && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
  && apt-get install -qy nodejs \
  && rm -r /var/lib/apt/lists/*

# Install SwiftFormat
RUN git clone https://github.com/nicklockwood/SwiftFormat.git && \
  cd SwiftFormat && \
  git checkout 0.44.9 && \
  swift build --configuration release --static-swift-stdlib && \
  mv `swift build --configuration release --static-swift-stdlib --show-bin-path`/swiftformat /usr/bin && \
  cd .. && \
  rm -rf SwiftFormat

# Install danger-swift globally
COPY . _danger-swift
RUN cd _danger-swift && make install

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["npx", "--package", "danger", "danger-swift", "ci"]
