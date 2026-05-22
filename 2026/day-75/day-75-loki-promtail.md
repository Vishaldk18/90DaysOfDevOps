### Task 1: Understand the Logging Pipeline
Before writing any config, understand how the pieces fit together:

```
[Docker Containers]
       |
       | (write JSON logs to /var/lib/docker/containers/)
       v
  [Promtail]
       |
       | (reads log files, adds labels, pushes to Loki)
       v
    [Loki]
       |
       | (stores logs, indexes by labels)
       v
   [Grafana]
       |
       | (queries Loki with LogQL, displays logs)
       v
   [You]
```

Key differences from the ELK stack:
- Loki does **not** index the full text of logs -- it only indexes labels (like container name, job, filename)
- This makes Loki much cheaper to run and simpler to operate
- Think of it as "Prometheus, but for logs" -- same label-based approach

**Document:** Why does Loki only index labels instead of full text? What is the trade-off?
Here’s a crisp **interview-ready answer** you can give:

***

**Answer:**

Loki indexes only **labels (metadata)** instead of full log content primarily to achieve **better cost efficiency and scalability**.

In traditional logging systems like Elasticsearch, full-text indexing requires indexing every word in every log, which significantly increases storage and compute overhead. Loki avoids this by:

* Storing logs in compressed chunks
* Indexing only a small set of labels like `app`, `namespace`, or `pod`

This makes Loki much **cheaper to run** and **simpler to scale**, especially in high-volume environments like Kubernetes.

***

**Trade-off:**

The key trade-off is between **cost and search flexibility**:

* ✅ **Pros:**
  * Lower storage and infrastructure cost
  * Better scalability for large log volumes
  * Simpler architecture

* ❌ **Cons:**
  * Slower text search since logs are not fully indexed
  * Queries rely heavily on well-designed labels
  * Less efficient for ad-hoc or unknown search patterns

***

**One-line summary:**

> Loki trades fast full-text search for lower cost and massive scalability by indexing only labels instead of entire logs.

***
---
