#!/usr/bin/env bash

# Exit codes
declare -r EC_ERROR=1               # General error
declare -r EC_MISUSE=2              # Misuse of shell builtins
declare -r EC_IO_ERROR=3            # File I/O error
declare -r EC_EACCESS=96            # The file permissions do not allow the attempted operation
declare -r EC_ENOENT=97             # No such file or directory
declare -r EC_PARAM=98              # Not enough parameters passed
declare -r EC_UNEXECUTABLE=126      # Permission problem or command is not an executable
declare -r EC_ILLEGAL_CMD=127       # Command not found
declare -r EC_INVAL_EXIT=128        # Invalid argument to exit
declare -r EC_FATAL_SIGNAL_BASE=128 # Base value for fatal error signal "n"
declare -r EC_SIGINT=130            # Script terminated by Control-C
declare -r EC_SIGQUIT=131           # SIGQUIT
declare -r EC_SIGKILL=137           # Killed by SIGKILL
declare -r EC_SIGTERM=143           # SIGTERM
declare -r EC_OUTOFRANGE=255        # Exit status out of range

is_dir()
{
    [ -d "${1}" ]
}

is_file()
{
    [ -f "${1}" ]
}

is_symlink()
{
    [ -L "${1}" ]
}

is_existing()
{
    [ -e "${1}" ]
}

is_tty()
{
    [ -t "${1}" ]
}

is_readable()
{
    [ -r "${1}" ]
}

is_readable_file()
{
    [ -f "${1}" ] && [ -r "${1}" ]
}

is_writeable()
{
    [ -w "${1}" ]
}

is_executable()
{
    [ -x "${1}" ]
}

is_empty()
{
    [ -z "${1}" ]
}

is_set()
{
    [ -n "${1}" ]
}

is_number()
{
    [[ "${1}" =~ ^-?[0-9]+$ ]]
}

is_positive_number()
{
    [[ "${1}" =~ ^[0-9]+$ ]]
}

is_negative_number()
{
    [[ "${1}" =~ ^-[0-9]+$ ]]
}

is_substring()
{
    echo "${1}" | grep -qF "${2}"
}

has_command()
{
    command -v "${1}" &> /dev/null
}

kill_all_by_name()
{
    if has_command killall; then
        killall "${1}" &> /dev/null
    else
        ps -e | grep "${1}" | awk '{print $1;}' | xargs kill -9 &> /dev/null
    fi
}

is_root()
{
    if is_number "${1:-$UID}"; then
        [ "${1:-$UID}" -eq 0 ]
    else
        [ "$(id -u ${1} 2> /dev/null)" = 0 ]
    fi
}

# Check if a function existing
is_func_existing()
{
    declare -F "$1" > /dev/null;
}

is_python2()
{
    [ "$(python -c 'import sys; print(sys.version_info[0])' 2> /dev/null)" = 2 ]
}

is_python3()
{
    [ "$(python -c 'import sys; print(sys.version_info[0])' 2> /dev/null)" = 3 ]
}

to_lower()
{
    echo "${@}" | tr '[A-Z]' '[a-z]'
}

to_upper()
{
    echo "${@}" | tr '[a-z]' '[A-Z]'
}

# Join elements with delimiter
join_by()
{
    local d="${1}"; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}

prefix_by()
{
    local d="${1}"; shift; printf "%s" "${@/#/$d}";
}

suffix_by()
{
    local d="${1}"; shift; printf "%s" "${@/%/$d}";
}

# Absolute value
abs()
{
    [ "${1}" -lt 0 ] && echo "$((-${1}))" || echo "${1}"
}

# Absolute path
abspath()
{
    readlink -nf "${1}" 2> /dev/null
}

# Absolute dir
absdir()
{
    dirname -z $(readlink -nf "${1}") 2> /dev/null
}

BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"
UNDERLINED="\033[4m"
BLINK="\033[5m"
RAPID_BLINK="\033[6m"
REVERSE="\033[7m"
HIDDEN="\033[8m"
CROSSED_OUT="\033[9m"

