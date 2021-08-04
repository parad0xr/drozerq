#!/bin/zsh
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m' # No Color

adb forward tcp:31415 tcp:31415
echo -e "\e[1;34mEnter Name of app\e[0m"
read app
drozer console connect -c "run app.package.list" | grep $app
echo -e "${RED}\nEnter the Relevant Package Name from Above ${NC}"
read pname
echo -e "${GREEN}\nGet package information ${NC}"
drozer console connect -c "run app.package.info -a $pname"
echo -e "${GREEN}\nGet activity information ${NC}"
drozer console connect -c "run app.activity.info -i -u -a $pname"
echo -e "${RED}\nTo launch any selected activity: run app.activity.start --component <package_name> <activity_name> ${NC}"
echo -e "${GREEN}\nGet broadcast receiver information ${NC}"
drozer console connect -c "run app.broadcast.info -i -u -a $pname"
echo -e "${GREEN}\nGet attack surface details ${NC}"
drozer console connect -c "run app.package.attacksurface $pname"
echo -e "${GREEN}\nGet package with backup API details ${NC}"
drozer console connect -c "run app.package.backup -f $pname"
echo -e "${GREEN}\nGet Android Manifest of the package ${NC}"
drozer console connect -c "run app.package.manifest $pname"
echo -e "${GREEN}\nGet native libraries information ${NC}"
drozer console connect -c "run app.package.native $pname"
echo -e "${GREEN}\nGet content provider information ${NC}"
drozer console connect -c "run app.provider.info -u -a $pname"
echo -e "${GREEN}\nGet URIs from package ${NC}"
drozer console connect -c "run app.provider.finduri $pname"
echo -e "${RED}\nTo retrieve or modify data using the above content URIs: run app.provider.query content://com.mwr.example.sieve.DBContentProvider/Password/ --vertical"
echo To attack using SQL injection: run app.provider.query content://com.mwr.example.sieve.DBContentProvider/Passwords/ --projection "'" 
echo run app.provider.query content://com.mwr.example.sieve.DBContentProvider/Passwords/ --selection "'"
echo -e "Read this link for more: https://medium.com/@ashrafrizvi3006/how-to-test-android-application-security-using-drozer-edc002c5dcac ${NC}"

echo -e "${GREEN}\nGet services information ${NC}"
echo -e "${RED}\nTo get details about exported services: run app.service.info -a <package_name> ${NC}"

drozer console connect -c "run app.service.info -i -u -a $pname"
echo -e "${GREEN}\nGet native components included in package ${NC}"
drozer console connect -c "run scanner.misc.native -a $pname"
echo -e "${GREEN}\nGet world readable files in app installation directory /data/data/<package_name>/ ${NC}"
drozer console connect -c "runscanner.misc.readablefiles /data/data/$pname/"
echo -e "${GREEN}\nGet world writeable files in app installation directory /data/data/<package_name>/ ${NC}"
drozer console connect -c "run scanner.misc.readablefiles /data/data/$pname"
echo -e "${GREEN}\nGet content providers that can be queried from current context ${NC}"
drozer console connect -c "run scanner.provider.finduris -a $pname"
echo -e "${GREEN}\nPerform SQL Injection on content providers ${NC}"
drozer console connect -c "run scanner.provider.injection -a $pname"
echo -e "${GREEN}\nFind SQL Tables trying SQL Injection ${NC}"
drozer console connect -c "run scanner.provider.sqltables -a $pname"
echo -e "${GREEN}\nTest for directory traversal vulnerability ${NC}"
drozer console connect -c "run scanner.provider.traversal -a $pname"
echo -e "${RED}\nRead this for more: https://github.com/tanprathan/MobileApp-Pentest-Cheatsheet ${NC}"
echo "\e[1;34m\nDo you want to run MobSF(y/n)?\e[0m"
read input
if input=y;
then
	echo -e "${GREEN}Running MobSF isntance: Visit 0.0.0.0:8000"
	#echo -e "Before you quit run> 'docker ps -a'  and then 'docker rm container_id' to close docker properly${NC}"
	docker run -it --name mobsf -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
	echo -e "${GREEN}Run mobsf_stop${NC}"
else
	echo -e "${GREEN}Quitting${NC}"
fi
#echo -e " 
#drozer console connect -c "run $pname"
#echo -e " 
#drozer console connect -c "run $pname"
#echo -e " 
#drozer console connect -c "run $pname"
#echo -e " 
#drozer console connect -c "run $pname"
