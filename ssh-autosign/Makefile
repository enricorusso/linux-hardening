.PHONY: build start stop build-autosign build-fakeserver start-autosign start-fakeserver stop-autosign stop-fakeserver

build-autosign:
	docker build ./autosign/ -f ./autosign/Containerfile -t autosign

build-fakeserver:
	docker build ./fakeserver/ -f ./fakeserver/Containerfile -t fakeserver

build: build-autosign build-fakeserver

start-autosign:
	docker run -d --rm -p 2222:2222 --hostname autenticazione-SSH-UNIGE -v ./sshCA:/sshCA:ro --name autosign autosign

start-fakeserver:
	docker run -d --rm -p 2223:2222 --hostname fakeserverSSH -v ./sshCA/unigeSSH_CA.pub:/etc/ssh/user_ca.pub:ro --name fakeserver fakeserver 
start: start-autosign start-fakeserver

stop-autosign:
	docker rm -f autosign

stop-fakeserver:
	docker rm -f fakeserver

stop: stop-autosign stop-fakeserver

genkey:
	ssh-keygen -t ed25519 -f sshCA/unigeSSH_CA -C "Autenticazione SSH UNIGE"