NORMAL="\033[0m"
RESET_ALL="${NORMAL}"
RESET_BOLD="\033[21m"
RESET_DIM="\033[22m"
RESET_ITALIC="\033[23m"
RESET_UNDERLINED="\033[24m"
RESET_BLINK="\033[25m"
RESET_RAPID_BLINK="\033[26m"
RESET_REVERSE="\033[27m"
RESET_HIDDEN="\033[28m"
RESET_CROSSED_OUT="\033[29m"
RESET_FG="\033[39m"
RESET_BG="\033[49m"

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
SILVER="\033[37m"

BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_SILVER="\033[47m"

GREY="\033[90m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"
LIGHT_YELLOW="\033[93m"
LIGHT_BLUE="\033[94m"
LIGHT_MAGENTA="\033[95m"
LIGHT_CYAN="\033[96m"
WHITE="\033[97m"

BG_GREY="\033[100m"
BG_LIGHT_RED="\033[101m"
BG_LIGHT_GREEN="\033[102m"
BG_LIGHT_YELLOW="\033[103m"
BG_LIGHT_BLUE="\033[104m"
BG_LIGHT_MAGENTA="\033[105m"
BG_LIGHT_CYAN="\033[106m"
BG_WHITE="\033[107m"

declare -A COLORS

COLORS[bold]=1
COLORS[dim]=2
COLORS[italic]=3
COLORS[underlined]=4
COLORS[blink]=5
COLORS[rapid blink]=6
COLORS[reverse]=7
COLORS[hidden]=8
COLORS[crossed out]=9

COLORS[reset all]=0
COLORS[reset bold]=21
COLORS[reset dim]=22
COLORS[reset italic]=23
COLORS[reset underlined]=24
COLORS[reset blink]=25
COLORS[reset rapid blink]=26
COLORS[reset reverse]=27
COLORS[reset hidden]=28
COLORS[reset crossed out]=29
COLORS[reset fg]=39
COLORS[reset bg]=49

COLORS[black]=30
COLORS[red]=31
COLORS[green]=32
COLORS[yellow]=33
COLORS[blue]=34
COLORS[magenta]=35
COLORS[cyan]=36
COLORS[silver]=37

COLORS[bg black]=40
COLORS[bg red]=41
COLORS[bg green]=42
COLORS[bg yellow]=43
COLORS[bg blue]=44
COLORS[bg magenta]=45
COLORS[bg cyan]=46
COLORS[bg silver]=47

COLORS[grey]=90
COLORS[light red]=91
COLORS[light green]=92
COLORS[light yellow]=93
COLORS[light blue]=94
COLORS[light magenta]=95
COLORS[light cyan]=96
COLORS[white]=97

COLORS[bg grey]=100
COLORS[bg light red]=101
COLORS[bg light green]=102
COLORS[bg light yellow]=103
COLORS[bg light blue]=104
COLORS[bg light magenta]=105
COLORS[bg light cyan]=106
COLORS[bg white]=107

combine()
{
    local names=()
    while [ "${#}" -gt 0 ]; do
        if [ -n "${COLORS[${1}]}" ]; then
            names+=("${COLORS[${1}]}")
        fi
        shift
    done
    local esc=''
    if [ -n "${names}" ]; then
        esc+='\033['
        esc+=$(join_by ';' "${names[@]}")
        esc+='m'
    fi
    echo "${esc}"
}

redful()
{
    printf "${RED}%s${NORMAL}" "${*}"
}

boldredful()
{
    printf "$(combine 'bold' 'red')%s${NORMAL}" "${*}"
}

greenful()
{
    printf "${GREEN}%s${NORMAL}" "${*}"
}

boldgreenful()
{
    printf "$(combine 'bold' 'green')%s${NORMAL}" "${*}"
}

yellowful()
{
    printf "${YELLOW}%s${NORMAL}" "${*}"
}

boldyellowful()
{
    printf "$(combine 'bold' 'yellow')%s${NORMAL}" "${*}"
}

blueful()
{
    printf "${BLUE}%s${NORMAL}" "${*}"
}

