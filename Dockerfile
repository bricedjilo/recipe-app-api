FROM python:3.7-alpine
LABEL maintainer="Brice Djilo"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

# Configure django to use our postgres db
# 1- Use the package manager that comes with alpine (apk)
# 2- Update the registry before adding a package
# 3- Add the postgresql-client package
# 4- No file caching (minimal footprint)
# 5- tmp-build-deps: temporary built dependencies
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt

# Remove tempoprary dependencies
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# (user) is used by docker to run your project
RUN adduser -D user
USER user 
