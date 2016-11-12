`sudo docker build -t docker-giraph .` - build image
`sudo docker run --rm --interactive --tty docker-giraph` run and go to bash
inside: maven3, git, java8, hadoop, giraph

run example mapreduce job to check hadoop
`$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar grep input output 'dfs[a-z.]+'`
check output
`$HADOOP_HOME/bin/hdfs dfs -cat output/*`

load input
`$HADOOP_HOME/bin/hdfs dfs -put $GIRAPH_HOME/tiny-graph.txt /user/root/input/tiny-graph.txt`
run example giraph job
`$HADOOP_HOME/bin/hadoop jar $GIRAPH_HOME/giraph-examples/target/giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.5.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner org.apache.giraph.examples.SimpleShortestPathsComputation --yarnjars giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.5.1-jar-with-dependencies.jar --workers 1 --vertexInputFormat org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat --vertexInputPath /user/root/input/tiny-graph.txt -vertexOutputFormat org.apache.giraph.io.formats.IdWithValueTextOutputFormat --outputPath /user/root/output2`
check output
`$HADOOP_HOME/bin/hdfs dfs -cat /user/root/output2/part-m-00001`

links: https://github.com/uwsampa/giraph-docker - useful hack for now at the end, instructions on how to mount volume, compile, package and run own giraph computations
https://github.com/sequenceiq/hadoop-docker - base docker image - variables in dockerfile

