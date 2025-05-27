#!/bin/bash

# ───── Banner ───────────────────────────────────────────────────────────────────────
echo "░  ░░░░  ░░░      ░░░░      ░░░░      ░░░░      ░░░░      ░░░   ░░░  ░░   ░░░  ░░░      ░░░   ░░░  ░"
echo "▒   ▒▒   ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒▒    ▒▒  ▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒"
echo "▓        ▓▓  ▓▓▓▓  ▓▓▓      ▓▓▓▓      ▓▓▓  ▓▓▓▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓▓  ▓  ▓  ▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓"
echo "█  █  █  ██        ████████  ████████  ██  ████  ██        ██  ██    ██  ██    ██  ████  ██  ██    █"
echo "█  ████  ██  ████  ███      ████      ████      ███  ████  ██  ███   ██  ███   ███      ███  ███   █"
echo ""
echo "====== Masscannon Scanner ======"

# ───── Dependency Check ─────────────────────────────────────────────────────────────
for cmd in masscan nmap xsltproc python3; do
    command -v $cmd >/dev/null 2>&1 || { echo "[ERROR] $cmd not found. Please install it."; exit 1; }
done
python3 -c "import xmltodict" 2>/dev/null || { echo "[ERROR] Python3 module xmltodict missing. Install with: pip3 install xmltodict"; exit 1; }

