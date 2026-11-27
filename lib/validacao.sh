#!/usr/bin/env bash

check_deps() {
    for c in yad shuf tr fold; do
        command -v "$c" >/dev/null || return 1
    done
}

validar_tudo() {
    local tam="$1" q1="$2" q2="$3" q3="$4" q4="$5"

    if (( tam < 6 || tam > 18 )); then
        echo "Tamanho tem que ser entre 6 e 18!"
        return 1
    fi

    local soma=$(( q1 + q2 + q3 + q4 ))

    if (( soma == 0 )); then
        echo "Coloca pelo menos 1 caractere em alguma categoria!"
        return 1
    fi

    if (( soma > tam )); then
        echo "A soma dos mínimos ($soma) passou do tamanho ($tam)!"
        return 1
    fi

    return 0
}
