FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until

RUN apt-get update && \
	apt-get install -y software-properties-common && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FABAEF95 && \
	add-apt-repository -y ppa:supercollider/ppa && \
	add-apt-repository -y multiverse && \
	apt-get update && \
    apt-get install -y darkice libasound2 libasound2-plugins alsa-utils alsa-oss jack-tools supercollider xvfb curl sc3-plugins && \
    apt-get clean

COPY --from=grahamsw/forego /forego/forego /usr/bin/
RUN chmod +x /usr/bin/forego

COPY asoundrc /root/.asoundrc

COPY darkice.cfg /etc/darkice.cfg

COPY startup.scd /root/.config/SuperCollider/startup.scd
COPY core.sc /core.sc
COPY impl.sc /impl.sc

COPY Procfile Procfile

RUN mv /etc/security/limits.d/audio.conf.disabled /etc/security/limits.d/audio.conf && \
	usermod -a -G audio root

CMD ["forego", "start"]