# Nmap top 1000 TCP ports (comma-separated, full list)
NMAP_TOP_1000_PORTS="1,3,4,6,7,9,13,17,19,20,21,22,23,24,25,26,30,32,33,37,42,49,53,70,79,80,81,82,83,84,85,88,89,90,99,100,106,109,110,111,113,119,125,135,139,143,144,146,161,163,179,199,211,212,222,254,255,256,259,264,280,301,306,311,340,366,389,406,407,416,417,425,427,443,444,445,458,464,465,481,497,500,512,513,514,515,524,541,543,544,545,548,554,555,563,587,593,616,617,625,631,636,646,648,666,667,668,683,687,691,700,705,711,714,720,722,726,749,765,777,783,787,800,801,808,843,873,880,888,898,900,901,902,903,911,912,981,987,990,992,993,995,999,1000,1001,1002,1007,1009,1010,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1137,1138,1141,1145,1147,1148,1149,1151,1152,1154,1163,1164,1165,1166,1169,1174,1175,1183,1185,1186,1187,1192,1198,1199,1201,1213,1216,1217,1218,1233,1234,1236,1244,1247,1248,1259,1271,1272,1277,1287,1296,1300,1301,1309,1310,1311,1322,1328,1334,1352,1417,1433,1434,1443,1455,1461,1494,1500,1501,1503,1521,1524,1525,1529,1533,1556,1580,1583,1594,1600,1641,1658,1666,1687,1688,1700,1717,1718,1719,1720,1721,1723,1755,1761,1782,1801,1805,1812,1839,1840,1862,1863,1864,1875,1900,1914,1935,1947,1971,1972,1974,1984,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2013,2020,2021,2022,2030,2033,2034,2035,2038,2040,2041,2042,2043,2045,2046,2047,2048,2049,2065,2068,2099,2100,2103,2105,2106,2107,2111,2119,2121,2126,2135,2144,2160,2170,2179,2190,2191,2196,2200,2222,2251,2260,2288,2301,2323,2366,2381,2382,2393,2394,2399,2401,2492,2500,2522,2525,2557,2601,2602,2604,2605,2607,2608,2638,2701,2702,2710,2717,2718,2725,2800,2809,2811,2869,2875,2909,2910,2920,2967,2998,3000,3001,3003,3005,3006,3007,3011,3013,3017,3030,3031,3050,3052,3071,3077,3128,3168,3211,3221,3260,3268,3269,3283,3300,3301,3306,3322,3323,3324,3325,3333,3351,3367,3369,3370,3371,3389,3390,3404,3476,3493,3517,3527,3546,3551,3580,3659,3689,3690,3703,3737,3766,3784,3800,3801,3809,3814,3826,3827,3828,3851,3869,3871,3878,3880,3889,3905,3914,3918,3920,3945,3971,3986,3995,3998,4000,4001,4002,4003,4004,4005,4045,4111,4125,4126,4129,4224,4242,4279,4321,4343,4443,4444,4445,4446,4449,4550,4567,4662,4848,4899,4998,5000,5001,5002,5003,5004,5009,5030,5033,5050,5051,5054,5060,5061,5080,5087,5100,5101,5102,5120,5190,5200,5214,5221,5222,5225,5226,5269,5280,5298,5357,5405,5414,5432,5440,5500,5510,5544,5550,5555,5560,5566,5631,5632,5633,5666,5678,5679,5718,5730,5800,5801,5802,5810,5811,5815,5822,5825,5850,5859,5862,5877,5900,5901,5902,5903,5904,5906,5907,5910,5911,5915,5922,5960,5961,5962,5987,5988,5998,5999,6000,6001,6002,6003,6004,6005,6006,6007,6009,6025,6059,6100,6101,6106,6112,6123,6129,6156,6346,6389,6502,6510,6543,6547,6566,6567,6580,6646,6666,6667,6668,6669,6689,6692,6699,6776,6777,6788,6789,6792,6839,6881,6901,6969,7000,7001,7002,7004,7007,7019,7025,7070,7100,7103,7106,7200,7402,7435,7443,7496,7512,7625,7627,7676,7741,7777,7800,7911,7920,7921,7937,7938,7999,8000,8001,8002,8007,8008,8009,8010,8011,8021,8022,8031,8042,8045,8080,8081,8082,8083,8084,8085,8086,8087,8088,8089,8090,8093,8099,8100,8180,8181,8192,8194,8200,8222,8254,8290,8291,8292,8300,8333,8383,8400,8402,8443,8500,8600,8649,8651,8652,8654,8701,8800,8834,8880,8883,8888,8899,8994,9000,9001,9002,9003,9009,9010,9040,9050,9071,9080,9081,9090,9091,9099,9100,9101,9102,9103,9110,9111,9200,9207,9220,9290,9415,9418,9485,9500,9502,9503,9535,9600,9666,9876,9877,9878,9898,9900,9917,9929,9943,9944,9968,9998,9999,10000,10001,10002,10003,10004,10009,10010,10012,10024,10025,10082,10180,10200,10215,10243,10566,10616,10617,10621,10626,10628,10629,10778,11110,11111,11967,12000,12174,12265,12345,13456,13722,13782,13783,14000,14238,14441,14442,15000,15002,15003,15004,15660,15742,16000,16001,16012,16016,16018,16080,16113,16992,16993,17877,17988,18040,18101,18988,19101,19283,19315,19780,19801,19842,20000,20005,20031,20221,20222,20828,21571,22939,23502,24444,24800,25734,25735,26214,27000,27352,27353,27355,27356,27715,28201,30000,30718,30951,31038,31337,32768,32769,32770,32771,32772,32773,32774,32775,32776,32777,32778,32779,38037,38292,40193,48080,49152,49153,49154,49155,49156,49157,49158,49159,49160,49161,49163,49165,49167,49175,49176,49400,49999,50000,50001,50002,50003,50006,50300,50389,50500,50636,50800,51103,51493,52673,52822,52848,52869,54045,54328,55055,55056,55555,55600,56737,56738,57294,57797,58080,60020,60443,61532,61900,62078,63331,64623,64680,65000,65129,65389"

# ───── User Input ──────────────────────────────────────────────────────────────────
read -rp "Do you have a file of IPs/subnets to scan? (y/n, default: n): " HAS_FILE
HAS_FILE=${HAS_FILE:-n}

if [[ "$HAS_FILE" =~ ^[Yy]$ ]]; then
    read -rp "Enter file path (one IP/subnet per line): " TARGET_FILE
    if [[ ! -f "$TARGET_FILE" ]]; then
        echo "[ERROR] File does not exist!"
        exit 1
    fi
    TARGET_ARG="-iL $TARGET_FILE"
    TARGET_DESC="$TARGET_FILE"
else
    read -rp "Enter subnet to scan (default: 192.168.1.0/24): " SUBNET
    SUBNET=${SUBNET:-192.168.1.0/24}
    TARGET_ARG="$SUBNET"
    TARGET_DESC="$SUBNET"
