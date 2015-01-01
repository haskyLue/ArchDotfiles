# !/bin/bash
secret="/home/hasky/Workspace/secret"
function goagent_ca_update(){
	local CAfile="/usr/share/goagent/local/CA.crt"

	echo -e "\n----------install ... Goagent CAcert"

	# 1
	# echo -e "\n----------root ca updating ..."
	# sudo -S mkdir -p /usr/local/share/ca-certificates/goagent < $secret
	# sudo -S cp -fv $CAfile /usr/local/share/ca-certificates/goagent/GoAgent.crt < $secret
	# sudo -S update-ca-certificates -f < $secret

	# 2
	echo -e "\n----------chromium ca updating ..."
	certutil -L -d sql:$HOME/.pki/nssdb | grep "GoAgent" && certutil -D -n "GoAgent" -d sql:$HOME/.pki/nssdb # 删除
	certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "GoAgent" -i $CAfile # 重新导入 

	# firefox
	# echo -e "\nfirefox ca updating ..."
	# certutil -D -n "Goagent" -d sql:$HOME/.mozilla/firefox/5m9a9zr6.default
	# certutil -d sql:$HOME/.mozilla/firefox/5m9a9zr6.default -A -t TC -n "Goagent" -i $CAfile 
}
function goagent_update(){
	local goagent="/usr/share/goagent"
	cd $goagent

	sudo -S sed  -in 's/self\.log.*INFO.*$/pass/g' ./local/goagent < $secret #关闭info输出
	sudo -S ln -sf /home/hasky/.proxy.user.ini /etc/goagent < $secret

	sudo -S rm -f ./local/CA.crt < $secret # 重新生成证书
	sudo -S rm -fr ./local/certs < $secret # 重新生成证书
	sudo -S ./local/goagent < $secret & 
	sleep 2
	sudo -S pkill -f 'local/goagent' --signal 9 > /dev/null < $secret

	goagent_ca_update # update root ca

}
goagent_update

