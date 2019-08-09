FROM python:3.7-alpine
MAINTAINER Stewart Henderson <shenderson@mozilla.com>

ARG STRIPE_API_KEY
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG LOCAL_FLASK_PORT
ARG SUPPORT_API_KEY

ENV STRIPE_API_KEY=$STRIPE_API_KEY
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV LOCAL_FLASK_PORT=$LOCAL_FLASK_PORT
ENV SUPPORT_API_KEY=$SUPPORT_API_KEY

ENV FLASK_ENV=development
EXPOSE $LOCAL_FLASK_PORT

RUN mkdir -p /app
WORKDIR /app
COPY . /app
RUN apk add bash==5.0.0-r0 && \
    bin/install-packages.sh && \
    pip install -r automation_requirements.txt && \
    pip install awscli==1.16.213
RUN yarn install
RUN addgroup -g 10001 app && \
    adduser -D -G app -h /app -u 10001 app
USER app
ENTRYPOINT ["doit"]
CMD ["local"]