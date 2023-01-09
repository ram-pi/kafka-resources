{{ if (datasource "config").prometheus.enable -}}
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'kafka-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'kafka'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 60s

    static_configs:
      - targets:
      {{- range $i2, $e2 := (datasource "config").kafka }}
        - {{ $e2.name }}:8091
      {{ end }}

  - job_name: 'zookeeper'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 60s

    static_configs:
      - targets:
      {{- range $i2, $e2 := (datasource "config").zookeeper }}
        - {{ $e2.name }}:8091
      {{ end }}
{{ end }}