#/usr/bin/env bash

# bspc query -D --names
# bspc query -N -n .window
# | xargs -I % sh -c 'bspc query -T -n % | jq .'
# bspc query -T -n 0x03A00004 | jq .

windows=$(bspc query -N -n .window)
# windows=0x03A00004

while read -r window; do
  bspc node -f $window
  desktop_name=$(bspc query -D -d --names)
  windows_dict+=([$window]=$desktop_name)
  bspc node -d ^1
done <<< "$windows"

echo ${windows_dict[@]}

sleep 3

while read -r window; do
  echo "$window"
  bspc node -f $window
  bspc node -d ^${windows_dict[$window]}
  echo "window_id=$window is on desktop=${windows_dict[$window]}"
done <<< "$windows"

bspc desktop -f ^2


