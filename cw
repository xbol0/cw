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
_wl_fmcomm=(adamtlangley ffufme main app/public/wordlist/common.txt "ffuf.me common list.")
_wl_fmparam=(adamtlangley ffufme main app/public/wordlist/parameters.txt "ffuf.me parameters list.")
_wl_fmsubdm=(adamtlangley ffufme main app/public/wordlist/subdomains.txt "ffuf.me subdomains list.")
_wl_xssbs=(TheKingOfDuck fuzzDicts master easyXssPayload/easyXssPayload.txt "XSS payload basic.")
_wl_xssbp=(TheKingOfDuck fuzzDicts master easyXssPayload/burpXssPayload.txt "XSS payload burp.")
_wl_xssmd=(TheKingOfDuck fuzzDicts master easyXssPayload/markdown-xss-payload.txt "XSS payload markdown.")
_wl_spring=(TheKingOfDuck fuzzDicts master spring/spring-configuration-metadata.txt "Spring config meta.")
_wl_ssrfconf=(TheKingOfDuck fuzzDicts master ssrfDicts/config.txt "SSRF config file.")
_wl_lkeyf=(TheKingOfDuck fuzzDicts master ssrfDicts/linux常见路径.txt "Linux key files.")
_wl_uname500=(TheKingOfDuck fuzzDicts master userNameDict/top500.txt "User name top 500.")
_wl_cnln300=(TheKingOfDuck fuzzDicts master userNameDict/top300_lastname.txt "Chinese last name top 300.")
_wl_sqli1=(TheKingOfDuck fuzzDicts master sqlDict/sql.txt "SQL inject.")
_wl_fn10k=(TheKingOfDuck fuzzDicts master directoryDicts/fileName10000.txt "Filenames.")
_wl_headers1=(devploit dontgo403 main payloads/headers "HTTP headers.")
_wl_methods1=(devploit dontgo403 main payloads/httpmethods "HTTP request methods.")
_wl_paramss=(s0md3v Arjun master arjun/db/small.txt "HTTP request parameters small.")
_wl_paramsm=(s0md3v Arjun master arjun/db/medium.txt "HTTP request parameters medium.")
_wl_paramsl=(s0md3v Arjun master arjun/db/large.txt "HTTP request parameters large.")
_wl_ofdb1=(weedcookie OWASP-FAVICON-database main HASHS.TXT "OWASP favicon database.")
_wl_wmun=(3had0w Fuzzing-Dicts master Webmanage-Username.txt "Web manage username.")

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
  df			${_wl_df[4]} @${_wl_df[0]}/${_wl_df[1]}
  pw500			${_wl_pw500[4]} @${_wl_pw500[0]}/${_wl_pw500[1]}
  skw			${_wl_skw[4]} @${_wl_skw[0]}/${_wl_skw[1]}
  sev			${_wl_sev[4]} @${_wl_sev[0]}/${_wl_sev[1]}
  fmcomm		${_wl_fmcomm[4]} @${_wl_fmcomm[0]}/${_wl_fmcomm[1]}
  fmparam		${_wl_fmparam[4]} @${_wl_fmparam[0]}/${_wl_fmparam[1]}
  fmsubdm		${_wl_fmsubdm[4]} @${_wl_fmsubdm[0]}/${_wl_fmsubdm[1]}
  xssbs			${_wl_xssbs[4]} @${_wl_xssbs[0]}/${_wl_xssbs[1]}
  xssbp			${_wl_xssbp[4]} @${_wl_xssbp[0]}/${_wl_xssbp[1]}
  xssmd			${_wl_xssmd[4]} @${_wl_xssmd[0]}/${_wl_xssmd[1]}
  spring		${_wl_spring[4]} @${_wl_spring[0]}/${_wl_spring[1]}
  ssrfconf		${_wl_ssrfconf[4]} @${_wl_ssrfconf[0]}/${_wl_ssrfconf[1]}
  lkeyf			${_wl_lkeyf[4]} @${_wl_lkeyf[0]}/${_wl_lkeyf[1]}
  uname500		${_wl_uname500[4]} @${_wl_uname500[0]}/${_wl_uname500[1]}
  cnln300		${_wl_cnln300[4]} @${_wl_cnln300[0]}/${_wl_cnln300[1]}
  sqli1			${_wl_sqli1[4]} @${_wl_sqli1[0]}/${_wl_sqli1[1]}
  fn10k			${_wl_fn10k[4]} @${_wl_fn10k[0]}/${_wl_fn10k[1]}
  headers1		${_wl_headers1[4]} @${_wl_headers1[0]}/${_wl_headers1[1]}
  methods1		${_wl_methods1[4]} @${_wl_methods1[0]}/${_wl_methods1[1]}
  paramss		${_wl_paramss[4]} @${_wl_paramss[0]}/${_wl_paramss[1]}
  paramsm		${_wl_paramsm[4]} @${_wl_paramsm[0]}/${_wl_paramsm[1]}
  paramsl		${_wl_paramsl[4]} @${_wl_paramsl[0]}/${_wl_paramsl[1]}
  ofdb1 	    	${_wl_ofdb1[4]} @${_wl_ofdb1[0]}/${_wl_ofdb1[1]}
  wmun1 	    	${_wl_wmun[4]} @${_wl_wmun[0]}/${_wl_wmun[1]}
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
