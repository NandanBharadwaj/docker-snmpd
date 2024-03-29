FROM alpine:3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="Nandan Bharadwaj" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="snmpd" \
  org.label-schema.description="SNMP daemon" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="" \
  org.label-schema.vendor="Nandan Bharadwaj" \
  org.label-schema.schema-version="1.0"

ENV SNMPD_VERSION="5.8"

RUN apk add --update --no-cache \
    curl \
    libressl \
    perl \
    perl-net-snmp \
    tzdata \
    zlib \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    file \
    grep \
    perl-dev \
    libressl-dev \
    linux-headers \
    zlib-dev \
  && cd /tmp \
  && curl -L http://downloads.sourceforge.net/project/net-snmp/net-snmp/${SNMPD_VERSION}/net-snmp-${SNMPD_VERSION}.tar.gz -o net-snmp-${SNMPD_VERSION}.tar.gz \
  && tar zxf net-snmp-${SNMPD_VERSION}.tar.gz \
  && cd net-snmp-${SNMPD_VERSION} \
  && echo "Replace /dev with /rootfs/dev in:" \
  && grep -lr '"/dev' agent/* | while read line; do echo "  - $line" && sed -i 's@"/dev@"/rootfs/dev@g' $line; done \
  && grep -lr '"/dev' apps/* | while read line; do echo "  - $line" && sed -i 's@"/dev@"/rootfs/dev@g' $line; done \
  && grep -lr '"/dev' snmplib/* | while read line; do echo "  - $line" && sed -i 's@"/dev@"/rootfs/dev@g' $line; done \
  && echo "Replace /etc with /rootfs/etc in:" \
  && grep -lr '"/etc' agent/* | while read line; do echo "  - $line" && sed -i 's@"/etc@"/rootfs/etc@g' $line; done \
  && grep -lr '"/etc' apps/* | while read line; do echo "  - $line" && sed -i 's@"/etc@"/rootfs/etc@g' $line; done \
  && grep -lr '"/etc' snmplib/* | while read line; do echo "  - $line" && sed -i 's@"/etc@"/rootfs/etc@g' $line; done \
  && echo "Replace /proc with /rootfs/proc in:" \
  && grep -lr '"/proc' agent/* | while read line; do echo "  - $line" && sed -i 's@"/proc@"/rootfs/proc@g' $line; done \
  && grep -lr '"/proc' apps/* | while read line; do echo "  - $line" && sed -i 's@"/proc@"/rootfs/proc@g' $line; done \
  && grep -lr '"/proc' snmplib/* | while read line; do echo "  - $line" && sed -i 's@"/proc@"/rootfs/proc@g' $line; done \
  && echo "Replace /sys with /rootfs/sys in:" \
  && grep -lr '"/sys' agent/* | while read line; do echo "  - $line" && sed -i 's@"/sys@"/rootfs/sys@g' $line; done \
  && grep -lr '"/sys' apps/* | while read line; do echo "  - $line" && sed -i 's@"/sys@"/rootfs/sys@g' $line; done \
  && grep -lr '"/sys' snmplib/* | while read line; do echo "  - $line" && sed -i 's@"/sys@"/rootfs/sys@g' $line; done \
  && ./configure --prefix=/usr/local --disable-ipv6 --with-defaults \
  && make \
  && make install \
  && ln -s /usr/local/net-snmp/bin/* /usr/local/bin/ \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

COPY assets /

EXPOSE 161/udp

CMD [ "/usr/local/sbin/snmpd", "-f", "-Lo", "-c", "/etc/snmpd.conf" ]
