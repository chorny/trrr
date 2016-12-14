#NAME

trrr - search torrents from CLI


#SYNOPSIS

CLI tool for searching torrents using as few keystrokes as it gets. Looking for torrents throught web browser can often be annoying as you are flooded with popups and fake Download buttons. trrr is written in Perl, it's using only core dependencies and it'll work on OSX, Ubuntu, iOS-jb. It's using extratorrent API, filters and sorts results then map each result to different key. Press a key with assigned letter and it will download torrent into `~/Downloads` directory. On OSX and Linux it'll also open torrent in your default client (see gif). 



#GIF

![trrr](https://raw.githubusercontent.com/z448/trrr/master/trrr.gif)

#INSTALATION

-if you have [cpanm](https://metacpan.org/pod/App::cpanminus)

```
cpanm App::Trrr
```

or

```
git clone https://github.com/z448/trrr
cd trrr
perl Makefile.PL
make
sudo make install
```


#USAGE

Filter results with as many parameters as needed
Search for pulp fiction

```
trrr pulp fiction
```

To limit results by minimum number of seeders add -Nr as last parameter

```
trrr pulp fiction -100
```

First column is assigned key. To pick a result pres assigned key and it'll be opened in your default torrent client.