fi

read -rp "Enter network interface (default: eth0): " INTERFACE
INTERFACE=${INTERFACE:-eth0}

read -rp "Enter scan rate (pps, default: 1000): " RATE
RATE=${RATE:-1000}

# Nmap Top 1000 Prompt
read -rp "Scan only the Nmap top 1000 TCP ports? (y/n, default: y): " TOP_1000
TOP_1000=${TOP_1000:-y}

if [[ "$TOP_1000" =~ ^[Yy]$ ]]; then
    MASSCAN_PORTS="$NMAP_TOP_1000_PORTS"
    echo "[*] Using Nmap top 1000 TCP ports."
else
    read -rp "Enter TCP port range (default: 1-65535): " MASSCAN_PORTS
    MASSCAN_PORTS=${MASSCAN_PORTS:-1-65535}
fi

read -rp "Include UDP scan with top 100 ports? (y/n, default: n): " DO_UDP
DO_UDP=${DO_UDP:-n}

read -rp "Enter output prefix (default: scan_output): " OUTPUT_PREFIX
OUTPUT_PREFIX=${OUTPUT_PREFIX:-scan_output}

read -rp "Enable Slack/Discord webhook summary? (y/n): " DO_WEBHOOK
if [[ "$DO_WEBHOOK" =~ ^[Yy]$ ]]; then
    read -rp "Enter Webhook URL: " WEBHOOK_URL
fi

LOG_FILE="${OUTPUT_PREFIX}_scan.log"
ERROR_LOG="${OUTPUT_PREFIX}_errors.log"
MASSCAN_OUT="${OUTPUT_PREFIX}_masscan.xml"
NMAP_OUT_PREFIX="${OUTPUT_PREFIX}_nmap"
TMP_IP_PORT_LIST="tmp_targets.lst"
DEFINITIVE_MASTER="${OUTPUT_PREFIX}_definitive_results.txt"

: > "$LOG_FILE"
: > "$ERROR_LOG"
: > "$DEFINITIVE_MASTER"

echo "[*] Scan started at $(date)" | tee -a "$LOG_FILE"

# ───── Masscan with Auto-Retry at Lower Rate ───────────────────────────────────────
HIGH_OPEN_PORTS_THRESHOLD=100
LOW_RATE=100

run_masscan_with_auto_rate() {
    local subnet="$1"
    local port_range="$2"
    local iface="$3"
    local rate="$4"
    local out_xml="$5"
    local input_file="$6"

    local attempt=1
    while :; do
        if [[ -n "$input_file" ]]; then
            masscan -iL "$input_file" -p"$port_range" -e "$iface" --rate "$rate" -oX "$out_xml"
        else
            masscan "$subnet" -p"$port_range" -e "$iface" --rate "$rate" -oX "$out_xml"
        fi

        local open_ports
        open_ports=$(grep -o 'portid="' "$out_xml" | wc -l)

        echo "[*] Masscan (rate: $rate pps) found $open_ports open ports." | tee -a "$LOG_FILE"

        if (( open_ports > HIGH_OPEN_PORTS_THRESHOLD && rate > LOW_RATE && attempt == 1 )); then
            echo "[!] High number of open ports ($open_ports) detected—possible WAF/false positives or scan too fast." | tee -a "$LOG_FILE"
            echo "[*] Slowing scan rate from $rate to $LOW_RATE and rescanning for accuracy..." | tee -a "$LOG_FILE"
            rm -f "$out_xml"
            rate=$LOW_RATE
            attempt=$((attempt+1))
        else
            break
        fi
    done
}

echo "[*] Running Masscan on $TARGET_DESC ..." | tee -a "$LOG_FILE"
if [[ "$HAS_FILE" =~ ^[Yy]$ ]]; then
    run_masscan_with_auto_rate "" "$MASSCAN_PORTS" "$INTERFACE" "$RATE" "$MASSCAN_OUT" "$TARGET_FILE" || {
        echo "[ERROR] Masscan failed" | tee -a "$ERROR_LOG"
        exit 1
    }
