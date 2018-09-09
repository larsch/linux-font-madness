#!/bin/sh
font=Monaco
boldfont=$font
size=10
fg=white
bg=black

function run() {
    echo $*
    if [ $1 == "emacs" ]; then
	"$@" text.txt &
    else
	"$@" /bin/sh -c "cat text.txt && read" &
    fi
    pid=$!
    sleep 0.5
    [ $1 != "emacs" ] || sleep 0.5
    fn=${font}_${size}_$1.png
    scrot -z temp.png
    kill $pid
    mkdir -p images
    convert temp.png -crop 576x96+4+25 "images/$fn"
    rm temp.png
}

function testall() {
    run xterm +sb -s -fa "$font-$size" -fb "$boldfont-$size" -fg $fg -bg $bg -e
    run urxvt +sb -fn "xft:$font-$size" -fb "xft:$boldfont-$size" -fg $fg -bg $bg -e
    # run kitty -o font_family=$font -o font_size=$size -o bold_font=$boldfont -o foreground=$fg -o background=$bg
    run emacs -q -D --no-splash -fn "$font-$size" -bg $bg -fg $fg -ib 0 -bw 0
}

rm -f *.png
rm -f images/*.png
xrdb -load </dev/null


for font in Monaco Consolas Monospace "Noto Sans Mono" "Bitstream Vera Sans Mono"; do
    boldfont=$font
    for size in 10 11 12; do
	testall
    done
done

xrdb < ~/.Xresources
echo done

ruby generate_readme.rb > README.md
