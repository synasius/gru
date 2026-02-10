function reencode-video \
    --description 'Reencode video with proper compression and codec' \
    --argument extension

    set -l destination (pwd)/reencoded
    set -l crf 23

    mkdir -p $destination

    for f in (ls **/*.$extension)
        set -l basname (basename $f .$extension)
        set -l dirnam (dirname $f)
        set -l targetdir $destination/$dirnam
        set -l targetfile $targetdir/$basname".mp4"

        mkdir -p $targetdir

        ffmpeg -i $f -copy_unknown -map_metadata 0 -map 0 \
            -codec:v libx265 -pix_fmt yuv420p -crf $crf \
            -codec:a aac -loglevel 16 \
            -preset medium -movflags +faststart \
            $targetfile

        exiftool -tagsFromFile $f \
            -extractEmbedded -all:all \
            -FileModifyDate \
            -overwrite_original $targetfile
    end
end
