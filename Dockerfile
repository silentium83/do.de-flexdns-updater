FROM alpine

RUN apk add --no-cache bash coreutils curl grep

ADD ./updater.sh /bin/updater 

ENTRYPOINT [ "/bin/updater" ]