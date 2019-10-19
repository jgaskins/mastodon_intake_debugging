FROM crystallang/crystal:0.31.1

ADD . /src
WORKDIR /src

RUN shards build --production

EXPOSE 5000/tcp

CMD ["bin/mastodon_intake_debugging"]
