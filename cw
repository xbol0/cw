#!/bin/bash

set -e

fo="/tmp/$(basename $0).${RANDOM}"
_mode="raw"
_count=0

# Word list collections
# User, Repo, Branch/Tag, File, Description
_wl_df=(Bo0oM fuzz.txt master fuzz.txt "Potentially dangerous files.")
_wl_pw500=(TheKingOfDuck fuzzDicts master passwordDict/top500.txt "Weak passwords top 500.")
_wl_skw=(danielmiessler SecLists master Discovery/Variables/secret-keywords.txt "Secret keywords.")
_wl_sev=(danielmiessler SecLists master Discovery/Variables/awesome-environment-variable-names.txt "Secret env variables.")
_wl_sev=(danielmiessler SecLists master Discovery/Variables/awesome-environment-variable-names.txt "Secret env variables.")

_dl() {
	local _url

	if [[ $_mode == "raw" ]]; then
		_url=$(_to_raw_url "$@")
	elif [[ $_mode == "fastgit" ]]; then
		_url=$(_to_fastgit_url "$@")
	elif [[ $_mode == "raws" ]]; then
		_url=$(_to_raws_url "$@")
	else
		_url=$(_to_jsdelivr_url "$@")
	fi

	curl -fsSL "$_url" >$fo & 2>/dev/null
}

_to_raw_url() {
	echo "https://github.com/$1/$2/raw/$3/$4"
}

_to_fastgit_url() {
	echo "https://raw.fastgit.org/$1/$2/$3/$4"
}

_to_jsdelivr_url() {
	echo "https://cdn.jsdelivr.net/gh/$1/$2@$3/$4"
}

_to_raws_url() {
	echo "https://raw.githubusercontents.com/$1/$2/$3/$4"
}

_clean() {
	rm $fo
}

_show_help() {
	cat <<-EOF
Usage: $(basename $0) [-fhj] CATEGORY ...
For more information, visit: https://github.com/xbol0/cw.

Parameters:
  -h		Show help and category list.
  -f		Use fastgit CDN.
  -j		Use jsdelivr CDN.
  -s		Use githubusercontents CDN.

Categories:
  df		${_wl_df[4]} @${_wl_df[0]}/${_wl_df[1]}
  pw500		${_wl_pw500[4]} @${_wl_pw500[0]}/${_wl_pw500[1]}
  skw		${_wl_skw[4]} @${_wl_skw[0]}/${_wl_skw[1]}
  sev		${_wl_sev[4]} @${_wl_sev[0]}/${_wl_sev[1]}
EOF
}

_run() {
	if [[ $# == 0 ]]; then
		_show_help
		exit
	fi

	_args=($@)

	if [[ $_args[0] =~ ^- ]]; then

		# Show help messages.
		if [[ $_args[0] =~ h ]]; then
			_show_help
			exit
		fi

		# Use fastgit CDN
		if [[ $_args[0] =~ f ]]; then
			_mode="fastgit"
		fi

		# Use fastgit CDN
		if [[ $_args[0] =~ j ]]; then
			_mode="jsdelivr"
		fi

		# Use githubusercontents CDN
		if [[ $_args[0] =~ s ]]; then
			_mode="raws"
		fi

		_args=(${_args[@]:1})
	fi

	mkfifo $fo
	trap _clean SIGINT SIGTERM ERR EXIT

	
	for k in $_args;do
		eval _wl=($(echo \"\$\{_wl_${k}[@]\}\"))
		if [[ ${#_wl[@]} == 0 ]]; then
			continue
		fi

		_dl ${_wl[@]}
		_count=$((_count+1))
	done

	if (( $_count > 0 )); then
		uniq <$fo
	fi
    wait
}

_run $@
