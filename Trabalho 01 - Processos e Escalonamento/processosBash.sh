#!/bin/bash

echo "[Pai] Iniciado (PID: $$)"
pids=()

# fork()
for i in {1..8}; do
    (
        # Expõe o PID do subshell
        echo "[Filho $i] Iniciado (PID: $BASHPID)"

        # Simula CPU burst idêntico para forçar concorrência no escalonador
        for j in {1..500000}; do :; done

        # Processo sai definindo seu código de retorno
        exit $i
    ) &

    # Salva os PIDs na ordem de criação
    pids+=($!)
done

echo -e "\nOrdem de criação (PIDs): ${pids[*]}"
echo -e "Aguardando filhos...\n"

# wait() +  Código de Retorno
# '-n' wait(NULL), retorna no PRIMEIRO filho que terminar.
# '-p' salva o PID do filho que acabou de terminar.
for _ in {1..8}; do
    wait -n -p pid_finalizado
    cod_retorno=$?
    echo "[Pai] Término capturado -> PID: $pid_finalizado | Código (ID Original): $cod_retorno"
done
