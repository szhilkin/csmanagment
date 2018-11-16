FROM centos:7
ENV PKG_URL=http://download.cloudstack.org/centos/7/4.11/
# install CloudStack
RUN rpm -i https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-8.0.13-1.el7.x86_64.rpm \
    && yum install -y nc wget \
    ${PKG_URL}/cloudstack-common-4.11.1.0-1.el7.centos.x86_64.rpm \
    ${PKG_URL}/cloudstack-management-4.11.1.0-1.el7.centos.x86_64.rpm
    && cd /etc/cloudstack/management; \
    && ln -s tomcat7-nonssl.conf tomcat7.conf; \
    && ln -s server-nonssl.xml server.xml; \
    #&& ln -s log4j-cloud.xml log4j.xml; \
    && wget -O /usr/share/cloudstack-common/scripts/vm/hypervisor/xenserver/vhd-util \
    http://download.cloudstack.org/tools/vhd-util
COPY init.sh_centos7 /root/init.sh
COPY systemtpl.sh /root/systemtpl.sh
RUN yum clean all
RUN sed -i "s/cluster.node.IP=.*/cluster.node.IP=localhost/" /etc/cloudstack/management/db.properties
EXPOSE 8080 8250 8096 45219 9090 8787
# Ports:
#   8080: webui, api
#   8250: systemvm communication
#   8096: api port without authentication(default=off)
# Troubleshooting ports:
#   8787: CloudStack (Tomcat) debug socket
#   9090: Cloudstack Management Cluster Interface
#   45219: JMX console
CMD ["/root/init.sh"]
