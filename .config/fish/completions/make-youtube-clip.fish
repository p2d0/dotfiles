complete -c make-youtube-clip -s h -l help -d 'Print help' -x
complete -c make-youtube-clip -s s -l start -d 'START of the clip in format 00:00:00' -x -a "00:00:00"
complete -c make-youtube-clip -s e -l end -d 'END of the clip in format 00:00:00' -x -a "00:00:00"
complete -c make-youtube-clip -s l -l length -d 'LENGTH of the clip in seconds' -x
complete -c make-youtube-clip -l realsubs -d 'Use realsubs instead of autogenerated' -x
