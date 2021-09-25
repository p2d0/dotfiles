
function make-youtube-clip -d "Download trim and copy to clipboard youtube video"
    if test (count $argv) -eq 0;
        echo "make-youtube-clip
        [-s/--start START]
        [-l/length LENGTH of the clip]
        [-e/end end of the clip]
        [--nosubs]
        [--realsubs Real subs instead of autogenerated] URL"
        return;
    end
    argparse 'h/help' 's/start=' 'l/length=' 'e/end=' 'realsubs' 'nosubs' -- $argv
    set fontsize 35
    if set -q _flag_help;
        echo "make-youtube-clip
        [-s/--start START]
        [-l/length LENGTH of the clip]
        [-e/end end of the clip]
        [--nosubs]
        [--realsubs Real subs instead of autogenerated] URL"
        return;
    end

    cd /tmp

    if set -q _flag_realsubs
        echo "Real subs"
        youtube-dl --write-sub --sub-lang en --no-continue $argv[1] -o tmp_vid.mp4 -f mp4
    else if set -q _flag_nosubs
        youtube-dl --no-continue $argv[1] -o tmp_vid.mp4 -f mp4
    else
        echo "Auto generated subs"
        youtube-dl --write-auto-sub --no-continue $argv[1] -o tmp_vid.mp4 -f mp4
        python3 $HOME/.zsh-scripts/clean_youtube_dl_auto_subs.py tmp_vid.en.vtt > tmp_vid.vtt;
    end

    if set -q _flag_start; and begin set -q _flag_length; or set -q _flag_end; end;
        if set -q _flag_length
            echo "Length based ffmpeg"
            ffmpeg -ss $_flag_start -i tmp_vid.mp4 -t $_flag_length -vf subtitles=tmp_vid.vtt:force_style="FontSize=$fontsize" -c:v libx264 -x264-params crf=22 -preset fast -profile:v high tmp_vid_out.mp4
        else if set -q _flag_end
            echo "Timestamp based ffmpeg"
            ffmpeg -i tmp_vid.mp4 -ss $_flag_start -to $_flag_end -vf subtitles=tmp_vid.vtt:force_style="FontSize=$fontsize" -c:v libx264 -x264-params crf=22 -preset fast -profile:v high tmp_vid_out.mp4
        end
        mv tmp_vid_out.mp4 tmp_vid.mp4
    end

    clip-files tmp_vid.mp4
    notify-send "Youtube clip created"
    prevd
end
