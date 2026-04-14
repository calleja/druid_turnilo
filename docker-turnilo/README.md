# docker-turnilo

create the image in Docker: > docker build -t turnilo-test ./docker-turnilo

instantiate the container (requires a druid broker service running): 
docker run -d --rm -p 9090:9090 -e DRUID_BROKER_URL=http://host.docker.internal:8082 turnilo-test

docker start 

dashboard viewable here:
http://localhost:9090

# graphic rendering issue
Reduce measures to ≤3 — as you discovered, this is the immediate workaround.

Scroll down in the chart area — the .line-charts div has overflow-y: auto, so you can scroll within the chart area to see the last chart. The XAxis technically renders below, but the browser viewport clips it.

Use a wider/taller browser window — stage.height comes from the browser's available viewport height. A taller window gives more room before overflow kicks in.

Modify MIN_CHART_HEIGHT — if you were to edit calculate-chart-stage.ts:21 and change MIN_CHART_HEIGHT from 200 to something smaller (e.g., 140), each chart panel would shrink and more could fit. This would require building Turnilo from source (using the turnilo directory), but that's a heavier change than your current Docker setup.

Use "Group Series" mode — in Turnilo's Line Chart settings (gear icon top-right), you can toggle "Group Series" which overlays all measures on a single chart panel (rendered via ChartsPerSplit instead of ChartsPerSeries in charts.tsx:42-46), eliminating the vertical stacking entirely.

# original.md
If you are here, chances are you have figured how to run druid and this writeup assumes that you have it running.

Your goal here is either to connect it and dump config.yml that you can later edit and run. Or you just want to run it to quickly browse the content of your Druid.

Here are typical usage patterns --

1) Supply your druid  URL. If your druid is running at : http://192.168.1.156:8082, here is a quick command to fire up Turnilo

```
docker run -d -e "DRUID_BROKER_URL=http://192.168.1.156:8082" -p 9091:9090 uchhatre/turnilo:latest
```

2) If you want to export a config file that you hope to edit, here are 2 steps you need to do. The step below will export new-config.yml file in your /Users/myname/myconfigdir directory

```
docker run -d -e "DRUID_BROKER_URL=http://192.168.1.156:8082" -e "DUMP_CONFIG=true" -v /Users/myname/myconfigdir:/etc/config/export uchhatre/turnilo:latest
```

3) If you have a config file, or you just exported one in the step above that you want to run, load it as below. If you do not plan to edit the config file, exporting one is needless!

```
docker run -d -v /full-path-to-directroy-that-contains-config.yml-file:/etc/config/turnilo -e "CONFIG_FILE=true" -p 9091:9090 uchhatre/turnilo:latest
```

4) If you know how to run turnilo, details here, you can just supply those arguments

```
docker run -d -e "MYARGS=--druid http://192.168.1.156:8082" -p 9091:9090 uchhatre/turnilo:latest
```


5) Default no argument run will try to connect to druid at druid_broker_host:8082

```
docker run -d -p 9091:9090 test
```

Turnilo will be available at 

http://localhost:9091/


If building and running locally (assuming you have docker already installed and running)

Pull the git repo first

```
git clone https://github.com/uchhatre/docker-turnilo.git
cd docker-turnilo
```

Now build the docker image, 
```
docker build -t turnilo/test .
docker run -d -e "DRUID_BROKER_URL=http://192.168.1.156:8082" -p 9091:9090 turnilo/test
```
