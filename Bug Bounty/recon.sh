#!/bin/bash


if [ $# -ne 1 ];then
	echo "Usage: $0 <target_domain>"
	exit
fi

RED="\033[1;31m"
RESET="\033[0m"

URL=$1
RECON_PATH=$URL/recon
services="amazonaws"
TOOLS="assetfinder amass subfinder gowitness subjack httprobe waybackurls whatweb"
SUBDOMAIN_TOOLS="assetfinder amass subfinder"
SUBDOMAINS_OUTPUT=$RECON_PATH/subdomains_final.txt
ALIVE_OUTPUT=$RECON_PATH/httprobe/alive.txt

check_tool () {
	echo $1
	if ! command -v $1 &> /dev/null
	then
			echo "[-] $1 required to run script"
			exit 1
	fi
	echo "[*] $1 tool installed"
}

check_all_tools() {

	echo "[+] Checking all tools" 
	for tool in ${TOOLS}
	do
		echo "[*] Checking tool ${tool}"
		check_tool ${tool}
	done
}

install_all_tools () {
	git clone https://github.com/devanshbatham/ParamSpider /opt/ParamSpider && pip3 install -r ParamSpider/requirements.txt
	go install -v github.com/haccer/subjack@latest
	go install -v github.com/tomnomnom/waybackurls@latest
	go install -v github.com/tomnomnom/assetfinder@latest
	git clone https://github.com/haccer/subjack.git /opt/subjack
}

create_file () {

	if [ ! -f "$1" ]; then
		touch $1
		echo "[+] $1 file not existing, creating..."
	fi
}

create_folder() {

	if [ ! -d "$1" ]; then
		mkdir $1
		echo "[+] $1 folder not existing, creating..."
	fi
}

setup_tool () {
	create_folder $RECON_PATH/$1
}

setup_extra() {

	create_file $RECON_PATH/httprobe/alive.txt
	create_folder $RECON_PATH/waybackurls/params
	create_folder $RECON_PATH/waybackurls/extensions
	create_folder $RECON_PATH/3rd-lvls
}

setup_all_tools() {

	for tool in $TOOLS
	do
		setup_tool ${tool}
	done
	setup_extra

}

check_whois() {
	echo -e "${RED}[+] Checking who it is...${RESET}"
	whois $URL > $RECON_PATH/whois.txt
}
get_passive_data_amass () {
	echo "[+] Harvesting passive data with amass..."
	amass enum --passive -d $URL | tee $RECON_PATH/amass/passive_data_amass.txt
	cp $RECON_PATH/amass/passive_data_amass.txt $RECON_PATH/assets_amass.txt
}

parse_subdomains () {
	
	cat $RECON_PATH/assets_$1.txt | grep -E "^$URL|\.$URL" | sed 's/https\?:\/\///' | sed 's/http\?:\/\///' |  sort | uniq > $RECON_PATH/subdomains_$1.txt
	cat $RECON_PATH/assets_$1.txt | grep -vE "^$URL|\.$URL" | sed 's/https\?:\/\///' | sed 's/http\?:\/\///' | sort | uniq > $RECON_PATH/ommitted_$1.txt

	found=$(cat $RECON_PATH/subdomains_$1.txt | wc -l)
	ommitted=$(cat $RECON_PATH/ommitted_$1.txt | wc -l)

	echo "[+] Sucessfully found $found unique subdomains using $1!"
	echo "[+] Subdomains ommitted: $ommitted"
}

get_all_subdomains () {

	echo "[+] Proceeding to subdomain enumeration..."


	# Better to use assetfinder with nothing and grep afterwards
	# assetfinder tends to get results from related resources as well

	echo "[+] Harvesting subdomains with assetfinder..."
	assetfinder $URL | tee $RECON_PATH/assets_assetfinder.txt
	parse_subdomains assetfinder

	echo "[+] Harvesting subdomains with subfinder..."
	subfinder -d $URL | tee $RECON_PATH/assets_subfinder.txt
	parse_subdomains subfinder

	echo -e "[${RED}+${RESET}] Harvesting subdomains with amass...this could take a while...${RESET}"
	amass enum -d $URL | tee -a $RECON_PATH/assets_amass.txt
	parse_subdomains amass

	echo "[+] All files are accessible in $PWD/$RECON_PATH"


	echo "[+] Combining the subdomain lists into subdomains_final.txt..."
	cat $RECON_PATH/subdomains_assetfinder.txt $RECON_PATH/subdomains_subfinder.txt $RECON_PATH/subdomains_amass.txt > $RECON_PATH/subdomains_all_duplicates.txt
	cat $RECON_PATH/subdomains_all_duplicates.txt | sort | uniq > $SUBDOMAINS_OUTPUT
	found_duplicates_total=$(cat $RECON_PATH/subdomains_all_duplicates.txt | wc -l)
	found_unique_total=$(cat $SUBDOMAINS_OUTPUT | wc -l)

	echo "[+] The combined lists have a total of $found_duplicates_total subdomains!"
	echo "[+] The final aggregated list has $found_unique_total unique subdomains!"

}

merge_subdomains () {
	cat $1 $2 > /tmp/merged.txt
	cat /tmp/merged.txt | grep -E "^$URL|\.$URL" | sort | uniq > $2
}

get_certificates () {
 echo "[+] Interogating Certificate Transparency platforms such as crt.sh for issued certificates..."

 curl -sL "crt.sh/?q=%25${URL}" | grep "${URL}" | cut -d '>' -f2 | cut -d '<' -f1 > $RECON_PATH/certificates.txt
 found_before_merge=$(cat $SUBDOMAINS_OUTPUT | wc -l)
 merge_subdomains $RECON_PATH/certificates.txt $SUBDOMAINS_OUTPUT
 found_unique_total=$(cat $SUBDOMAINS_OUTPUT | wc -l)
 echo "[+] Before certificate gathering: $found_before_merge unique subdomains"
 echo "[+] After certificates gathering: $found_unique_total unique subdomains"

 curl -s "https://api.certspotter.com/v1/issuances?domain=${URL}&include_subdomains=true" > $RECON_PATH/cert_info.json
}

get_3rd_level_domains () {
	echo "[+] Extracting 3rd level domains from all subdomains..."
	cat $SUBDOMAINS_OUTPUT | grep -Po '(\w+.\w+.\w+)$' | sort | uniq >> $RECON_PATH/3rd-lvl-domains.txt
	echo "[+] Done extracting 3rd level domains"
}

check_alive_subs () {

	echo "[+] Probing for alive domains..."
	cat $1 | httprobe | sed 's/https\?:\/\///' | sed 's/http\?:\/\///' > $RECON_PATH/httprobe/alive.txt

	found_alive=$(cat $RECON_PATH/httprobe/alive.txt | wc -l)
	found_unique_total=$(cat $1 | wc -l)

	echo "[+] $found_alive/$found_unique_total subdomains are alive, accessible at $RECON_PATH/httprobe/alive.txt"

}

print_alive_subs () {

	echo "[+] Here are the live domains:"
	while read -r line; do echo $line; done < $RECON_PATH/httprobe/alive.txt
	echo
}

screenshot_alive_subs () {

	gowitness file -f $RECON_PATH/httprobe/alive.txt -P $RECON_PATH/gowitness
}

check_sub_takeover() {

	echo "[+] Checking for possible subdomain takeover..."
	subjack -w $RECON_PATH/httprobe/alive.txt -t 100 -timeout 30 -ssl -c /opt/subjack/fingerprints.json -v 3 | tee $RECON_PATH/subjack/takeovers_temp.txt
	cat $RECON_PATH/subjack/takeovers_temp.txt | sort | uniq > $RECON_PATH/subjack/takeovers.txt
	rm $RECON_PATH/subjack/takeovers_temp.txt
}

check_wayback () {
	echo "[+] Check for wayback URLs..."
	cat $SUBDOMAINS_OUTPUT | waybackurls | tee $RECON_PATH/waybackurls/wayback_output_raw.txt
	cat $RECON_PATH/waybackurls/wayback_output_raw | sort | uniq > $RECON_PATH/waybackurls/wayback_output.txt
	rm $RECON_PATH/waybackurls/wayback_output_raw.txt
}

check_whatweb () {

    for domain in $(cat $RECON_PATH/httprobe/alive.txt);do
			  create_folder $RECON_PATH/whatweb/$domain
        echo "[*] Pulling plugins data on $domain $(date +'%d-%m-%Y %T') "
        whatweb --info-plugins -t 50 -v $domain >> $RECON_PATH/whatweb/$domain/plugins.txt; sleep 3
        echo "[*] Running whatweb on $domain $(date +'%d-%m-%Y %T')"
        whatweb -t 50 -v $domain >> $RECON_PATH/whatweb/$domain/output.txt; sleep 3
    done
}

check_paramspider () {
	python3 /opt/ParamSpider/paramspider.py --domain $URL --exclude css --level high --output $RECON_PATH/paramspider

}
scan_ports () {
	echo "[+] Scanning light for open ports..."
	echo "[+] Command used:"
	echo "[+] nmap -iL $1 -T4 -oA $RECON_PATH/scans/nmap_scan.txt"
}

aws_bucket_regex () {
	
	echo ""
	# {bucketname}.s3.amazonaws.com
	# ^[a-z0-9\.\-]{0,63}\.?s3.amazonaws\.com$
	# 
	# # {bucketname}.s3-website(.|-){region}.amazonaws.com (+ possible China region)
	# ^[a-z0-9\.\-]{3,63}\.s3-website[\.-](eu|ap|us|ca|sa|cn)-\w{2,14}-\d{1,2}\.amazonaws.com(\.cn)?$
	# 
	# # {bucketname}.s3(.|-){region}.amazonaws.com
	# ^[a-z0-9\.\-]{3,63}\.s3[\.-](eu|ap|us|ca|sa)-\w{2,14}-\d{1,2}\.amazonaws.com$
	# 
	# # {bucketname}.s3.dualstack.{region}.amazonaws.com
	# ^[a-z0-9\.\-]{3,63}\.s3.dualstack\.(eu|ap|us|ca|sa)-\w{2,14}-\d{1,2}\.amazonaws.com$

}

check_takeover_exists () {
	for service in $1
	do
		echo $service
	done
	# Use source domain name
	S3_BUCKET_URL=$(dig -t ANY $URL | grep -E "CNAME|MX|NS|A" | grep "amazonaws")
	# echo "Bucket URL: " ${S3_BUCKET_URL}
	if [ -z "${S3_BUCKET_URL}" ]; then
		echo "[+] No S3 Bucket found in DNS records"
	else
	   	echo "[+] S3 Bucket found!!"
		echo "S3 Bucket URL: ${S3_BUCKET_URL}"
		curl -X GET $S3_BUCKET_URL
		curl -X GET $S3_BUCKET_URL | grep -E -q '<Code>NoSuchBucket</Code>|<li>Code: NoSuchBucket</li>' && echo "[+] Subdomain takeover may be possible" || echo "[-] Subdomain takeover is not possible"
	fi
}

exploit_aws_takeover () {
	echo "[TODO] Automate S3 Bucket creation"
}

create_folder $URL
create_folder $RECON_PATH
create_file $SUBDOMAINS_OUTPUT
#install_all_tools
setup_all_tools
get_passive_data_amass
check_whois
get_all_subdomains
get_certificates
get_3rd_level_domains
check_alive_subs $SUBDOMAINS_OUTPUT
print_alive_subs
check_sub_takeover
check_wayback
check_whatweb
check_paramspider
scan_ports $ALIVE_OUTPUT
screenshot_alive_subs
#aws_bucket_regex
#check_takeover_exists $services
#exploit_aws_takeover

