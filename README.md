# virustotalx for endpoints 

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


# Usage

Create sub domain file `EX` ===> `subdomain.txt`  ===> `wihtout http/s` 

**===>**


```
./orwa.sh subdomain.txt | tee results.txt 
```

**===>**


```
cat results.txt | egrep 'http|https' > endpoints.txt
```

