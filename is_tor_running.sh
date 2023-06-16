if ps -A | grep -w tor; then
    echo "TOR IS RUNNING."
else
    echo "TOR IS NOT RUNNING."
fi