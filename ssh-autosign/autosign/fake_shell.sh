#!/bin/sh

USER=$(whoami)
echo "Ciao $USER!"

if [ ! -f ~/.google_authenticator ]; then
     google-authenticator -t -d -f -r 3 -R 30 -W
     exit
fi

if [ ! -f ~/.ssh/authorized_keys-cert.pub ]; then
    echo -n "Firmo la chiave: "
    if ssh-keygen -s /sshCA/unigeSSH_CA -I $USER -n $USER -V +60d ~/.ssh/authorized_keys ; then
       cat ~/.ssh/authorized_keys-cert.pub
    else
       echo " errore"
       echo "Procedure interrotta."
       exit
    fi
else
    echo "Faccio un check se ancora valida"
    v=$(ssh-keygen -L -f ~/.ssh/authorized_keys-cert.pub | grep Valid)

    start=$(echo "$v" | grep -oP 'from \K[0-9T:-]+')
    end=$(echo "$v" | grep -oP 'to \K[0-9T:-]+')

    # Converti in secondi epoch
    start_epoch=$(date -d "$start" +%s)
    end_epoch=$(date -d "$end" +%s)
    now_epoch=$(date +%s)

    # Verifica se attualmente valida
    if [ "$now_epoch" -lt "$start_epoch" ]; then
        echo "NON ancora valida (inizia in futuro)"
        exit 1
    elif [ "$now_epoch" -gt "$end_epoch" ]; then
        echo "Scaduta"
        exit 1
    else
        echo "Valida ORA"
        # Calcola giorni rimanenti
        seconds_left=$((end_epoch - now_epoch))
        days_left=$(awk -v s="$seconds_left" 'BEGIN { print int((s + 86399) / 86400) }')
        echo "Scade tra $days_left giorni"
        cat ~/.ssh/authorized_keys-cert.pub
    fi
fi
