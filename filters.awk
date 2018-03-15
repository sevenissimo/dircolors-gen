#!/usr/bin/awk

# Globals
BEGIN {
	split("black:red:green:yellow:blue:magenta:cyan:white", colors, ":") #def array
}

# Helper functions
function expand(list, str) {
	split(list, arr, ":");
	for (i in arr) str = str sprintf(".%-5s %s\n", arr[i], $2)
	$0 = str
}

function each(keyword, str) {
	split($2, arr, ":");
	for (i in arr) str = str sprintf("%s %s\n", keyword, arr[i])
	$0 = str
}


# Main
# Convert litteral color strings to ANSI color codes.
{
	# Attribute codes
	sub(/(normal|default|none)/, "0", $2)
	sub(/(bold|bright)/,         "1", $2)
	sub(/under(score|lined?)/,   "4", $2)
	sub(/(blink|warn|alert)/,    "5", $2)
	sub(/reversed/,              "7", $2)
	sub(/concealed/,             "8", $2) # WTF is that?

	# Background color {40..47}
	for (i in colors) sub(","colors[i], ";"(39+i), $2)

	# Text color codes {30..37}
	for (i in colors) sub(colors[i], (29+i), $2)
}

# Process special keywords
/^\$/ {
	     if (/\$TERMS/) each("TERM")
	else if (/\$SH/)  expand("sh:csh:zhs")
	else if (/\$TXT/) expand("txt:TXT:org:md:mkd")
	else if (/\$CFG/) expand("conf:cfg:ini:INI:pacnew")
	else if (/\$EXE/) expand("cmd:exe:EXE:com:bat:BAT:reg:app")
	else if (/\$DEV/) expand("h:c:cc:cxx:objc:el:vim:java:pl:pm:py:rb:hs:php:htm:html:xml:rdf:css:js:man:pod:tex:awk:sed")
	else if (/\$ZIP/) expand("apk:arj:bin:bz:bz2:cab:deb:dmg:gem:gz:iso:jar:msi:rar:rpm:tar:tbz:tbz2:tgz:tx:war:xpi:xz:z:zip")
	else if (/\$IMG/) expand("bmp:cgm:dl:dvi:emf:eps:gif:jpeg:jpg:mng:pbm:pcx:pgm:png:ppm:pps:ppsx:ps:psd:svg:svgz:tga:tif:tiff:xbm:xcf:xpm:xwd:xwd:yuv")
	else if (/\$AUD/) expand("aac:au:flac:mid:midi:mka:mp3:mpa:mpeg:mpg:ogg:ra:wav")
	else if (/\$VID/) expand("anx:asf:avi:axv:flc:fli:flv:gl:m2v:m4v:mkv:mov:mp4:mp4v:mpeg:mpg:nuv:ogm:ogv:ogx:qt:rm:rmvb:swf:vob:wmv")
	else if (/\$DOC/) expand("doc:docx:rtf:dot:dotx:xls:xlsx:ppt:pptx:fla:pdf")
	else if (/\$LOG/) expand("0:log:bak:old:off:dist:orig:swp:swo")
}

# Print, if not pre-processor comment.
!/#!/ {
	print
}
