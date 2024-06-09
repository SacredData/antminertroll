ips=$@

devs_header=$(echo '{"command": "devs"}' | nc $ips 4028 | jq '.[]?[]? |keys_unsorted| join(",")' | jq -s '[.[]?] | join(",")')
echo "$devs_header"
devs_cmd=$(echo '{"command": "devs"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]?] | join(",")')
temps_header=$(echo '{"command": "temps"}' | nc $ips 4028 | jq '.[]?[]? |keys_unsorted| join(",")' | jq -s '[.[]?] | join(",")')
echo "$temps_header"
temps_cmd=$(echo '{"command": "temps"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]?] | join(",")')
details_header=$(echo '{"command": "devdetails"}' | nc $ips 4028 | jq '.[]?[]? |keys_unsorted| join(",")' | jq -s '[.[]] | join(",")')
echo "$details_header"
details_cmd=$(echo '{"command": "devdetails"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]] | join(",")')

if [ ! -f "$ips.csv" ]; then
  header_fmt="Datetime,$devs_header,$temps_header,$details_header"
  echo "${header_fmt//\"/}" > "$ips.csv"
fi

date_now=$(date -u --iso-8601=seconds)
csv_fmt="$date_now,$devs_cmd,$temps_cmd,$details_cmd"
echo "${csv_fmt//\"/}"

echo "${csv_fmt//\"/}" >> "$ips.csv"
