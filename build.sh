#!/bin/bash
#
# Compile script for kernel
# Copyright (C) 2022 Craft Rom.

SECONDS=0 # builtin bash timer

#Set Color
blue='\033[0;34m'
grn='\033[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
txtbld=$(tput bold)
txtrst=$(tput sgr0) 

DATE=$(date '+%Y-%m-%d  %H:%M')
HOME_DIR="craftrom"

# Telegram setup
push_message() {
    curl -s -X POST \
         https://api.telegram.org/bot5579959772:AAHJ1cvfipl05kxYhNQBvLy7b60vGmeQSRE/sendMessage \
        -d chat_id="-1001695676652" \
        -d text="$1" \
        -d "parse_mode=html" \
        -d "disable_web_page_preview=true"
}

push_document() {
    curl -s -X POST \
         https://api.telegram.org/bot5579959772:AAHJ1cvfipl05kxYhNQBvLy7b60vGmeQSRE/sendDocument \
        -F chat_id="-1001695676652" \
        -F document=@"$1" \
        -F caption="$2" \
        -F "parse_mode=html" \
        -F "disable_web_page_preview=true"
}

push_message "<b>Build bot is running.</b>
<b>Date:</b> <code>$DATE</code>"
cd $HOME/$HOME_DIR

for device in onclite surya; do

    mkdir -p $HOME/$HOME_DIR/chidori/$device
    
(
	echo -e "$blue    \nStarting kernel compilation for $device\n $nocol"
	LOG="build-$device.log"
	BUILD_DATE=$(date '+%Y-%m-%d  %H:%M')
	 # Push message if build started
push_message "<b>Start building kernel for <code>$device</code></b>
<b>BuildDate:</b> <code>$BUILD_DATE</code>"
	 cd $HOME/$HOME_DIR/chidori/$device 
	 bash build.sh -n -l | tee $LOG
push_document "$LOG" "
<b>Kernel for <code>$device</code> compiled succesfully!</b>
Total build time <b>$((SECONDS / 60))</b> minute(s) and <b>$((SECONDS % 60))</b> second(s) !

#logs #$device "
)
done