boldblueful()
{
    printf "$(combine 'bold' 'blue')%s${NORMAL}" "${*}"
}

pusage()
{
    printf "USAGE: %s\n" "${*}" >&2
}

# Display message and pause
pause()
{
    echo "${*}"
    read -s -n1 -p "Press any key to continue.."
}

die()
{
    local ec="${1:-0}"; shift
    [ "${#}" -gt 0 ] && log_error "${@:-}"
    exit "$ec"
}

set_trap_handler()
{
    local func="${1}" sig; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

on_trapped()
{
    local num name
    if is_number "${1}"; then
        num="${1}"
        name=$(kill -l "${1}")
    else
        name="${1}"
        num=$(kill -l "${1}")
    fi
    log_info "Interrupted by signal $name"
    exit "$((EC_FATAL_SIGNAL_BASE + num))"
}

# Interrupted script by SIGHUP SIGINT SIGQUIT SIGTERM
sigtrap()
{
    set_trap_handler on_trapped SIGHUP SIGINT SIGQUIT SIGTERM
}

__log_field_delimiter=': '
__log_headers=()
# __log_levelname=true
# __log_datetime=true

log_header_push()
{
    while [ "${#}" \> 0 ]; do
        __log_headers["${#__log_headers[@]}"]="${1}"
        shift
    done
}

log_header_pop()
{
    if [ "${#__log_headers[@]}" \> 0 ]; then
        unset __log_headers["${#__log_headers[@]}"-1]
    fi
}

log_fatal()
{
    local line=$(join_by "${__log_field_delimiter}" ${__log_levelname:+FATAL} ${__log_datetime:+"$(date +'%Y-%m-%dT%H:%M:%S%z')"} "${__log_headers[@]}" "${@}")
    if is_tty 2; then
        line="${RED}${line}${NORMAL}"
    fi
    echo -e "${line}" >&2
}

log_error()
{
    local line=$(join_by "${__log_field_delimiter}" ${__log_levelname:+ERROR} ${__log_datetime:+"$(date +'%Y-%m-%dT%H:%M:%S%z')"} "${__log_headers[@]}" "${@}")
    if is_tty 2; then
        line="$(combine 'bold' 'red')${line}${NORMAL}"
    fi
    echo -e "${line}" >&2
}

log_warning()
{
    local line=$(join_by "${__log_field_delimiter}" ${__log_levelname:+WARNING} ${__log_datetime:+"$(date +'%Y-%m-%dT%H:%M:%S%z')"} "${__log_headers[@]}" "${@}")
    if is_tty 2; then
        line="${BOLD}${YELLOW}${line}${NORMAL}"
    fi
    echo -e "${line}" >&2
}

log_info()
{
    local line=$(join_by "${__log_field_delimiter}" ${__log_levelname:+INFO} ${__log_datetime:+"$(date +'%Y-%m-%dT%H:%M:%S%z')"} "${__log_headers[@]}" "${@}")
    if is_tty 1; then
        line="${BOLD}${line}${NORMAL}"
    fi
    echo -e "${line}" >&1
}

log_debug()
{
    local line=$(join_by "${__log_field_delimiter}" ${__log_levelname:+DEBUG} ${__log_datetime:+"$(date +'%Y-%m-%dT%H:%M:%S%z')"} "${__log_headers[@]}" "${@}")
    echo -e "${line}" >&1
}

peval()
{
    local rs rv
    rs=$(eval "${1}" 2>&1); rv="${?}"
    if [ "$rv" != 0 ]; then
        log_error "${@:2:${#}}" "${1}" "[$rv]" "$rs"
        return "$rv"
    fi
    echo -n "$rs"
}

# Eval quiet unless output to stderr when error occurs
pevalq()
{
    local rs rv
    rs=$(eval "${1}" 2>&1 1> /dev/null); rv="${?}"
    if [ "$rv" != 0 ]; then
        log_error "${@:2:${#}}" "${1}" "[$rv]" "$rs"
        return "$rv"
    fi
}
