#NAME

trrr - search torrents from CLI


#SYNOPSIS

CLI tool for searching torrents using as few keystrokes as it gets. Looking for torrents throught web browser can often be annoying as you are flooded with popups and fake Download buttons. trrr is written in Perl, has no non-core dependencies. It's using extratorrent API, filters and sorts results which are thwn mapped to letters. Press the key with assigned letter and it will download and open torrent in your default client. 


#INSTALATION

```
git clone https://github.com/z448/trrr
cd trrr
perl Makefile.PL
make
sudo make install
```


#USAGE

- filter results with as many parameters as needed
```
# search for pulp fiction
trrr pulp fiction

# to limit results by minimum number of seeders add -Nr as last parameter
trrr pulp fiction -100

```

First column is assigned key. To pick a result pres assigned key and it'll be opened in your default torrent client.

