#!/bin/bash
# Dedicated to the public domain under the CC0 1.0 Universal (CC0 1.0) Public
# Domain Dedication: https://creativecommons.org/publicdomain/zero/1.0/
set -o errexit
set -o errtrace
set -o nounset


if command -v gsed >/dev/null
then
    SED=gsed
elif sed --version >/dev/null
then
    SED=sed
else
    echo 'GNU sed is required. If on macOS install `gnu-sed` via brew.' 1>&2
    exit 1
fi


function _remove_deprecated_links_meta_from_html_files {
    printf "\e[1m\e[7m %-80s\e[0m\n" \
        'Remove deprected links and meta from HTML files'
    for _file in $(find docs -type f -name '*.html')
    do
        #  1. Remove link: WordPress Edit URI
        #  2. Remove link: WordPress JSON API
        #  3. Remove link: WordPress xmlrpc.php
        #  4. Remove link: WordPress shortlink
        #  5. Remove link: WordPress Windows Live Writer Manifest link
        #  6. Remove meta: generator
        ${SED} \
            -e'/^<link rel="EditURI"/d' \
            -e'/^<link .*\/wp-json\//d' \
            -e'/^<link .*"\/xmlrpc.php/d' \
            -e"/^<link rel='shortlink'/d" \
            -e'/^<link rel="wlwmanifest"/d' \
            -e'/^<meta name="generator"/d' \
            --in-place "${_file}"
    done
    echo
}


function _remove_google_analytics {
    printf "\e[1m\e[7m %-80s\e[0m\n" \
        'Remove Google Analytics'
    for _file in $(find docs -type f -name '*.html')
    do
        ${SED} \
            --null-data \
            -e's#<!-- Begin Google.*<!-- End Google Analytics -->##' \
            --in-place "${_file}"
    done
    echo
}


function _cleanup_plaintext_whitespace {
    printf "\e[1m\e[7m %-80s\e[0m\n" 'Clean-up whitespace in plaintext files'
    # plaintext files with trailing whitespace
    for _file in $(find docs -type f \
        \( -name '*.css' -o -name '*.html' -o -name '*.js' \))
    do
        ${SED} -e's#[ \t]\+$##' --in-place "${_file}"
    done
    echo
}


# Change directory to repository root
cd "${0%/*}/.." >/dev/null
# Run clean-up functions
_remove_deprecated_links_meta_from_html_files
_remove_google_analytics
_cleanup_plaintext_whitespace
