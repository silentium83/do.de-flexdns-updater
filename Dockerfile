FROM alpine

RUN apk add --no-cache bash curl grep

ADD ./updater.sh /bin/updater 

ENTRYPOINT [ "/bin/updater" ]