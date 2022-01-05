ARG NODE_VERSION=16
FROM hmctspublic.azurecr.io/imported/library/node:$NODE_VERSION-alpine

ENV APP_USER=hmcts \
  WORKDIR=/opt/app

WORKDIR ${WORKDIR}

RUN apk --no-cache add shadow=4.11.1 \
  && userdel node \
  && apk del shadow \
  && addgroup -g 1000 -S $APP_USER \
  && adduser -u 1000 -S $APP_USER -G $APP_USER \
  && chown -R $APP_USER:$APP_USER /opt/app

USER hmcts
CMD ["yarn", "start"]
