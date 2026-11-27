#!/usr/bin/env bash

declare -a lista_norm

normalizar() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed \
        -e 's/0/o/g' \
        -e 's/1/i/g' \
        -e 's/3/e/g' \
        -e 's/4/a/g' \
        -e 's/5/s/g' \
        -e 's/7/t/g' \
        -e 's/@/a/g' \
        -e 's/\$/s/g' \
        -e 's/!/i/g'
}

carregar_dic() {
    local arq="$1" linha norm
    lista_norm=()

    [[ ! -f "$arq" ]] && return 1

    while IFS= read -r linha; do
        linha="${linha//$'\r'/}"
        [[ -z "$linha" ]] && continue
        norm=$(normalizar "$linha")
        lista_norm+=("$norm")
    done < "$arq"
}

auditar_senha() {
    local s="$1" norm p
    norm=$(normalizar "$s")

    for p in "${lista_norm[@]}"; do
        if [[ "$norm" == "$p" ]]; then
            echo "EXATO|🚨 ALERTA: Igual ao dicionário ($p)"
            return 0
        fi
    done

    for p in "${lista_norm[@]}"; do
        if (( ${#p} >= 4 )) && [[ "$norm" == *"$p"* ]]; then
            echo "SUB|⚠️ ALERTA: Contém palavra fraca ($p)"
            return 0
        fi
    done

    echo "LIMPA|✅ Limpa (fora da lista)"
}

avaliar_insignias() {
    local s="$1" tam="$2" q1="$3" q2="$4" q3="$5" q4="$6" st="$7"
    local ins="" r=0 c=0 t=0 a=0

    if (( ${#s} >= tam )); then
        r=1
        ins+="🪨 Rocha "
    fi

    local cats=0
    local esp_reg='[^a-zA-Z0-9]'
    [[ "$s" =~ [a-z] ]] && ((cats++))
    [[ "$s" =~ [A-Z] ]] && ((cats++))
    [[ "$s" =~ [0-9] ]] && ((cats++))
    [[ "$s" =~ $esp_reg ]] && ((cats++))

    if (( cats >= 2 )); then
        c=1
        ins+="💧 Cascata "
    fi

    if [[ "$st" == "LIMPA" ]]; then
        t=1
        ins+="⚡ Trovão "
    fi

    local n1 n2 n3 n4 ok=1
    n1=$(echo -n "$s" | tr -cd 'a-z' | wc -c)
    n2=$(echo -n "$s" | tr -cd 'A-Z' | wc -c)
    n3=$(echo -n "$s" | tr -cd '0-9' | wc -c)
    n4=$(echo -n "$s" | tr -cd '!@#$%&*?-_=+' | wc -c)

    (( n1 < q1 || n2 < q2 || n3 < q3 || n4 < q4 )) && ok=0

    if (( r == 1 && c == 1 && t == 1 && ok == 1 )); then
        a=1
        ins+="🌈 Arco-Íris"
    fi

    [[ -z "$ins" ]] && ins="Nenhuma"

    local nota
    if [[ "$st" == "EXATO" || $r -eq 0 ]]; then
        nota="❌ Senha reprovada"
    elif (( a == 1 && ${#s} >= 10 )); then
        nota="✅ Senha aprovada pela política local"
    else
        nota="⚠️ Senha em observação"
    fi

    echo "$ins|$nota"
}
