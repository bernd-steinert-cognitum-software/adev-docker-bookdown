FROM debian:stretch-slim

LABEL maintainer="bernd.steinert@itconcepts.net"

# create user/group with loose file permissions (to allow file deletes on docker host, e.g. jenkins)
RUN groupadd -g 999 -r ci &&\
    useradd -u 999 -r -g ci bookdown &&\
    mkdir /home/bookdown &&\
    echo "umask 000" > /home/bookdown/.bashrc

RUN mkdir -p /project &&\
    chown -R bookdown:ci /project

# install R and pandoc
RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
        pandoc \
        r-base-dev &&\
    R -e "install.packages('bookdown', repo='https://cran.rstudio.com')"

USER bookdown
VOLUME /project
WORKDIR /project

# ENTRYPOINT ["R", "-e"]
# CMD ["bookdown::render_book('index.Rmd')"]