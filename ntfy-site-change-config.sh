if [ -z "$1" ]; then
  echo "Usage: $0 <URL> [WAITTIME_SEC] [NTFY_POSTFIX]"
  exit 1
fi

DOMAIN=$1
DOMAIN_NO_DOTS=${DOMAIN//./}
DEFAULT_WAITTIME_SEC=60                     # For Loop Only
WAITTIME_SEC=${2:-$DEFAULT_WAITTIME_SEC}    # For Loop Only
DEFAULT_NTFY_POSTFIX=""
NTFY_POSTFIX=${3:-$DEFAULT_NTFY_POSTFIX}

URL="https://$DOMAIN"
REFERENCE_FILE="reference_content.txt"
NOTIFY_URL="https://ntfy.sh/$DOMAIN_NO_DOTS-site-change$NTFY_POSTFIX"
TEMP_FILE="current_content.txt"

echo "URL to watch for changes: $URL"
echo "URL to get notification on changes: $NOTIFY_URL"