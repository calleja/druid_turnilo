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


#edit the Dockerfile to inject custom CSS link into Turnilo's served HTML <- I should have it reviewed. It will eventually replace the original Dockerfile above.
# FROM node:18
# MAINTAINER uchhatre@gmail.com
# EXPOSE 9090
# RUN npm install -g turnilo@latest

# # Inject custom CSS link into Turnilo's served HTML
# COPY custom.css /usr/local/lib/node_modules/turnilo/build/public/custom.css
# RUN find /usr/local/lib/node_modules/turnilo/build -name "*.html" \
#     -not -path "*/node_modules/*" \
#     -exec sed -i 's|</head>|<link rel="stylesheet" href="/custom.css"></head>|g' {} \;

# COPY run_refactored.sh /
# RUN chmod +x /run_refactored.sh
# CMD ["/run_refactored.sh"]

