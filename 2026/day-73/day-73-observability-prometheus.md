# Task 1: Understand Observability
## ✅ 1. What is Observability?

**Answer:**  
Observability is the ability to understand the internal state of a system by analyzing the data it generates, such as logs, metrics, and traces.

👉 In simple terms:

> It helps engineers answer **“why something went wrong”** without needing predefined checks.

***

## ✅ 2. Difference Between Observability and Traditional Monitoring

**Answer:**

*   **Monitoring** focuses on tracking predefined metrics and known failure conditions.
*   **Observability** enables deep analysis of unknown issues by exploring system behavior dynamically.

👉 Key difference:

*   Monitoring answers → **What is wrong?**
*   Observability answers → **Why is it wrong?**

👉 Example:

*   Monitoring: Alert when CPU > 90%
*   Observability: Identify which service and request caused high CPU

***

## ✅ 3. Three Pillars of Observability

**Answer:**

### 1. Metrics

*   Numerical data collected over time
*   Example: CPU usage, memory, response time
*   Used for alerting and trend analysis

***

### 2. Logs

*   Detailed, timestamped records of events
*   Example: Error messages, transaction logs
*   Used for debugging and root cause analysis

***

### 3. Traces

*   Track request flow across multiple services
*   Shows end-to-end journey of a request
*   Used to identify latency and bottlenecks

***

## ✅ 4. Why DevOps Engineers Need All Three

**Answer:**

Modern systems are distributed and complex, so no single data source is enough.

👉 Combined usage:

*   Metrics → Detect issue (e.g., latency spike)
*   Traces → Identify affected service
*   Logs → Find exact error

✅ Benefits:

*   Faster root cause analysis
*   Reduced MTTR (Mean Time to Repair)
*   Better system reliability

***

## ✅ 5. Observability Architecture (Interview Explanation)

**Answer:**

A typical observability architecture includes:

    Application (Microservices)
            ↓
    Instrumentation (OpenTelemetry)
            ↓
    Collectors / Agents
      (Prometheus, Fluentd, OTel Collector)
            ↓
    Storage Backends
      - Metrics DB (Prometheus)
      - Logs (ElasticSearch)
      - Traces (Jaeger/Zipkin)
            ↓
    Visualization Layer
      (Grafana / Kibana / Datadog)
            ↓
    Alerting System

👉 Explanation flow:

1.  Applications generate telemetry data
2.  Agents collect and send data
3.  Data is stored and processed
4.  Dashboards visualize insights
5.  Alerts notify issues

***

## ✅ 1-Line Summary (Great for Interviews)

> Observability uses logs, metrics, and traces to provide deep visibility into systems, helping engineers diagnose and resolve issues faster compared to traditional monitoring.

***

### Task 2: Set Up Prometheus with Docker
Create a project directory for this entire observability block -- you will keep adding to it over the next 5 days.

```bash
mkdir observability-stack && cd observability-stack
```

Create a `prometheus.yml` configuration file:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

This tells Prometheus to scrape its own metrics every 15 seconds.

Create a `docker-compose.yml` to run Prometheus:
```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped

volumes:
  prometheus_data:
```

Start Prometheus:
```bash
docker compose up -d
```

Open `http://localhost:9090` in your browser. You should see the Prometheus web UI.

**Verify:** Go to Status > Targets. You should see one target (`prometheus`) with state `UP`.

---

### Task 3: Understand Prometheus Concepts
Explore the Prometheus UI and understand these concepts:

1. **Scrape targets** -- endpoints that Prometheus pulls metrics from at regular intervals (pull-based model)
2. **Metrics types:**
   - `Counter` -- only goes up (total requests served, total errors)
   - `Gauge` -- goes up and down (current CPU usage, memory in use, active connections)
   - `Histogram` -- distribution of values in buckets (request duration: how many took <100ms, <500ms, <1s)
   - `Summary` -- similar to histogram but calculates percentiles on the client side
3. **Labels** -- key-value pairs that add dimensions to metrics (e.g., `http_requests_total{method="GET", status="200"}`)
4. **Time series** -- a unique combination of metric name + labels

Go to the Prometheus UI graph page (`http://localhost:9090/graph`) and run these queries:

```
# How many metrics is Prometheus collecting about itself?
count({__name__=~".+"})

# How much memory is Prometheus using?
process_resident_memory_bytes

# Total HTTP requests to the Prometheus server
prometheus_http_requests_total

# Break it down by handler
prometheus_http_requests_total{handler="/api/v1/query"}
```

**Document:** What is the difference between a counter and a gauge? Give one real-world example of each.
## ✅ Difference Between Counter and Gauge (Interview Answer)

### 🔹 Counter

**Definition:**  
A **counter** is a metric that **only increases over time** (or resets to zero on restart).

👉 Key characteristics:

*   Monotonically increasing
*   Cannot decrease
*   Used for counting occurrences/events

**✅ Real-world example:**

*   Number of HTTP requests served by an API
        http_requests_total = 100 → 150 → 200

👉 Even if traffic slows, the value never goes down—it only increases.

***

### 🔹 Gauge

**Definition:**  
A **gauge** is a metric that **can go up and down**, representing the current value at any point in time.

👉 Key characteristics:

*   Can increase or decrease
*   Represents instantaneous value
*   Used for measurements

**✅ Real-world example:**

*   CPU usage percentage
        CPU usage = 40% → 75% → 30%

👉 It fluctuates based on system load.

***

## ✅ Key Differences

