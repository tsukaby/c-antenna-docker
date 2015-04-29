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

# Copy application
ENV APP_SHA1 2f0953475f650047d2534c22f411c671c1b5f318
WORKDIR /tmp
RUN wget https://s3-ap-northeast-1.amazonaws.com/c-antenna/binary/c-antenna-${APP_SHA1}.tar.gz -O c-antenna.tar.gz
RUN tar xfvz c-antenna.tar.gz
RUN mv c-antenna /usr/local/

# Cron
ADD files/etc/crontab /etc/crontab

WORKDIR /usr/local/c-antenna

EXPOSE 9000

CMD redis-server /etc/redis/redis.conf &&\
  cron &&\
  ./bin/c-antenna -Dconfig.resource=prod.conf -Dhttp.port=9000
