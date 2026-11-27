#!/usr/bin/env bash

erro() {
    yad --error --title="Erro" --text="$1" --width=350 --center
}

aviso() {
    yad --info --title="PokéGuard" --text="$1" --width=400 --center
}

tela_treinador() {
    local res nome poke

    while true; do
        res=$(yad --form \
            --title="PokéGuard" \
            --text="Identifique-se para entrar na Liga Pokémon:" \
            --field="Nome:" "" \
            --field="Pokémon Inicial:CB" "Pikachu!Charmander!Bulbasaur!Squirtle!Eevee" \
            --width=400 --center)

        if [[ $? -ne 0 ]]; then
            return 1
        fi

        IFS='|' read -r nome poke <<< "$res"

        if [[ -z "$nome" ]]; then
            erro "Coloca o nome aí!"
            continue
        fi

        aviso "Olá, $nome! O $poke foi escolhido como seu Pokémon inicial. Vamos proteger sua conta da Liga Pokémon!"
        echo "$nome|$poke"
        return 0
    done
}

tela_menu() {
    local user="$1" poke="$2"
    yad --list \
        --title="PokéGuard - Menu Principal" \
        --text="Treinador: <b>$user</b> | Parceiro: <b>$poke</b>" \
        --column="Opção" --column="Descrição" \
        "1. Gerar e Auditar Senhas" "Criar 3 senhas, auditar Leetspeak e ganhar Insígnias" \
        "2. Trocar Dicionário" "Escolher outro arquivo .txt de wordlist" \
        "3. Sobre o Sistema" "Ver regras das Insígnias e da Política Local" \
        "4. Sair" "Encerrar o PokéGuard" \
        --print-column=1 --hide-header \
        --width=550 --height=280 --center
}

tela_config() {
    yad --form \
        --title="Gerador de Senhas" \
        --text="Configure sua senha (0 = não usar):" \
        --field="Tamanho (6-18):NUM" "12!6..18!1" \
        --field="Minúsculas:NUM" "2!0..18!1" \
        --field="Maiúsculas:NUM" "2!0..18!1" \
        --field="Números:NUM" "2!0..18!1" \
        --field="Especiais:NUM" "1!0..18!1" \
        --width=400 --center
}

tela_senhas() {
    yad --list \
        --title="Relatório da Liga Pokémon" \
        --column="ID" --column="Senha" --column="Auditoria" --column="Insígnias" --column="Classificação" \
        "1" "$1" "$2" "$3" "$4" \
        "2" "$5" "$6" "$7" "$8" \
        "3" "$9" "${10}" "${11}" "${12}" \
        --button="Menu:0" \
        --button="Configurar:3" \
        --button="Gerar Novamente:2" \
        --width=920 --height=280 --center
}

tela_sobre() {
    yad --info \
        --title="Sobre o PokéGuard" \
        --text="<b>INSÍGNIAS:</b>\n🪨 Rocha: tamanho mínimo ok\n💧 Cascata: 2+ categorias de caracteres\n⚡ Trovão: fora do dicionário (com Leetspeak)\n🌈 Arco-Íris: todas as anteriores + mínimos\n\n<b>CLASSIFICAÇÃO:</b>\n❌ Reprovada: igual ao dicionário ou tamanho menor\n⚠️ Em observação: passou no básico, mas menor que 10 ou contém palavra fraca\n✅ Aprovada: Insígnia Arco-Íris + 10 ou mais caracteres\n\n" \
        --width=480 --center
}