| Feature        | Counter                | Gauge                   |
| -------------- | ---------------------- | ----------------------- |
| Value behavior | Only increases         | Increases & decreases   |
| Reset          | Resets only on restart | No restriction          |
| Use case       | Counting events        | Measuring current state |
| Example        | API requests count     | Memory or CPU usage     |

***

## ✅ 1-Line Interview Answer

> A counter only increases and is used to track cumulative values like request counts, whereas a gauge can increase or decrease and represents current values like CPU or memory usage.

***
---


### Task 4: Learn PromQL Basics

***

# ✅ 1. What is PromQL (in simple words)

PromQL is the language used to **query metrics in Prometheus**.

👉 Think of it like:

*   SQL → for databases
*   PromQL → for metrics

You use it to ask questions like:

*   Is my service running?
*   How fast are requests coming?
*   Which service is slow?

***

# ✅ 2. Types of Data in Prometheus (VERY IMPORTANT)

Prometheus works mainly with **time-series data**.

### 🔹 Instant Vector

👉 Current value at this moment

Example:

```promql
up
```

✅ Output:

    1 = service is up  
    0 = service is down

✔ It shows the **latest value only**

***

### 🔹 Range Vector

👉 Values over a time period

Example:

```promql
prometheus_http_requests_total[5m]
```

✅ Output:

*   All data points from last 5 minutes

✔ Not just one value → multiple values

***

# ✅ 3. Understanding the Base Metric

    prometheus_http_requests_total

👉 This is a **counter metric**

### 🔹 What is a Counter?

*   Always increases
*   Tracks total events

Example:

    Time     Value
    10:00    100
    10:01    120
    10:02    150

👉 It never decreases

***

# ✅ 4. Why We Need rate()

Problem:
👉 Counter keeps increasing → not useful directly

We want:
👉 “How fast requests are happening NOW”

***

### 🔹 rate() Function

    rate(metric[time])

👉 Converts counter → **per-second rate**

***

### ✅ Example

    rate(prometheus_http_requests_total[5m])

👉 Meaning:

> “How many requests per second in last 5 minutes?”

***

# ✅ 5. Label Filtering (Very Important)

Metrics have labels like this:

    prometheus_http_requests_total{method="GET", code="200"}

***

### 🔹 Filter Example

✅ Only success:

```promql
prometheus_http_requests_total{code="200"}
```

✅ Only errors:

```promql
prometheus_http_requests_total{code!="200"}
```

👉 This removes HTTP 200 (OK)

***

# ✅ 6. Aggregation (sum)

If you have multiple instances:

    instance=server1
    instance=server2

Without sum:
👉 You get separate values

With sum:

```promql
sum(rate(prometheus_http_requests_total[5m]))
```

👉 Combine everything into one value

***

# ✅ 7. Arithmetic Operations

Example:

```promql
process_resident_memory_bytes / 1024 / 1024
```

👉 Converts:

*   Bytes → KB → MB

***

# ✅ 8. Top-K Query

    topk(5, prometheus_http_requests_total)

👉 Shows:

*   Top 5 highest values

***

# ✅ 9. Now Combine Everything (Final Concept)

We want:

👉 “Rate of error requests (non-200) in last 5 min”

***

### Step-by-step:

#### Step 1 → Base metric

    prometheus_http_requests_total

#### Step 2 → Filter errors

    prometheus_http_requests_total{code!="200"}

#### Step 3 → Time window

    prometheus_http_requests_total{code!="200"}[5m]

#### Step 4 → Convert to rate

    rate(prometheus_http_requests_total{code!="200"}[5m])

***

# ✅ Final Query

```promql
rate(prometheus_http_requests_total{code!="200"}[5m])
```

***

# ✅ What Happens Internally

Let’s say:

| Time  | Error Requests |
| ----- | -------------- |
| 10:00 | 100            |
| 10:05 | 160            |

👉 Increase = 60 requests

Time = 300 seconds

    rate = 60 / 300 = 0.2 req/sec

***

# ✅ Visual Understanding

    Counter (raw):
    100 → 150 → 200 → 260

    Rate:
    0.1 → 0.2 → 0.3 req/sec

***

# ✅ Full Flow Summary

    Metric → Filter → Time Range → Function → Result
       ↓         ↓         ↓           ↓
    counter   errors     5m        rate()

***

# ✅ Bonus: Add sum (best practice in real world)

```promql
sum(rate(prometheus_http_requests_total{code!="200"}[5m]))
```

👉 Gives total error rate across all services

***

# ✅ Final Understanding in One Sentence

> We take a counter metric, filter only errors, look at last 5 minutes, and convert it into per-second rate to understand how fast errors are happening.

***
---
### Task 5: Add a Sample Application as a Scrape Target
Prometheus needs something to monitor. Add a simple metrics-generating service.

Update your `docker-compose.yml` to include a sample app that exposes Prometheus metrics:
```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped

  notes-app:
    image: trainwithshubham/notes-app:latest
    container_name: notes-app
    ports:
      - "8000:8000"
    restart: unless-stopped

volumes:
  prometheus_data:
```

Update `prometheus.yml` to scrape the app:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "notes-app"
    static_configs:
      - targets: ["notes-app:8000"]
```

Restart the stack:
```bash
docker compose up -d
```

Go back to Status > Targets. You should now see two targets. Generate some traffic to the app:
```bash
curl http://localhost:8000
curl http://localhost:8000
curl http://localhost:8000
```

**Note:** Not all applications expose Prometheus metrics natively. In later days you will learn how Node Exporter, cAdvisor, and OTEL Collector act as metric exporters for systems that do not have built-in Prometheus support.

---
