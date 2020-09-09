FROM amazonlinux:2

WORKDIR /opt

RUN amazon-linux-extras install -y epel
RUN yum -y install git python2-pip python-devel httpd mod_wsgi mysql-devel gcc MySQL-python memcached libxslt-devel libxml2-devel
RUN pip install --upgrade setuptools
RUN pip install --upgrade pip

RUN git clone https://github.com/lhalam/EcoMap.git
RUN chown -R apache:apache ./EcoMap
COPY requirements.txt ./EcoMap
RUN pip install --ignore-installed -r ./EcoMap/requirements.txt
COPY ./configs/* ./EcoMap/ecomap/etc/
COPY ./httpd_configs/httpd.conf /etc/httpd/conf/
COPY ./httpd_configs/ecomap.conf /etc/httpd/conf.d/ecomap.conf
RUN chown -R apache /opt
COPY entrypoint.sh .
EXPOSE 80
RUN chmod 777 ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
