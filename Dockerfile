FROM anasty17/mltb:latest
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata aria2 python3 python3-pip \
    locales python3-lxml \
    curl pv jq mkvmerge ffmpeg mediainfo \
    wget git zip unzip \
    p7zip-full p7zip-rar
#gdrive setupz
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz \ &&
tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" \ &&
go get github.com/julia362x/gdrive && rm rm /tmp/go1.17.1.linux-amd64.tar.gz \
&& echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
CMD ["bash", "start.sh"]
