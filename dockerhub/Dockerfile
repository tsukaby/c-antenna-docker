FROM dockerfile/java:oracle-java8

MAINTAINER tsukaby

RUN apt-get update

# Redis
RUN apt-get -y install redis-server
RUN apt-get -y install build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev

# PhantomJS
ENV PHANTOM_VERSION 1.9.8
WORKDIR /tmp
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2
RUN bzip2 -dc phantomjs-$PHANTOM_VERSION-linux-x86_64.tar.bz2 | tar xvf -
RUN mv phantomjs-$PHANTOM_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/

# Japanese
RUN apt-get -y install language-pack-ja
RUN update-locale LANG=ja_JP.UTF-8

# Copy application
ENV APP_SHA1 25c37070645262f5b6c459be58e9d2ff9dfecbb7

WORKDIR /tmp
RUN wget https://s3-ap-northeast-1.amazonaws.com/c-antenna/binary/c-antenna-${APP_SHA1}.tar.gz -O c-antenna.tar.gz
RUN wget https://s3-ap-northeast-1.amazonaws.com/c-antenna/binary/c-antenna-batch-${APP_SHA1}.jar -O c-antenna-batch.jar
RUN tar xfvz c-antenna.tar.gz
RUN mkdir /usr/local/app
RUN mkdir /usr/local/batch
RUN mv c-antenna /usr/local/app/
RUN mv c-antenna-batch.jar /usr/local/batch/

WORKDIR /usr/local/app/c-antenna

EXPOSE 9000

CMD redis-server /etc/redis/redis.conf &&\
  LANG=ja_JP.UTF-8 java -Dconfig.resource=prod.conf -jar /usr/local/batch/c-antenna-batch.jar &&\
  ./bin/c-antenna -Dconfig.resource=prod.conf -Dhttp.port=9000
