#!/usr/bin/env bash
# Builds index.html from the pieces in src/.
# The published workbook is one self-contained file — this concatenates the parts
# in order, then closes the <script>/<body>/<html> tags the shell leaves open.
set -euo pipefail
cd "$(dirname "$0")"

PARTS="src/qr.js src/relay.js src/data.js src/network.js src/render.js src/events-and-exports.js src/systems-check.js"

cat $PARTS > .bundle.tmp.js
node --check .bundle.tmp.js
cat src/shell.html .bundle.tmp.js > index.html
printf '</script>\n</body>\n</html>\n' >> index.html
rm -f .bundle.tmp.js
echo "Built index.html ($(wc -c < index.html) bytes) — JavaScript syntax OK"
