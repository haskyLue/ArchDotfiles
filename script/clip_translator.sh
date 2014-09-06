xsel -b | xargs -I {} sdcv -n --utf8-output -u '朗道英汉字典5.0' {} | xargs -0 -I {} notify-send {}
xsel -c
