ips=$@

devs_cmd=$(echo '{"command": "devs"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]?] | join(",")')
temps_cmd=$(echo '{"command": "temps"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]?] | join(",")')
details_cmd=$(echo '{"command": "devdetails"}' | nc $ips 4028 | jq '.[]?[]? | join(",")' | jq -s '[.[]] | join(",")')

date_now=$(date -u --iso-8601=seconds)
csv_fmt="$date_now,$devs_cmd,$temps_cmd,$details_cmd"
echo "$csv_fmt"

echo $csv_fmt >> "$ips.csv"
