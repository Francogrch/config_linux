#!/bin/bash

# Colores para el reporte
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   DEBIAN TRIXIE - SYSTEM PERFORMANCE REPORT (FRANCO)  ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# 1. USO DE CPU Y RAM
echo -e "\n${YELLOW}[1] CPU & RAM Status${NC}"
UPTIME=$(uptime -p)
RAM_USAGE=$(free -h | grep Mem | awk '{print "Used: "$3" / Total: "$2}')
LOAD=$(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
echo -e "Uptime: $UPTIME"
echo -e "Load Average (1/5/15 min): $LOAD"
echo -e "Memory: $RAM_USAGE"

# 2. ALMACENAMIENTO (STORAGE)
echo -e "\n${YELLOW}[2] Disk Space Usage (Top Partitions)${NC}"
df -h | grep -E '^/dev/' | awk '{print $1 ": " $5 " used (" $4 " free)"}'

# 3. PAQUETES PESADOS (APT)
echo -e "\n${YELLOW}[3] Top 5 Heaviest Packages (MB)${NC}"
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 5 | awk '{print $1/1024 " MB\t" $2}'

# 4. GPU STATUS (NVIDIA RTX 3080)
echo -e "\n${YELLOW}[4] NVIDIA GPU Status${NC}"
if command -v nvidia-smi &>/dev/null; then
  nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total --format=csv,noheader,nounits |
    awk -F', ' '{print "GPU Load: "$1"% | VRAM Usage: "$3"MB / "$4"MB"}'
else
  echo -e "${RED}NVIDIA Driver not detected or nvidia-smi missing.${NC}"
fi

# 5. DOCKER STATUS
echo -e "\n${YELLOW}[5] Docker Containers (Active)${NC}"
if command -v docker &>/dev/null; then
  RUNNING_CONTAINERS=$(docker ps --format "{{.Names}}" | wc -l)
  if [ "$RUNNING_CONTAINERS" -gt 0 ]; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
  else
    echo "No running containers."
  fi
else
  echo "Docker not installed."
fi

# 6. BOOT TIME ANALYSIS
echo -e "\n${YELLOW}[6] Last Boot Analysis${NC}"
systemd-analyze | awk -F'=' '{print "Total Boot Time: "$2}'

echo -e "\n${BLUE}=======================================================${NC}"
