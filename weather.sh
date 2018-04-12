# This is an edit of the script by r3donnx to show weather information on the Mac's touchbar
	# using BetterTouchTool. It processes plaintext from what is supposed to be an XML.


#!/bin/sh
w_xml=$(curl --silent "https://weather.tuxnet24.de/?id=560743&amp;mode=xml");
# w_txt=$(xmllint --xpath "string(//current_text)" - <<<"$w_xml" | xargs);
# awk '$1 == "current_text" {w_txt=$3}' - <<< "$w_xml" | xargs
# "$w_xml" > awk '/current_text/ {echo $3}'
line=$(echo "$w_xml" | grep current_text)
words=( $line )
w_txt=${words[2]}
# w_tpc=$(xmllint --xpath "string(//current_temp)"  - <<<"$w_xml" | xargs); w_tpc=${w_tpc//[[:blank:]]/};
# awk '/current_temp/ {w_tpc=$3}' - <<< "$w_xml" | xargs
line=$(echo "$w_xml" | grep current_temp)
words=( $line )
w_tpc=${words[2]}

if   [ "$w_txt" == "Sunny" ]; then w_sym="☼";
elif [ "$w_txt" == "Mostly Sunny" ]; then w_sym="☼";
elif [ "$w_txt" == "Showers" ]; then w_sym="☂";
elif [ "$w_txt" == "Clear" ]; then w_sym="☾";
elif [ "$w_txt" == "Thunderstorms" ]; then w_sym="⚡";
elif [ "$w_txt" == "Scattered Thunderstorms" ]; then w_sym="☔";
elif [ "$w_txt" == "Isolated Thundershovers" ]; then w_sym="☔";
elif [ "$w_txt" == "Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Mostly Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Partly Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Breezy" ]; then w_sym="⚐";
else w_sym=$w_txt; 
fi
echo "$w_sym"" ""$w_tpc";
