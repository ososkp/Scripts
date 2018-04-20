# This is an edit of the script by r3donnx to show weather information on the Mac's touchbar
	# using BetterTouchTool. It processes plaintext from what is supposed to be an XML.


#!/bin/sh
w_xml=$(curl --silent "https://weather.tuxnet24.de/?id=560743&amp;mode=xml");
line=$(echo "$w_xml" | grep current_text)
words=( $line )
w_txt=${words[2]}

if [ "$w_txt" == "Mostly" ]; then w_helper=${words[3]};
fi

line=$(echo "$w_xml" | grep current_temp)
words=( $line )
w_tpc=${words[2]}

if   [ "$w_txt" == "Sunny" ]; then w_sym="☼";
elif [ "$w_txt" == "Mostly" ] && [ "$w_helper" == "Sunny" ]; then w_sym="☼";
elif [ "$w_txt" == "Showers" ]; then w_sym="☂";
elif [ "$w_txt" == "Clear" ]; then w_sym="☾";
elif [ "$w_txt" == "Thunderstorms" ]; then w_sym="⚡";
elif [ "$w_txt" == "Scattered Thunderstorms" ]; then w_sym="☔";
elif [ "$w_txt" == "Isolated Thundershovers" ]; then w_sym="☔";
elif [ "$w_txt" == "Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Mostly" ] && [ "$w_helper" == "Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Partly Cloudy" ]; then w_sym="☁";
elif [ "$w_txt" == "Partly" ]; then w_sym="☁";
elif [ "$w_txt" == "Breezy" ]; then w_sym="⚐";
else w_sym=$w_txt; 
fi
echo "$w_sym"" ""$w_tpc";