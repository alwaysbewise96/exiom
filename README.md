<h1 align="center">
  <img src="screenshots/axiom_banner.png" alt="Exiom"></a>
  <br>
 </h1>

[![License](https://img.shields.io/badge/license-MIT-_red.svg)](https://opensource.org/licenses/MIT)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/alwaysbegood96/exiom/issues)


<p align="center">
<a href="https://github.com/alwaysbegood96/exiom/wiki" target="_blank"> <img src="https://github.com/projectdiscovery/nuclei/raw/367d12700e252ec7066c79b1b97a6427544d931c/static/read-the-docs-button.png" height="42px"/></a>
</p> 

**Exiom is a dynamic infrastructure framework** to efficiently work with multi-cloud environments, build and deploy repeatable infrastructure focused on offensive and defensive security. 

JUST TESTING THE NEW ACHIVE OF EXIOM BASED ON PROJECT AXIOM..

# Resources

-   [Introduction](https://github.com/alwyasbewise96/exiom/wiki)
-   [Troubleshooting & FAQ](https://github.com/alwyasbewise96/exiom/wiki/0-Installation#troubleshooting)
-   [Quickstart](https://github.com/alwyasbewise96/exiom/wiki/A-Quickstart-Guide)
    - [Fleets](https://github.com/alwyasbewise96/exiom/wiki/Fleets)
    - [Scans](https://github.com/alwyasbewise96/exiom/wiki/Scans)
-   [Demo](#demo)
-   [Story](https://github.com/pry0cc/axiom/wiki/The-Story)
-   [Installation Instructions](https://github.com/alwyasbewise96/exiom#installation)
    -   [Docker Install](#docker)
    -   [Easy Install](#easy-install)
    -   [Manual Install](https://github.com/alwyasbewise96/exiom/wiki/0-Installation#Manual)
-   [Scan Modules](https://github.com/alwyasbewise96/exiom/wiki/Scans#example-axiom-scan-modules)
-   [Installed Packages](#tools-to-date)
-   [Contributors](#contributors)


# Installation
## Docker

This will create a docker container, initiate [`axiom-configure`](https://github.com/pry0cc/axiom/wiki/Filesystem-Utilities#axiom-configure) and [`axiom-build`](https://github.com/pry0cc/axiom/wiki/Filesystem-Utilities#axiom-build) and then drop you out of the docker container. Once the [Packer](https://www.packer.io/) image is successfully created, you will likely need to re-exec into your docker container via `docker exec -it $container_id zsh`.
```
docker exec -it $(docker run -d -it --platform linux/amd64 ubuntu:20.04) sh -c "apt update && apt install git -y && git clone https://github.com/pry0cc/axiom ~/.axiom/ && cd && .axiom/interact/axiom-configure"
```

## Easy Install

You should use an OS that supports our [easy install](https://github.com/alwyasbewise96/exiom#operating-systems-supported). <br>
For Linux systems you will also need to install the newest versions of all packages beforehand `sudo apt dist-upgrade`. <br>
```
bash <(curl -s https://raw.githubusercontent.com/alwyasbewise96/exiom/testing_bb.sh)
```

If you have any problems with this installer, or if using an unsupported OS please refer to [Installation](https://github.com/alwyasbewise96/exiom/wiki/0-Installation).

# Demo
In this demo (sped up out of respect for your time ;) ), we show how easy it is to initialize and ssh into a new instance.

<img src="https://raw.githubusercontent.com/pry0cc/axiom/master/screenshots/axiom-init-demo.gif" >


# Sponsored By SecurityTrails!
<img src="https://github.com/pry0cc/axiom/blob/master/screenshots/st.png">
We are lucky enough to be sponsored by the awesome SecurityTrails! Sign up for your free account <a href="https://securitytrails.com/app/signup?utm_source=axiom">here!</a>

---


## Operating Systems Supported
| OS         | Supported | Easy Install  | Tested        | 
|------------|-----------|---------------|---------------|
| Ubuntu     |    Yes    | Yes           | Ubuntu 20.04  |
| Kali       |    Yes    | Yes           | Kali 2021.3   |
| Debian     |    Yes    | Yes           | Debian 10     |
| Windows    |    Yes    | Yes           | WSL w/ Ubuntu |
| MacOS      |    Yes    | Yes           | MacOS 11.6    |
| Arch Linux |    Yes    | No            | Yes           |



# Contributors
We've had some really fantastic additions to axiom, great feedback through issues, and perseverence through our heavy beta phase!

A list of all contributors can be found [here](https://github.com/pry0cc/axiom/graphs/contributors), thank you all!

# Art
The [original logo](https://github.com/pry0cc/axiom/blob/master/screenshots/axiom-logo.png) was made by our amazing [s0md3v](https://twitter.com/s0md3v)! Thank you for making axiom look sleek as hell! Really beats my homegrown logo :)

The awesome referral banners were inspired by [fleex](https://github.com/FleexSecurity/fleex) and were made by the one and only [xm1k3](https://twitter.com/xm1k3_)!

# Tools to Date
> for [default](https://github.com/pry0cc/axiom/blob/master/images/provisioners/default.json) provisioner
<pre>
- [x] aiodnsbrute&#9;&#9;- [x] ffuf&#9;&#9;&#9;&#9;- [x] gobuster&#9;&#9;&#9;- [x] massdns&#9;&#9;&#9;- [x] subfinder
- [x] Amass&#9;&#9;&#9;- [x] findomain&#9;&#9;&#9;&#9;- [x] google-chrome&#9;&#9;- [x] medusa&#9;&#9;&#9;- [x] subjack
- [x] anew&#9;&#9;&#9;- [x] gau&#9;&#9;&#9;&#9;- [x] gorgo&#9;&#9;&#9;- [x] meg&#9;&#9;&#9;- [x] subjs
- [x] anti-burl&#9;&#9;&#9;- [x] gauplus&#9;&#9;&#9;&#9;- [x] gospider&#9;&#9;&#9;- [x] naabu&#9;&#9;&#9;- [x] testssl
- [x] aquatone&#9;&#9;&#9;- [x] getJS&#9;&#9;&#9;&#9;- [x] gowitness&#9;&#9;&#9;- [x] nmap&#9;&#9;&#9;- [x] thc-hydra
- [x] Arjun&#9;&#9;&#9;- [x] gf&#9;&#9;&#9;&#9;- [x] gron&#9;&#9;&#9;- [x] nuclei&#9;&#9;&#9;- [x] tlsx
- [x] assetfinder&#9;&#9;- [x] Gf-Patterns&#9;&#9;&#9;- [x] Gxss&#9;&#9;&#9;- [x] OpenRedireX&#9;&#9;- [x] trufflehog
- [x] axiom&#9;&#9;&#9;- [x] github-endpoints&#9;&#9;&#9;- [x] hakrawler&#9;&#9;&#9;- [x] ParamSpider&#9;&#9;- [x] ufw
- [x] axiom-dockerfiles&#9;&#9;- [x] github-subdomains&#9;&#9;&#9;- [x] hakrevdns&#9;&#9;&#9;- [x] phantomjs&#9;&#9;&#9;- [x] unimap
- [x] cent&#9;&#9;&#9;- [x] Go&#9;&#9;&#9;&#9;- [x] httprobe&#9;&#9;&#9;- [x] proxychains-ng&#9;&#9;- [x] wafw00f
- [x] cero&#9;&#9;&#9;- [x] dnsgen&#9;&#9;&#9;&#9;- [x] httpx&#9;&#9;&#9;- [x] puredns&#9;&#9;&#9;- [x] waybackurls
- [x] chaos-client&#9;&#9;- [x] dnsrecon&#9;&#9;&#9;&#9;- [x] interactsh-client&#9;&#9;- [x] qsreplace&#9;&#9;&#9;- [x] webscreenshot
- [x] commix&#9;&#9;&#9;- [x] dns resolvers by trickest&#9;&#9;- [x] Interlace&#9;&#9;&#9;- [x] responder.py&#9;&#9;- [x] wpscan
- [x] concurl&#9;&#9;&#9;- [x] dnsvalidator&#9;&#9;&#9;- [x] ipcdn&#9;&#9;&#9;- [x] RustScan
- [x] Corsy&#9;&#9;&#9;- [x] dnsx&#9;&#9;&#9;&#9;- [x] jaeles&#9;&#9;&#9;- [x] s3scanner
- [x] CrackMapExec&#9;&#9;- [x] Docker&#9;&#9;&#9;&#9;- [x] kiterunner&#9;&#9;- [x] scrying
- [x] crlfuzz&#9;&#9;&#9;- [x] ERLPopper&#9;&#9;&#9;&#9;- [x] kxss&#9;&#9;&#9;- [x] SecLists
- [x] dalfox&#9;&#9;&#9;- [x] exclude-cdn&#9;&#9;&#9;- [x] leaky-paths&#9;&#9;- [x] shuffledns
- [x] dirdar&#9;&#9;&#9;- [x] feroxbuster&#9;&#9;&#9;- [x] LinkFinder&#9;&#9;- [x] six2dez dns permutations
- [x] DNSCewl&#9;&#9;&#9;- [x] fff&#9;&#9;&#9;&#9;- [x] masscan&#9;&#9;&#9;- [x] sqlmap
</pre>


# Packages Installed via apt-get
> for [default](https://github.com/pry0cc/axiom/blob/master/images/provisioners/default.json) provisioner
- [x] bison
- [x] build-essential
- [x] fail2ban
- [x] firebird-dev
- [x] flex
- [x] git
- [x] grc
- [x] jq
- [x] libgcrypt11-dev_1.5.4-3+really1.8.1-4ubuntu1.2_amd64.deb
- [x] libgcrypt20-dev
- [x] libgpg-error-dev
- [x] libgtk2.0-dev
- [x] libidn11-dev
- [x] libmemcached-dev
- [x] libmysqlclient-dev
- [x] libpcap-dev
- [x] libpcre3-dev
- [x] libpq-dev
- [x] libssh-dev
- [x] libssl-dev
- [x] libsvn-dev
- [x] net-tools
- [x] ohmyzsh
- [x] p7zip
- [x] python3-pip
- [x] ruby-dev
- [x] rubygems
- [x] ufw
- [x] unzip
- [x] zsh
- [x] zsh-autosuggestions
- [x] zsh-syntax-highlighting
