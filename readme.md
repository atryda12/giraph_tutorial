# Giraph tutorial

Przed zajęciami prosimy, przygotujcie środowisko - jego konfiguracja zajmuje trochę czasu i pewnie nie zdążymy na zajęciach.

Będziemy potrzebowali:
* java 8
* giraph 1.2.0 - nie jest to jeszcze stabilny release ale chcemy skorzystać z kilku wprowadzonych feature'ów
* hadoop 2.5.1 lub nowszy (teoretycznie 2.5.1 to ostatni wspierany przez girapha, ale na 2.7.0 nie zauważyliśmy problemów)

Możliwości zestawienia środowiska są dwie:

## Opcja I - docker

Przygotowaliśmy to repozytorium z plikami potrzebnymi do zestawienia dockera w zupełności wystarczającego na zajęcia.

W obrazie oprócz wymienionych już javy, hadoopa (2.7.0) i girapha zainstalowane są git i maven

1. zbudujcie obraz: `sudo docker build -t docker-giraph .`
2. uruchomcie go - uzyskacie dostęp do basha: `sudo docker run --rm --interactive --tty docker-giraph`

Możecie teraz uruchomić przykładowe joby

Zwykły map-reduce w hadoopie:

1. uruchomienie: - `$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar grep input output 'dfs[a-z.]+'`
2. sprawdzenie wyników - `$HADOOP_HOME/bin/hdfs dfs -cat output/*`

Job girapha (przykład z https://giraph.apache.org/quick_start.html)

1. wczytajcie plik wejściowy - `$HADOOP_HOME/bin/hdfs dfs -put $GIRAPH_HOME/tiny-graph.txt /user/root/input/tiny-graph.txt`
2. uruchomcie job - `$HADOOP_HOME/bin/hadoop jar $GIRAPH_HOME/giraph-examples/target/giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.5.1-jar-with-dependencies.jar org.apache.giraph.GiraphRunner org.apache.giraph.examples.SimpleShortestPathsComputation --yarnjars giraph-examples-1.3.0-SNAPSHOT-for-hadoop-2.5.1-jar-with-dependencies.jar --workers 1 --vertexInputFormat org.apache.giraph.io.formats.JsonLongDoubleFloatDoubleVertexInputFormat --vertexInputPath /user/root/input/tiny-graph.txt -vertexOutputFormat org.apache.giraph.io.formats.IdWithValueTextOutputFormat --outputPath /user/root/output2`
3. sprawdźcie wyniki - `$HADOOP_HOME/bin/hdfs dfs -cat /user/root/output2/part-m-00001`

## Opcja II - Instrukcje z https://giraph.apache.org/quick_start.html

Wykonajcie po kolei kroki ze strony girapha. Z uwagi na nowszą wersję hadoopa:
* wykorzystajcie pliki konfiguracyjne z tego repozytorium (jeśli się tu znajdują - jeśli nie, wystarczy wersja ze strony)
* nie edytujcie /etc/hosts - używajcie localhosta
* przy buildowaniu girapha mavenem użyjcie `-Phadoop_2`

