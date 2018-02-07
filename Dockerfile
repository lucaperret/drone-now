FROM node:alpine

RUN npm install -g --unsafe-perm now

ADD script.sh /bin/
RUN chmod +x /bin/script.sh

ENTRYPOINT /bin/script.sh
