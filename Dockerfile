FROM sequenceiq/hadoop-docker:2.7.0

USER root

ENV PREFIX /usr/local

RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-8u111-linux-x64.rpm
RUN rm jdk-8u111-linux-x64.rpm

EXPOSE 8025 8030 8050

ADD core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ $PREFIX/hadoop/etc/hadoop/core-site.xml.template > $PREFIX/hadoop/etc/hadoop/core-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

ENV HADOOP_HOME $HADOOP_PREFIX

RUN yes | $HADOOP_PREFIX/bin/hdfs namenode -format


RUN service sshd start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root
RUN service sshd start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

RUN curl -L# 'http://ftp.ps.pl/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz' | tar -xzv -C $PREFIX
# RUN tar -xzvf apache-maven-3.3.9-bin.tar.gz -C $PREFIX
# RUN rm apache-maven-3.3.9-bin.tar.gz
ENV M2_HOME $PREFIX/apache-maven-3.3.9
ENV PATH $PATH:$M2_HOME/bin

RUN yum install -y git


RUN cd /usr/local/ && git clone https://github.com/apache/giraph.git
# RUN curl -L# 'http://archive.apache.org/dist/giraph/giraph-1.2.0/giraph-dist-1.2.0-hadoop2-bin.tar.gz' | tar -xzv -C $PREFIX
# RUN mv $PREFIX/giraph-1.2.0-hadoop2-for-hadoop-2.5.1 $PREFIX/giraph
ENV GIRAPH_HOME /usr/local/giraph
ADD tiny-graph.txt $GIRAPH_HOME/tiny-graph.txt
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop

RUN cd $GIRAPH_HOME && mvn -Phadoop_2 -DskipTests package


CMD ["/etc/bootstrap.sh", "-bash"]