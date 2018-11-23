FROM alpine

RUN apk update && apk --no-cache \
  add ca-certificates && update-ca-certificates && \
  apk --no-cache add openssl wget openjdk8-jre && \
  cd /usr/local && \
  wget http://sourceforge.net/projects/geoserver/files/GeoServer/2.13.0/geoserver-2.13.0-bin.zip && \
  unzip geoserver-2.13.0-bin.zip && \
  rm geoserver-2.13.0-bin.zip

ENV GEOSERVER_HOME /usr/local/geoserver-2.13.0

EXPOSE 8080

CMD ["sh", "/usr/local/geoserver-2.13.0/bin/startup.sh"]
