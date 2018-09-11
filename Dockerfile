FROM r-base:3.4.3

LABEL maintainer="bernd.steinert@itconcepts.net"

# create user/group with loose file permissions (to allow file deletes on docker host, e.g. jenkins)
RUN groupadd -g 115 -r ci &&\
    useradd -u 109 -r -g ci bookdown &&\
    mkdir /home/bookdown &&\
    echo "umask 000" > /home/bookdown/.bashrc &&\
    chown -R bookdown:ci /home/bookdown

RUN mkdir -p /project &&\
    chown -R bookdown:ci /project

# install R and pandoc
RUN apt-get update \
  && apt-get install -y \
    pandoc \
    texlive \
    texlive-latex-extra \
    texlive-lang-german \
    texinfo \
    imagemagick \
  && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages("bookdown")'

USER bookdown
VOLUME /project
WORKDIR /project
