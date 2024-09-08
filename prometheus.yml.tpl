global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['${instance_ip}:9100']

  - job_name: 'prometheus'
    static_configs:
      - targets: ['${instance_ip}:9090']
