FROM centos:centos7 as base

# LABEL Lawrence Stubbs <technoexpressnet@gmail.com>

# Environment variables
ENV \
    LC_ALL=en_US.UTF-8                \
    RUNTIME_DEPENDENCIES="            \
        wget"                         \
    BUILD_DEPENDENCIES="              \
        git"

# RUN apt-get update && apt-get -y install mongodb sudo
# Bring environment up-to-date and install guacamole-server dependencies

    # yum -y install epel-release          && \
    # yum -y install $RUNTIME_DEPENDENCIES && \
RUN yum -y update                        && \
    yum clean all

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y nodejs

RUN useradd meshserver && \
    mkdir -p /home/meshserver/meshcentral-data

FROM base as builder

RUN yum -y install $BUILD_DEPENDENCIES

#RUN git clone --progress https://github.com/Ylianst/MeshCentral.git

FROM base as runtime

RUN yum -y update                        && \
    yum -y install $RUNTIME_DEPENDENCIES && \
    yum clean all

COPY package.json /home/meshserver/
#COPY --from=builder MeshCentral/package.json /home/meshserver/

COPY config.json /home/meshserver/meshcentral-data/

#RUN env

#RUN npm install meshcentral --loglevel verbose

RUN su - meshserver \
	&& cd /home/meshserver \
    && npm install meshcentral --loglevel verbose

COPY startmeshcentral.sh /home/meshserver/meshcentral-data/startmeshcentral.sh
RUN chmod +x /home/meshserver/meshcentral-data/startmeshcentral.sh

RUN chown -R meshserver:meshserver /home/meshserver/meshcentral-data

ENV PORT 443  
ENV REDIRPORT 80  
# ENV MPSPORT 4443
#ENV EMAIL mail@host
# ENV HOST host.ltd
# ENV SMTP smtp.host.ltd
# ENV USER smtp@user
# ENV PASS smtppass!
# ENV DB netdb
# ENV MONGODB "mongodb://127.0.0.1:27017/meshcentral"
# ENV MONGODBCOL "meshcentral"

EXPOSE 25 80 443
# EXPOSE 25 80 443 4443 27017 27018

#USER meshserver

ENTRYPOINT ["/home/meshserver/meshcentral-data/startmeshcentral.sh"]
#CMD [ "/home/meshserver/meshcentral-data/startmeshcentral.sh" ]
