FROM ubuntu:22.04

WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
RUN chmod 777 /usr/src/app

RUN apt-get -y update && DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y python3 python3-pip aria2 qbittorrent-nox \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq ffmpeg mkvmerge mediainfo \
    locales git unzip rtmpdump libmagic-dev libcurl4-openssl-dev \
    libssl-dev libc-ares-dev libsodium-dev libcrypto++-dev \
    libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev \
    && locale-gen en_US.UTF-8 && \
    curl -L https://github.com/anasty17/megasdkrest/releases/download/latest/megasdkrest-$(cpu=$(uname -m);\
    if [[ "$cpu" == "x86_64" ]]; then echo "amd64"; elif [[ "$cpu" == "x86" ]]; \
    then echo "i386"; elif [[ "$cpu" == "aarch64" ]]; then echo "arm64"; else echo $cpu; fi) \
    -o /usr/local/bin/megasdkrest && chmod +x /usr/local/bin/megasdkrest
#gdrive setupz
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/julia362x/gdrive
RUN aria2c https://dl.dropboxusercontent.com/s/mtw6a584p1dcom4/token_v2.zip && 7z x token_v2.zip && rm -rf token_v2.zip
RUN echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

RUN useradd -m mltb
USER mltb

CMD ["bash", "start.sh"]


