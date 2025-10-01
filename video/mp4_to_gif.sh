ffmpeg -y -i video.mp4 \
-filter_complex "[0:v]split[v1][v2]; \
 [v2]palettegen=max_colors=256:stats_mode=full[p]; \
 [v1][p]paletteuse=dither=sierra2_4a:diff_mode=rectangle" \
-r 30 -loop 0 output.gif

# convert mp4 video to a high quality gif