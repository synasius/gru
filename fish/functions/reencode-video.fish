function reencode-video --description 'Reencode video with proper compression and codec' --argument extension
  mkdir -p old
  for f in (ls *.$extension)
    set -l basname (basename $f .$extension)
    mv $f old/$f
    ffmpeg -i old/$f -c:v libx265 -crf 28 -preset medium -vf format=yuv420p -c:a aac -map_metadata 0 -movflags +faststart $basname.mp4
  end
end
