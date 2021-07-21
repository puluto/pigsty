#!/usr/bin/env bash
set -uo pipefail

#==============================================================#
# File      :   get-isd-daily.sh
# Mtime     :   2020-08-10
# Desc      :   Get ISD daily Dataset
# Path      :   bin/get-isd-daily.sh
# Note      :   Data are donwloaed to ../data/daily/<YYYY>.tar.gz
# Author    :   Vonng(fengruohang@outlook.com)
# Depend    :   curl
# Usage     :   bin/get-isd-daily.sh <year>
#==============================================================#
PROG_DIR="$(cd $(dirname $0) && pwd)"
PROG_NAME="$(basename $0)"
PROJ_DIR=$(dirname $PROG_DIR)

function log_info (){
    [ -t 2 ] && printf "\033[0;32m[$(date "+%Y-%m-%d %H:%M:%S")][INFO] $*\033[0m\n" 1>&2 || printf "[$(date "+%Y-%m-%d %H:%M:%S")][INFO] $*\n" 1>&2
}

function get_daily_url(){
  local this_year=$(date '+%Y')
  local year=${1-${this_year}}
  echo "https://www.ncei.noaa.gov/data/global-summary-of-the-day/archive/${year}.tar.gz"
}


DATA_DIR="${PROJ_DIR}/data/daily"
mkdir -p ${DATA_DIR}

year=${1-$(date '+%Y')}
if (( year > 2030 )); then
  log_info "year ${this_year} overflow"
  exit 1
fi

if (( year < 1900 )); then
  log_info "year ${this_year} underflow"
    exit 1
fi

DATA_URL=$(get_daily_url ${year})
FILENAME=$(basename ${DATA_URL})

log_info "download ${DATA_URL} to ${DATA_DIR}/${FILENAME}"
cd ${DATA_DIR} && curl ${DATA_URL} -o ${FILENAME}

