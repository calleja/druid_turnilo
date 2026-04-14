FROM node:18
MAINTAINER uchhatre@gmail.com
EXPOSE 9090
RUN npm install -g turnilo@latest
#COPY = copy files from host to the container
COPY run_refactored.sh /
# RUN instruction is used to run commands inside the container during the build process.
RUN chmod +x /run_refactored.sh
#CMD = specifies the command to run when the container starts. It can be overridden at runtime.
CMD ["/run_refactored.sh"]