else
    run_masscan_with_auto_rate "$SUBNET" "$MASSCAN_PORTS" "$INTERFACE" "$RATE" "$MASSCAN_OUT" "" || {
        echo "[ERROR] Masscan failed" | tee -a "$ERROR_LOG"
        exit 1
    }
fi

# ───── Parse Masscan Output for IP:Port pairs ──────────────────────────────────────
echo "[*] Parsing masscan results..." | tee -a "$LOG_FILE"

python3 << EOF > "$TMP_IP_PORT_LIST"
import xml.etree.ElementTree as ET
tree = ET.parse("$MASSCAN_OUT")
root = tree.getroot()
results = {}
for host in root.findall('host'):
    ip = host.find('address').get('addr')
    for port in host.findall('ports/port'):
        portid = port.get('portid')
        results.setdefault(ip, set()).add(portid)
for ip, ports in results.items():
    print(f"{ip} {' '.join(sorted(ports, key=int))}")
EOF

if [[ ! -s "$TMP_IP_PORT_LIST" ]]; then
    echo "[*] No hosts with open ports found! Exiting." | tee -a "$LOG_FILE"
    [[ -f "$MASSCAN_OUT" ]] && rm -f "$MASSCAN_OUT"
    exit 0
fi

# ───── Nmap per Host with Ambiguous Logic ──────────────────────────────────────────
while read -r line; do
    IP=$(echo "$line" | awk '{print $1}')
    PORTS=$(echo "$line" | cut -d' ' -f2- | tr ' ' ',')
    OUT="${NMAP_OUT_PREFIX}_${IP//./_}"

    echo "[+] Fast scan $IP on ports: $PORTS" | tee -a "$LOG_FILE"

    nmap -Pn -sS -sV --version-intensity 5 --max-retries 3 -T3 -n -p "$PORTS" -oA "$OUT" "$IP" 2>>"$ERROR_LOG" || {
        echo "[!] Nmap failed on $IP" >> "$ERROR_LOG"
        continue
    }

    xsltproc "$OUT.xml" -o "$OUT.html" 2>/dev/null
    grep -E 'Ports:|open' "$OUT.gnmap" | sed 's/Ignored.*//g' > "$OUT.csv"
    python3 -c "import xmltodict, json; f=open('$OUT.xml'); print(json.dumps(xmltodict.parse(f.read()), indent=2))" > "$OUT.json"

    # Parse nmap output for definite and ambiguous ports
    DEFINITE_FILE="${OUT}_definites.txt"
    AMBIGUOUS_FILE="${OUT}_ambiguous.lst"
    : > "$DEFINITE_FILE"
    : > "$AMBIGUOUS_FILE"

    while read -r nmap_line; do
        if [[ "$nmap_line" =~ ^[0-9]+/tcp[[:space:]]+open[[:space:]] ]]; then
            # If ambiguous, log for rescanning
            if [[ "$nmap_line" =~ \?|tcpwrapped|unknown ]]; then
                PORT=$(echo "$nmap_line" | awk '{print $1}' | cut -d/ -f1)
                echo "$PORT" >> "$AMBIGUOUS_FILE"
            else
                echo "$IP $nmap_line" >> "$DEFINITE_FILE"
            fi
        fi
    done < <(awk '/^[0-9]+\/tcp/ && /open/ {print}' "$OUT.nmap")

    cat "$DEFINITE_FILE" >> "$DEFINITIVE_MASTER"

    # If ambiguous ports, rescan them slowly
    if [[ -s "$AMBIGUOUS_FILE" ]]; then
        SLOW_PORTS=$(paste -sd, "$AMBIGUOUS_FILE")
        OUT_SLOW="${OUT}_slow"
        echo "[*] Rescanning $IP ambiguous ports ($SLOW_PORTS) slowly..." | tee -a "$LOG_FILE"
        nmap -Pn -sS -sV --version-intensity 9 --max-retries 10 -T1 -n -p "$SLOW_PORTS" -oA "$OUT_SLOW" "$IP" 2>>"$ERROR_LOG"
        while read -r slow_line; do
            if [[ "$slow_line" =~ ^[0-9]+/tcp[[:space:]]+open[[:space:]] ]]; then
                if [[ "$slow_line" =~ \?|tcpwrapped|unknown ]]; then
                    echo "[?] Still ambiguous: $IP $slow_line" | tee -a "$LOG_FILE"
                else
                    echo "$IP $slow_line" >> "$DEFINITE_FILE"
                fi
            fi
        done < <(awk '/^[0-9]+\/tcp/ && /open/ {print}' "$OUT_SLOW.nmap")
        cat "$DEFINITE_FILE" >> "$DEFINITIVE_MASTER"
    fi

    # Print summary of results for this host
    echo "[*] $IP definitive open ports:" | tee -a "$LOG_FILE"
    cat "$DEFINITE_FILE" | tee -a "$LOG_FILE"
    if [[ -s "$AMBIGUOUS_FILE" ]]; then
        echo "[*] $IP ambiguous ports (see rescanned results above)" | tee -a "$LOG_FILE"
        cat "$AMBIGUOUS_FILE" | tee -a "$LOG_FILE"
    fi

