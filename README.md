# virustotalx for endpoints 
# virustotalx for IPs (V2)

# Installation 

```
git clone https://github.com/orwagodfather/virustotalx.git
```

```
cd virustotalx
```


create a 3 accounts [https://www.virustotal.com/gui/join-us](https://www.virustotal.com/gui/join-us) and copy the 3 api keys ===>

```
nano orwa.sh
```
&

```
nano orwaV2.sh
```

paste 3 api keys here ....


```
  if [ $api_key_index -eq 1 ]; then
    api_key="key-1"
  elif [ $api_key_index -eq 2 ]; then
    api_key="key-2"
  else
    api_key="key-3"
  fi
```

**Ex**

```
  if [ $api_key_index -eq 1 ]; then
    api_key="XXXXXXXXXXXXXX1"
  elif [ $api_key_index -eq 2 ]; then
    api_key="XXXXXXXXXXXXXX2"
  else
    api_key="XXXXXXXXXXXXXX3"
  fi
```


**next step**

`chmod +x orwa.sh` 
&
`chmod +x orwaV2.sh` 

# Usage orwa.sh for endpoints 

Create sub domain file `EX` ===> `subdomain.txt`  ===> `wihtout http/s` 

**===>**


```
./orwa.sh subdomain.txt | tee results.txt 
```

**===>**


```
cat results.txt | egrep 'http|https' > endpoints.txt
```


# Usage orwaV2.sh for IPs (V2) 

Create IPs file `EX` ===> `all-IP-range.txt`  ===> `wihtout http/s` 

**===>**


```
./orwaV2.sh all-IP-range.txt | tee endpointsV2.txt 
```

**===>**


```
cat endpointsV2.txt | httpx -sc -title
```


