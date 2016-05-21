FROM java:8

MAINTAINER tsukaby

RUN apt-get update

# Redis
RUN apt-get -y install redis-server
RUN apt-get -y install build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev

# Redis demonize off
RUN sed -i -e "s/daemonize yes/daemonize no/g" /etc/redis/redis.conf

# PhantomJS
RUN apt-get -y install build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev
ENV PHANTOM_VERSION c7d7c656b3924e08c5488a58165289fbb1a512bb
RUN git clone --recurse-submodules git://github.com/ariya/phantomjs.git && \
  cd phantomjs && \
  git checkout ${PHANTOM_VERSION} && \
  ./build.py
RUN mv phantomjs/bin/phantomjs /usr/local/bin/
RUN rm -rf phantomjs

# Reconfig
## Locale
RUN apt-get -y install locales
RUN sed -i -e "s/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/g" /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=ja_JP.UTF-8

## TimeZone
RUN echo "Asia/Tokyo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Supervisor
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
COPY files/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN wget http://central.maven.org/maven2/org/aspectj/aspectjweaver/1.8.6/aspectjweaver-1.8.6.jar -P /usr/local

# Copy application
ENV APP_SHA1 1e0646446190b519fce8cb476332babf84c719cc

WORKDIR /tmp
RUN wget https://s3-ap-northeast-1.amazonaws.com/c-antenna/binary/c-antenna-${APP_SHA1}.tar.gz -O c-antenna.tar.gz
RUN wget https://s3-ap-northeast-1.amazonaws.com/c-antenna/binary/c-antenna-batch-${APP_SHA1}.jar -O c-antenna-batch.jar
RUN tar xfvz c-antenna.tar.gz
RUN mkdir /usr/local/app
RUN mkdir /usr/local/batch
RUN mv c-antenna /usr/local/app/
RUN mv c-antenna-batch.jar /usr/local/batch/

COPY files/usr/local/startup.sh /usr/local/startup.sh
RUN chmod +x /usr/local/startup.sh

WORKDIR /usr/local/app/c-antenna

EXPOSE 9000

CMD ["/usr/local/startup.sh"]
