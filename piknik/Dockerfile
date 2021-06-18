FROM busybox

ARG VERSION=0.10.1
ARG ARCH=arm

RUN mkdir /usr/bin
RUN wget -O - https://github.com/jedisct1/piknik/releases/download/${VERSION}/piknik-linux_${ARCH}-${VERSION}.tar.gz | tar -xzf - --strip-components 1 -C /usr/bin linux-${ARCH}/piknik

EXPOSE 8075

ENTRYPOINT ["piknik"]
CMD ["-config", "/etc/piknik/piknik.toml", "-server"]
