#!/usr/bin/env bash

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dic="$dir/dados/wordlist.txt"

source "$dir/lib/validacao.sh"
source "$dir/lib/gerador.sh"
source "$dir/lib/dicionario.sh"
source "$dir/lib/interface.sh"

check_deps || exit 1

if [[ ! -f "$dic" ]]; then
    printf "pikachu\ncharmander\npokemon\npato\n123456\npassword\n" > "$dic"
fi

dados=$(tela_treinador)
[[ $? -ne 0 ]] && exit 0
IFS='|' read -r user poke <<< "$dados"

carregar_dic "$dic"

rodar_gerador() {
    while true; do
        cfg=$(tela_config)
        [[ $? -ne 0 ]] && return 0

        IFS='|' read -r tam q1 q2 q3 q4 <<< "$cfg"
        tam=${tam%%.*}
        q1=${q1%%.*}
        q2=${q2%%.*}
        q3=${q3%%.*}
        q4=${q4%%.*}

        msg=$(validar_tudo "$tam" "$q1" "$q2" "$q3" "$q4")
        if [[ $? -ne 0 ]]; then
            erro "$msg"
            continue
        fi

        while true; do
            mapfile -t s < <(gerar_tres "$tam" "$q1" "$q2" "$q3" "$q4")
            linhas=()

            for i in 0 1 2; do
                aud=$(auditar_senha "${s[$i]}")
                IFS='|' read -r st txt_aud <<< "$aud"

                av=$(avaliar_insignias "${s[$i]}" "$tam" "$q1" "$q2" "$q3" "$q4" "$st")
                IFS='|' read -r ins nota <<< "$av"

                linhas+=("${s[$i]}" "$txt_aud" "$ins" "$nota")
            done

            tela_senhas "${linhas[@]}"
            op=$?

            if [[ $op -eq 2 ]]; then
                continue
            elif [[ $op -eq 3 ]]; then
                break
            else
                return 0
            fi
        done
    done
}

while true; do
    op=$(tela_menu "$user" "$poke")
    [[ $? -ne 0 || -z "$op" || "$op" == "4"* ]] && exit 0

    case "$op" in
        "1"*) rodar_gerador ;;
        "2"*)
            novo=$(tela_wordlist)
            if [[ $? -eq 0 && -n "$novo" ]]; then
                dic="$novo"
                carregar_dic "$dic"
                aviso "Dicionário atualizado!"
            fi
            ;;
        "3"*) tela_sobre ;;
    esac
done
