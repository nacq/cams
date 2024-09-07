FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg2 \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    gcc \
    unzip \
    make

RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz

RUN wget https://github.com/arut/nginx-rtmp-module/archive/refs/heads/master.zip && \
    unzip master.zip

WORKDIR nginx-1.21.6
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && \
    make && \
    make install

RUN mkdir -p /var/log/nginx
RUN chmod 777 /var/log/nginx

RUN mkdir -p /tmp/hls
RUN chmod 777 /tmp/hls

RUN mkdir -p /tmp/dash
RUN chmod 777 /tmp/dash

COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY index.html /usr/local/nginx/html/index.html
COPY .htpasswd /usr/local/nginx/.htpasswd

# expose rtmp and http ports
EXPOSE 1935 8080

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
