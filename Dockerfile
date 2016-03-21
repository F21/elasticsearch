FROM f21global/java:8
MAINTAINER Francis Chuang <francis.chuang@boostport.com>

ENV ELASTICSEARCH_VER 2.2.1

RUN apt-get update \
    && apt-get install -y ca-certificates wget \
    && wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
    && echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends elasticsearch=$ELASTICSEARCH_VER

RUN arch="$(dpkg --print-architecture)" \
	&& set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.7/gosu-$arch" \
	&& chmod +x /usr/local/bin/gosu

ADD logging.yml /etc/elasticsearch/logging.yml

ADD run-elasticsearch.sh /run-elasticsearch.sh

VOLUME ["/var/lib/elasticsearch/data"]

EXPOSE 9200 9300

CMD ["/run-elasticsearch.sh"]