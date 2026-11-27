#!/usr/bin/env bash

pegar_chars() {
    local pool="$1" qtd="$2" out="" i r
    for (( i=0; i<qtd; i++ )); do
        r=$(( RANDOM % ${#pool} ))
        out+="${pool:r:1}"
    done
    echo "$out"
}

gerar_uma() {
    local tam="$1" q1="$2" q2="$3" q3="$4" q4="$5"
    local min="abcdefghijklmnopqrstuvwxyz"
    local mai="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local num="0123456789"
    local esp="!@#$%&*?-_=+"
    local base="" tudo="" falta

    if (( q1 > 0 )); then
        tudo+="$min"
        base+=$(pegar_chars "$min" "$q1")
    fi
    if (( q2 > 0 )); then
        tudo+="$mai"
        base+=$(pegar_chars "$mai" "$q2")
    fi
    if (( q3 > 0 )); then
        tudo+="$num"
        base+=$(pegar_chars "$num" "$q3")
    fi
    if (( q4 > 0 )); then
        tudo+="$esp"
        base+=$(pegar_chars "$esp" "$q4")
    fi

    falta=$(( tam - ${#base} ))
    (( falta > 0 )) && base+=$(pegar_chars "$tudo" "$falta")

    echo "$base" | fold -w1 | shuf | tr -d '\n'
    echo ""
}

gerar_tres() {
    for i in 1 2 3; do
        gerar_uma "$@"
    done
}
