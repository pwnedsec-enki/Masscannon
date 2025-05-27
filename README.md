# Masscannon

Masscannon is a **fast, flexible, and advanced port scanning and fingerprinting tool** for network reconnaissance and penetration testing. It automates the workflow of **host and port discovery (with masscan)**, **intelligent service fingerprinting (with nmap)**, and **targeted NSE scripting**—all with optional webhook notification, output formatting, and adaptive scanning to minimize false positives.

> **Focus:**
> Quickly identify real services on networks, **filter out ambiguous ports**, and provide actionable intelligence with minimal noise, even in WAF/cloud/filtered environments.

---

## Features

* **Fast host/port discovery** with [masscan](https://github.com/robertdavidgraham/masscan)
* **Auto-adaptive rate limiting**: If masscan returns too many open ports (WAF or noisy network), it automatically slows down and retries for accuracy.
* **Prompt to scan Nmap’s top 1000 TCP ports** (fast) or any custom range (full/targeted).
* **Input from subnet or file of IPs/subnets** (supports large/targeted scans)
* **Definitive port filtering**: Only ports with confirmed, bannered services are considered for deep scanning. Ambiguous results (e.g., `tcpwrapped`, `unknown`, `?`) are dropped.
* **Automated in-depth fingerprinting**:
  For each valid port/service, runs the best-matched Nmap NSE scripts for thorough service analysis.
* **Optional UDP top 100 scan** for extra discovery.
* **Webhook support**: Send a Slack/Discord summary after each scan.
* **Output in text, HTML, CSV, and JSON** for flexible analysis/reporting.
* **Comprehensive logging** and error tracking.
* **Automatic temp file cleanup** after completion.

---

## Requirements

* Bash (Linux/Mac)
* [masscan](https://github.com/robertdavidgraham/masscan)
* [nmap](https://nmap.org/)
* `xsltproc` (for HTML nmap output)
* Python 3 + `xmltodict` (`pip3 install xmltodict`)
* `curl` (for webhook support)

---

## Quick Start

```bash
git clone https://github.com/yourusername/masscannon.git
cd masscannon
chmod +x masscannon.sh
./masscannon.sh
```

---

## Usage & Workflow

### **User Prompts**

You’ll be prompted for:

* **Target input**:

  * File of IPs/subnets (e.g. `targets.txt`)
  * OR single subnet (e.g. `192.168.1.0/24` or `52.116.11.220`)
* **Network interface** (e.g. `eth0`)
* **Initial scan rate** (packets per second)
* **Whether to scan only the Nmap Top 1000 TCP ports** (recommended for fast, low-noise scanning)
* **UDP scan inclusion**
* **Output filename prefix**
* **Webhook notifications**

---

### **How It Works**

1. **Discovery Phase (masscan)**

   * Scans at chosen rate for selected ports.
   * If it sees >100 open ports (possible WAF/noise), it automatically slows down to 100pps and retries for better accuracy.

2. **Parsing & Grouping**

   * Converts raw XML to list of target IP\:open-ports pairs.

3. **Validation & Filtering (nmap)**

   * For each host, nmap scans only the detected open ports using SYN scan + version detection.
   * **Filters out ambiguous ports** (`tcpwrapped`, `unknown`, `?` in service field).
   * Only ports with definitive, bannered services move on to deep analysis.

4. **Deep Fingerprinting**

   * For each validated port, the script **automatically selects and runs relevant nmap NSE scripts** (e.g., `http-*` scripts for HTTP, `ssl-cert` for HTTPS, etc.).
   * Only the right scripts are run for the right service and port, optimizing depth without noise.

5. **Output & Notification**

   * Results saved as `.txt` (all definitive results), plus `.html`, `.csv`, `.json` per host/service.
   * Optional summary sent to Slack/Discord webhook.
   * Log and error files included.
   * Cleans up temp files when done.

---

### **Example Interactive Session**

```
====== Masscannon Scanner ======
Do you have a file of IPs/subnets to scan? (y/n, default: n): n
Enter subnet to scan (default: 192.168.1.0/24): 10.0.0.0/24
Enter network interface (default: eth0): eth0
Enter scan rate (pps, default: 1000): 2000
Scan only the Nmap top 1000 TCP ports? (y/n, default: y): y
Include UDP scan with top 100 ports? (y/n, default: n): n
Enter output prefix (default: scan_output): lab_scan
Enable Slack/Discord webhook summary? (y/n): n
[*] Scan started at Mon May 27 10:30:00 EDT 2025
[*] Running Masscan on 10.0.0.0/24 ...
...
[*] 10.0.0.7 definitive open ports:
10.0.0.7 80/tcp   open  http        nginx 1.24.0
10.0.0.7 443/tcp  open  ssl/http    nginx 1.24.0
[*] Deep fingerprinting 10.0.0.7 port 80 (http-enum,http-title,http-headers,http-methods,http-server-header)
...
[*] Scan completed at Mon May 27 10:40:00 EDT 2025
[*] All output is saved with prefix: lab_scan
[*] Definitive results file: lab_scan_definitive_results.txt
```

---

## Output Files

* **`<prefix>_masscan.xml`** — Raw masscan results (XML)
* **`<prefix>_nmap_<ip>.nmap/.xml/.csv/.html/.json`** — Nmap results for each host
* **`<prefix>_nmap_<ip>_deep_<port>.nmap/.xml`** — Deep scan for each service/port
* **`<prefix>_definitive_results.txt`** — Master list of all real, validated open ports/services
* **`<prefix>_scan.log`** — Log of all actions
* **`<prefix>_errors.log`** — Error messages (if any)

---

## FAQ / Troubleshooting

**Q: Why do you ignore ambiguous ports?**
A: Ports marked as `tcpwrapped`, `unknown`, or with a `?` in the service are often false positives, WAF/proxy results, or intentional obfuscation. Scanning only bannered, real ports saves time and increases actionable signal.

**Q: Can I add more service/script mappings?**
A: Yes! See the `SERVICE_SCRIPTS` associative array in the script—just add more mappings.

**Q: Can I adjust thresholds or scan logic?**
A: Edit `HIGH_OPEN_PORTS_THRESHOLD` and `LOW_RATE` at the top of the script to tune when/if it slows down and retries.

---

## Credits

* [masscan](https://github.com/robertdavidgraham/masscan)
* [nmap](https://nmap.org/)
* Various nmap NSE script authors

---

## License

MIT License — free to use and modify. Attribution welcome but not required.

---

**Pull requests and improvements are welcome!**
For bug reports, feature requests, or contributions, open an issue or PR on [GitHub](https://github.com/yourusername/masscannon).
