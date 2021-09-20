# Instruction
This testing cluster consists of prometheus, alertmanager and grafana.

Before starting docker compose cluster, configuring the host docker daemon to export docker metrics (The `prometheus.yml` is configured for docker on MacOS): 
https://docs.docker.com/config/daemon/prometheus/

```bash
# start
docker-compose -f monitoring-compose.yaml up -d

# destroy
docker-compose -f monitoring-compose.yaml down -v
```
After up and running, see metrics status in prometheus dashboard `status` -> `targets` section. (The `status` menu is useful)

Web UI endpoints:
- prometheus: http://localhost:9090
- alertmanager: http://localhost:9093
- grafana: http://localhost:3000

The initial user/password for grafana is `admin`.

To add prometheus to grafana data source:
https://prometheus.io/docs/visualization/grafana/#installing
- Using `http://prometheus:9090` when access mode `Server`
- Using `http://localhost:9090` when access mode `Browser`

# Add Dashboard for Docker Metrics
After adding the data source from prometheus, we can fetch docker metrics to form dashboard.

Using this metics as an example:
```
engine_daemon_container_states_containers
```
Create a time series line-based panel, select the correct data source, here is `prometheus` (default), put `engine_daemon_container_states_containers` in Metrics browser field, use `{{state}}` as the Legend format (this label can be seen from docker daemon metrics endpoint `http://localhost:9323/metrics` with its data type: gauge). Then adjust other panel options and preference, finally apply and save dashboard.

Spawn more running containers to see metrics change (also alert configured in Prometheus rules):
```bash
for i in {1..5}
do
  docker run -itd --name bb-$i busybox
  # docker rm -f bb-$i
done
```

To import pre-configured community dashboard or for reference:
https://prometheus.io/docs/visualization/grafana/#importing-pre-built-dashboards-from-grafana-com

# Add Rules
In `prometheus.yml` configuration file, add your alerting rules and recording rules here for example:
https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
```yaml
rule_files:
  - /etc/alerts.d/*.yml
  - /etc/rules.d/*.yml
```
To quickly check whether a rule file is syntactically correct without starting a Prometheus server, you can use Prometheus's promtool command-line utility tool:
```bash
promtool check rules /path/to/example.rules.yml
```

# Alertmanager
Config prometheus to talk to alertmanager:
https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alertmanager_config

Config alertmanager for routing, notification receivers, inhibition rules, etc:
https://prometheus.io/docs/alerting/latest/configuration/

```yaml
# Alertmanager configuration
alerting:
  alertmanagers:
  # etc
```
Here in demo I use simple static config and no alertmanager config specified.

# Insight
Prometheus itself exports metrics: http://localhost:9090/metrics
Host docker metrics: http://localhost:9323/metrics

The prometheus expression browser has auto-completion, to navigate all metrics you can go to the metrics endpoints listed above. The metrics has 4 types: `counter`, `gauge`, `histrogram`, `summary`:
https://prometheus.io/docs/concepts/metric_types/

Default start command from official prom container:
```bash
top -b -n 1

/bin/prometheus --config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/prometheus \
--web.console.libraries=/usr/share/prometheus/console_libraries \
--web.console.templates=/usr/share/prometheus/consoles
```

Reload Prometheus, sending `SIGHUP` to the Prometheus process or an HTTP POST request to the `/-/reload` endpoint will reload and apply the configuration file. The various components attempt to handle failing changes gracefully.

Currently, the following external systems are supported:
- Email
- Generic Webhooks
- OpsGenie
- PagerDuty
- Pushover
- Slack
- VictorOps
- WeChat
