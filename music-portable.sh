#!/bin/bash
IFS="
"
for f in $(find Music); do
  if [ -d "$f" ]; then
    if [ ! -d "$(echo "$f" | sed 's/Music\//music-portable\//')" ]; then
      mkdir "$(echo "$f" | sed 's/Music\//music-portable\//')"
    fi
  fi

  if [ -f "$f" ]; then
    ext=$(echo "$f" | sed 's/.*\.//')
    pre_src=$(echo "$f" | sed 's/.[^.]*$//')
    dst=$(echo "$f" | sed 's/Music\//music-portable\//' | sed "s/$ext/mp3/")
    pre_dst=$(echo "$pre_src" | sed 's/Music\//music-portable\//')
    
    if [ ! "$ext" == "png" ] && [ ! "$ext" == "jpg" ] && [ ! "$ext" == "gif" ] && [ ! "$ext" == "zip" ] && [ ! "$ext" == "txt" ] && [ ! "$ext" == "m3u" ]; then
      if [ ! -e "$dst" ] || [ "$dst" -ot "$f" ]; then
        if [ "$ext" == "mp3" ]; then
          echo "$f is a $ext file, copying..."
          cp "$f" "$(echo "$f" | sed 's/Music\//music-portable\//')"
        else
          echo "$f is a $ext file, converting..."
          ffmpeg -loglevel panic -i "$f" -c:a libmp3lame -q:a 0 -y "$(echo "$f" | sed 's/Music\//music-portable\//' | sed "s/$ext/mp3/")"
        fi
      fi
    fi
  fi
done