done < "$TMP_IP_PORT_LIST"

# ───── Optional UDP Scan (Basic) ───────────────────────────────────────────────────
if [[ "$DO_UDP" =~ ^[Yy]$ ]]; then
    cut -d ' ' -f1 "$TMP_IP_PORT_LIST" | sort -u > udp_hosts.txt
    while read -r IP; do
        OUT="${NMAP_OUT_PREFIX}_UDP_${IP//./_}"
        echo "[+] Scanning UDP on $IP" | tee -a "$LOG_FILE"
        nmap -Pn -sU --top-ports 100 -n -oA "$OUT" "$IP" 2>>"$ERROR_LOG" || {
            echo "[!] UDP Nmap failed on $IP" >> "$ERROR_LOG"
            continue
        }
        xsltproc "$OUT.xml" -o "$OUT.html" 2>/dev/null
        grep -E 'Ports:|open' "$OUT.gnmap" | sed 's/Ignored.*//g' > "$OUT.csv"
        python3 -c "import xmltodict, json; f=open('$OUT.xml'); print(json.dumps(xmltodict.parse(f.read()), indent=2))" > "$OUT.json"
    done < udp_hosts.txt
fi

# ───── Master Definitive Results Summary ───────────────────────────────────────────
echo -e "\n====== All Definitive Results ======" | tee -a "$LOG_FILE"
if [[ -s "$DEFINITIVE_MASTER" ]]; then
    cat "$DEFINITIVE_MASTER" | tee -a "$LOG_FILE"
else
    echo "No definitive results found." | tee -a "$LOG_FILE"
fi

# ───── Summary Generation ──────────────────────────────────────────────────────────
TOTAL_HOSTS=$(wc -l < "$TMP_IP_PORT_LIST")
TOTAL_PORTS=$(awk '{ for(i=2;i<=NF;i++) c++ } END { print c }' "$TMP_IP_PORT_LIST")
echo "[*] $TOTAL_HOSTS hosts found with open ports." | tee -a "$LOG_FILE"
echo "[*] $TOTAL_PORTS open TCP ports found." | tee -a "$LOG_FILE"
if [[ -s "$ERROR_LOG" ]]; then
    ERRORS="Errors occurred! See $ERROR_LOG."
else
    ERRORS="No errors encountered."
fi

SUMMARY="Masscannon scan complete. 
Targets: $TARGET_DESC
Hosts with open ports: $TOTAL_HOSTS
Open TCP ports: $TOTAL_PORTS
$ERRORS"

# ───── Webhook Notification ────────────────────────────────────────────────────────
if [[ "$DO_WEBHOOK" =~ ^[Yy]$ && -n "$WEBHOOK_URL" ]]; then
    curl -s -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$SUMMARY\"}" "$WEBHOOK_URL"
fi

# ───── Cleanup ─────────────────────────────────────────────────────────────────────
rm -f tmp_ips.txt tmp_ports.txt "$TMP_IP_PORT_LIST" grouped_targets.txt udp_hosts.txt 2>/dev/null

echo "[*] Scan completed at $(date)" | tee -a "$LOG_FILE"
echo "[*] All output is saved with prefix: $OUTPUT_PREFIX"
echo "[*] Definitive results file: $DEFINITIVE_MASTER"
