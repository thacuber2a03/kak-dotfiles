if [ -z "$1" ]; then
	printf "error: no argument passed to $0" >&2
	exit 70
fi

umka -warn -check "$1" 2>&1 \
| awk '
	/^(Error|Warning) / {
		sev = $1
		sub(/^[^ ]+ /, "", $0)

		match($0, /(.*) \(([0-9]+), ([0-9]+)\): (.*)/, m)

		printf "%s:%s:%s: %s: %s \n", m[1], m[2], m[3], tolower(sev), m[4]
	}
'
