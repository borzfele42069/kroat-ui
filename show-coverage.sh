#!/bin/bash
# Display test coverage from lcov.info in human-readable format

awk '
/^SF:/ { file = $0; gsub(/^SF:/, "", file); next }
/^LF:/ { lf = $0; gsub(/^LF:/, "", lf); next }
/^LH:/ { lh = $0; gsub(/^LH:/, "", lh); pct = lf > 0 ? int(lh/lf*1000)/10 : 0; printf "%-50s %3d/%-3d (%5.1f%%)\n", file, lh, lf, pct }
' coverage/lcov.info
