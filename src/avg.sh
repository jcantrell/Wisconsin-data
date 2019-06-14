head -n -1 | tail -n 8 | awk '{ total += $1; count++ } END { print total/count }'
