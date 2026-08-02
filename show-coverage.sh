#!/bin/bash
# Display test coverage from lcov.info in human-readable format

echo "=== Test Coverage Summary ==="
echo ""

awk '
/^SF:/ { file = $0; gsub(/^SF:/, "", file); next }
/^LF:/ { lf = $0; gsub(/^LF:/, "", lf); next }
/^LH:/ { lh = $0; gsub(/^LH:/, "", lh); pct = lf > 0 ? int(lh/lf*1000)/10 : 0; printf "%-50s %3d/%-3d (%5.1f%%)\n", file, lh, lf, pct }
' coverage/lcov.info

echo ""
echo "=== Uncovered Lines (0 hits) ==="
echo ""

awk '
/^SF:/ { file = $0; gsub(/^SF:/, "", file); current_file = file; next }
/^DA:.*,0$/ {
  line_num = $0;
  gsub(/^DA:/, "", line_num);
  gsub(/,0$/, "", line_num);
  if (current_file != "") {
    files[current_file][line_num] = 1
  }
}
END {
  for (file in files) {
    print file ":"
    count = 0
    for (line in files[file]) {
      count++
    }
    if (count > 0) {
      n = split("", arr)
      for (line in files[file]) arr[++n] = line
      for (i = 1; i <= n; i++) {
        for (j = i + 1; j <= n; j++) {
          if (arr[i] > arr[j]) { tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp }
        }
      }
      for (i = 1; i <= n; i++) {
        printf "  Line %s\n", arr[i]
      }
    }
    print ""
  }
}
' coverage/lcov.info
