#!/usr/bin/env bash
mpn=""
description=""
url=""
box=""
bag=""
stencil=""
chrome_bin="google-chrome-stable"
logo=""
output="label.png"

print_help() {
    echo "Usage: $0 [option...]" >&2
    echo
    echo "   -m, --mpn                      Manufacturer Part Number"
    echo "   -d, --description              Description"
    echo "   -u, --url                      URL to use in qr code"
    echo "   -b, --box                      Box Identifier"
    echo "   -g, --bag                      Bag Identifier"
    echo "   -s, --stencil                  Stencil Identifier, use instead of bag"
    echo "   -l, --logo                     Provide alternate Logo"
    echo "   -o, --output                   Output file name"
    echo "   -c, --chrome                   Location of chrome binary"
    echo "   -h, --help                     This help message"
    echo
}

getopt -T &>/dev/null && rc=$? || rc=$?
if ((rc != 4)); then
    echo "This script requires gnu getopt" >&2
    exit 1
fi

jq --version  &>/dev/null
if (($? != 0)); then
    echo "This script requires jq" >&2
    exit 1
fi


VALID_ARGS=$(getopt --options m:d:q:b:g:s:c:l:u:o:h --longoptions mpn:,description:,url:,box:,bag:,chrome:,logo:,stencil:,output:,help -- "$@") || print_help

eval set -- "$VALID_ARGS"
while (($#)); do
  case "$1" in
    -m | --mpn)
        mpn=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -d | --description)
        description=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -u | --url)
        url=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -b | --box)
        box=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -g | --bag)
        bag=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -s | --stencil)
        stencil=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -c | --chrome)
        chrome_bin=$2
        shift 2
        ;;
    -l | --logo)
        logo=`printf %s "$2" | jq -sRr @uri`
        shift 2
        ;;
    -o | --output)
        output=$2
        shift 2
        ;;
    -h | --help)
        print_help
        exit 0
        ;;
    --) shift;
        break
        ;;
  esac
done

${chrome_bin} --version  &>/dev/null
if (($? != 0)); then
    echo "This script requires a version of chrome/chromium" >&2
    exit 1
fi

# warn user that label infromation not provided
if [ -z "${mpn}" ] || [ -z "${url}" ]; then
    echo "MPN or URL not provided."
    echo
    print_help
fi

query_string="mpn=${mpn}&qr=${url}"
if [ -n "${description}"  ]; then
    query_string="${query_string}&description=${description}"
fi
if [ -n "${box}"  ]; then
    query_string="${query_string}&box=${box}"
fi
if [ -n "${bag}"  ]; then
    query_string="${query_string}&bag=${bag}"
fi
if [ -z "${bag}"  ] && [ -n "${stencil}" ]; then
    query_string="${query_string}&stencil=${stencil}"
fi
if [ -n "${logo}"  ]; then
    query_string="${query_string}&logo=${logo}"
fi

${chrome_bin} --headless=new --disable-gpu --screenshot=${output}  --virtual-time-budget=2 \
    "file:///$(pwd)/crump-label-template.html?${query_string}"
