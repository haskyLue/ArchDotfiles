# !/bin/bash
secret="/home/hasky/Workspace/secret"
function goagent_ca_update(){
	local CAfile="/home/hasky/Workspace/git/goagent/local/CA.crt"

	echo "install ... Goagent CAcert"

	# root
	echo -e "\nroot ca updating ..."
	sudo -S mkdir -p /usr/share/ca-certificates/goagent < $secret
	sudo cp -fv $CAfile /usr/local/share/ca-certificates/goagent/GoAgent.crt < $secret
	sudo -S update-ca-certificates -f  < $secret

	# chromium
	echo -e "\nchromium ca updating ..."
	certutil -D -n "Goagent" -d sql:$HOME/.pki/nssdb # 删除
	certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "Goagent" -i $CAfile # 重新导入 

	# firefox
	echo -e "\nfirefox ca updating ..."
	certutil -D -n "Goagent" -d sql:$HOME/.mozilla/firefox/5m9a9zr6.default
	certutil -d sql:$HOME/.mozilla/firefox/5m9a9zr6.default -A -t TC -n "Goagent" -i $CAfile 
}
function goagent_update(){
	local goagent="/home/hasky/Workspace/git/goagent"
	cd $goagent

	sudo -S git reset --hard < $secret
	sudo -S git pull -f origin 3.0 < $secret
	sudo git checkout < $secret
	sed  -in 's/self\.log.*INFO.*$/pass/g' ./local/proxy.py #关闭info输出

	sudo -S rm -f ./local/CA.crt < $secret # 重新生成证书
	sudo -S python2 ./local/proxy.py < $secret & 
	sleep 3
	sudo pkill -f 'proxy.py' --signal 9 > /dev/null < $secret
	goagent_ca_update # update root ca
}
goagent_update
