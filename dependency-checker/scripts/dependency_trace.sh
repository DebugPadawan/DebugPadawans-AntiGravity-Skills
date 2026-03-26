#!/bin/bash
# Optimized dependency tracer for Linux/macOS
# Usage: ./dependency_trace.sh <Term> <Extension>

TERM=$1
EXT=$2

if [ -z "$TERM" ] || [ -z "$EXT" ]; then
    echo "Usage: $0 <Term> <Ext>"
    echo "Example: $0 'getUserData' '.js'"
    exit 1
fi

B_BLUE='\033[1;34m'
G='\033[0;32m'
O='\033[0;33m'
R='\033[0;31m'
NC='\033[0m'

echo -e "\n${B_BLUE}>>> 1. Direct References in *${EXT} files${NC}"
grep -rn --include="*${EXT}" "${TERM}" . | awk -F: -v t="${TERM}" '{printf "'$G'%-30s'$NC' L%-5s | %s\n", $1, $2, $3}'

echo -e "\n${B_BLUE}>>> 2. Module Import Impact${NC}"
grep -rl --include="*${EXT}" "${TERM}" . | xargs -n 1 basename | cut -f 1 -d '.' | sort -u | while read -r FILE; do
    [ -z "$FILE" ] && continue
    grep -rn --include="*${EXT}" "${FILE}" . | grep -v "${FILE}${EXT}" | awk -F: -v f="${FILE}" '{printf "'$O'%-30s'$NC' Imports: %-15s (L%s)\n", $1, f, $2}'
done

echo -e "\n${B_BLUE}>>> 3. Structural Risks (Shared State / Scope)${NC}"
FILES=$(grep -rl --include="*${EXT}" "${TERM}" .)
if [ ! -z "$FILES" ]; then
    grep -rnE "global|static|volatile|public|private|class" ${FILES} 2>/dev/null | awk -F: '{printf "'$R'%-30s'$NC' Risk: %-15s (L%s)\n", $1, $3, $2}'
fi
echo -e "\n${B_BLUE}Analysis Complete.${NC}"
