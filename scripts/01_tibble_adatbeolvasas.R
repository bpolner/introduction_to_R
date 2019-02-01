# A tibble. Fájlok olvasása és írása.

require(tidyverse)
require(data.table)
require(microbenchmark)
require(nycflights13)
require(feather)


# 1. A tibble ----------------------------------------------------------------


# A tibble csomaggal lehet őket kezelni - ez is benne van a tidyverse szupercsomagban 

# data.frame-ből tibble:

iris
class(iris)

as_tibble(iris)

# Vektorokbol tibble

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

# Egyelemű bemeneteket automatikusan újra felhasználja / a példában y
# Lehet hivatkozni az éppen létrehozott változókra / a példában z

# A tibble-ben a valtozonevek lehetnek ervenytelen R valtozonevek
# ` ` (magyar bill: Alt Gr + 7) hasznalataval lehet rajuk hivatkozni

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)

tb

# Transzponalt adatbevitel a tribble() fuggvennyel:
# ez akkor nagyon jó, ha kódban akarunk bevinni egy adattáblát.
# Oszlopok neveit formulával adjuk meg ( ~ <név>), 
# az értékeket pedig vesszővel elválasztva soroljuk fel

tribble(
  ~x, ~y, ~z,
  #--/--/---- olvashatóbb, ha a fejléc alá egy komment sort teszünk
  "a", 2, 3.6,
  "b", 1, 8.5
)

# tibble nyomtatasa a konzolra: alapbeállítás szerint 10 sor, 
# és annyi oszlop, amennyi a konzolra kifér
# minden oszlop alatt látjuk a típusát is

mpg

# Megjelenített sorok es oszlopok számának szabályozása:

mpg %>% 
  print(n = 10, width = Inf)

# Modosithatjuk az alapbeallitasokat is

# Ha tobb mint m sor van, nyomtasson n sort

options(tibble.print_max = n, tibble.print_min = m)

# Mindig minden sor nyomtatasa:

options(dplyr.print_min = Inf)

# Mindig minden oszlop nyomtatasa, a konzol szelessegetol fuggetlenul: 

options(tibble.width = Inf)

# További opciók:

package?tibble
?print.tbl

# Hogyan tudunk kinyerni egyetlen változót?

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# $ - csak nev alapjan

df$x

# [[]] - nev (string!) es pozicio alapjan is

df[["x"]]

df[[1]]

# Ha egy pipe-ban szeretnénk használni, használjuk a . helyőrzőt!

df %>% .$x

df %>% .[[1]]

# Ha nem létező oszlopot próbálunk elérni, 
# figyelmeztetést kapunk, eredményül pedig NULL-t

df$z

# Nehany regebbi csomag nem kompatibilis a tibble-lel. 
# Ilyenkor konvertaljuk az adatainkat data.frame-é:

as.data.frame(df)
class(as.data.frame(df))


# 1.1 tibble - gyakorlas ----------------

# 1) Ha egy valtozo neve egy változóban tarolva, hogyan lehet a valtozot kinyerni 
# egy tibble-bol? mpg adatokban van a cty valtozo

var <- "cty"

# 2) Hasonlítsd össze a következő műveleteket data.frame-n és
# egy egyező tibble-n! Mi a különbség? 
# Mi lehet a gond a data.frame működésében?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]


# 2. Adatok importálása  ------------------------------------


# 2.1 utils ----
# read.csv(), read.delim(), read.table()

# A beolvásófüggvények első argumentuma a fájl elérési útja:
# meg kell mondani a függvénynek, hogy hol van a fájl, amit 
# szeretnénk betölteni az R-be.

magas <- read.csv("C://Users/Polner Bertalan/Dropbox/oktatás/R_bevezetes/data/magassagok_1.txt")

# Ez azonban kényelmetlen lehet, ha szeretnénk, 
# h több gépen is működjön a kód.
# Megoldás, ha RStudio projektet használunk.

magas <- read.csv("data/magassagok_1.txt")

# Elérési utak meghatározása op.rendszerenként eltér.
# A file.path az adott op.rendszernek megfelelő formátumú elérési utat ad:

path <- file.path("data", "magassagok_1.txt")

magas <- read.csv(path)

# Honnan tudja a file.path a helyes formátumot?
# Nézzük meg a forráskódot!

file.path

# A  .Platform listából nézi meg

.Platform

# A read.csv jól működik, ha a csv fájlban a tizedesvessző ponttal, 
# az oszlopok elválasztása pedig vesszővel van jelölve (angolszász)
# DE: a tizedesvesszőt van, ahol vesszővel jelölik (pl. magyar)
# és az oszlopokat ;-vel választják el egymástól, 
# ezeket a read.csv "nem érti":

path <- file.path("data", "magassagok_2.txt")

(magas_2 <- read.csv(path))

str(magas_2)

# Erre van kitalálva a read.csv2:

(magas_2 <- read.csv2(path))

str(magas_2)

# Mit csinál a read.csv és a read.csv2 ?

read.csv

read.csv2

# A read.table függvényt hívják meg, 
# a sep és a dec argumentumokat a célnak megfelelően beállítva

# 2.2 readr ----

# A readr csomag legtöbb függvénye szövegfájlokat olvas be:

# read_csv (vesszővel tagolt) 
# read_tsv (tabulátorral tagolt) 
# read_csv2 (pontosvesszovel tagolt)
# read_delim (bármilyen tagoló megadható)
# read_fwf (fix szélességű fájlok)

# a read fuggvenyek elso argumentuma a beolvasando fajl eleresi utvonala

read_csv("data/magassagok_1.txt")

data_path <- "data"

path <- file.path(data_path, "magassagok_1.txt")

read_csv(path, n_max = 1 )

# Meg lehet adni a bemenet csv fajlt a fuggveny hivasakor is
# Igy lehet probalgatni a readr mukodeset
# Es masoknak lehet reprodukalhato peldakat adni (pl stackoverflow-n)

read_csv(
  "a,b,c
   1,2,3
   4,5,6"
)

# A beolvasott fajl elso sorat oszlopnevkent ertelmezi a readr
# Felulirhato! Mikor lehet erre szukseg?




read_csv(
  "The first line of metadata
   The second line of metadata
   x,y,z
   1,2,3", 
  skip = 2
)



read_csv(
  "# A comment I want to skip
   x,y,z
   1,2,3",
  comment = "#"
)

# 2) nincs fejlec az adatokban

# a, megmondjuk, hogy nincs fejléc (\n sortorest jeloli)

read_csv("1,2,3\n4,5,6", col_names = FALSE)

# b, megadunk egy fejlécet

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

# hianyzo adatok jelolesenek meghatarozasa: na argumentum

read_csv("a,b,c\n1,2,.", na = ".")

# Az esetek 75%-ában elég a fentieket tudni 
# a csv fájlok olvasásához!

# A readr a base R beolvasóihoz képest:
# - gyorsabb
# - tibble-be olvasnak be
# - karakter oszlopokból nem lesz automatikusan faktor
# - nem használ sorneveket
# - jobb a megismételhetőségük (base R függ op.rendsz.-től és R beállításoktól)




# 2.2.1 readr - gyakorlás -------------------------------------------------

# Mi a gond a kódból megadott csv fájlokkal?

read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")


# 2.3 Vektorok elemzése ---------------------------------------------------

# Hogyan olvassa be a readr a lemezről a fájlokat?

# Ehhez előbb nézzük meg, hogyan dolgoznak a parse_* függvények!
# Adunk nekik egy karaktervektort, és visszaadnak egy spec. vektort.

str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))

# 1. arg.: elemzendő karaktervektor, 2. arg.: NA jelölésének meghatározása

parse_integer(c("1", "231", ".", "456"), na = ".")

# Mi történik, ha nem sikerül az elemzés?

x <- parse_integer(c("123", "345", "abc", "123.45"))

# Amit nem sikerült elemezni, ott NA-t kapunk

x

# Sikertelen elemzések áttekintése:

problems(x)


# 2.3.1 Számok ------------------------------------------------------------

# Miért nem olyan egyszerű?


# a, tizedesvessző lehet . és , is

parse_double("1.23")

# Helyi sajátosságok beállítása: locale

parse_double("1,23", locale = locale(decimal_mark = ","))

# b, számok körül néha spec. karakterek $ %

# parse_number nagyon hasznos: elenged minden karaktert, ami nem szám

parse_number("$100")

parse_number("20%")

parse_number("It cost $123.45")


# c, különböző csoportosító karakterek 1'000 1,000 1 000

# parse_number, locale-ban pedig megadjuk a csoportosítót:

# USA

parse_number("$123,456,789")

# Európában gyakori:

parse_number("123.456.789", locale = locale(grouping_mark = "."))

# Svájc:

parse_number("123'456'789", locale = locale(grouping_mark = "'"))



# 2.3.2 Karakterláncok (strings) ------------------------------------------

# Ugyanaz a string többféleképpen is reprezentálható

# Hogyan reprezentál az R egy stringet?

charToRaw("Hadley")

# Minden hexadecimális szám egy bájtnyi információt reprezentál.
# A karakterkódolás a hexadecimális számok és karakterek megfeleltetése.

# ASCII kódolás az angol nyelvre jó
# Egyéb nyelvek: 
#   Latin1 / ISO-8859-2 Ny-Eu nyelvek 
#   Latin2 / ISO-8859-2- K-Eu nyelvek
# 
# Nagyon elterjedt és szinte mindent kódol: UTF-8
# A readr alapértelmezésként UTF-8-at használ beolvasáshoz és íráshoz is
# Probléma akkor lehet, ha nem UTF-8-ban van kódolva az adat,
# ilyenkor furcsa stringeket fogunk látni:

x1 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Shift-JIS"))


# Hogyan jövünk rá a kódolásra?
# Jobb esetben a dokumentációból kiderül. 
# Ha nem, segíthet a guess_encoding (sok szöveggel jobban működik)

szoveg <- "Ez egy magyar nyelvű szöveg."

guess_encoding(charToRaw(szoveg))



# 2.3.3 Faktorok (kategorikus változók) -----------------------------------

fruit <- c("apple", "banana")

parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# Ha sok problémás eset van, érdemes faktor helyett 
# inkább stringnek beolvasni, és később kipucolni


# 2.3.4 Dátum és idő ------------------------------------------------------

# Alapbeállítás szerint:

# a, parse_datetime ISO8601 formátumra számít év...másodperc

parse_datetime("2010-10-20 141345")

# Ha az idő hiányzik, azt éjfélnek veszi

parse_datetime("20101010")

# b, parse_date  év (4 számj.), majd - vagy /, hónap, majd - or /, és a nap:

parse_date("2010-10-01")

# c, parse_time óra, :, perc (opcionális , : másodperc és am/pm)

parse_time("01:10 am")

parse_time("20:10:01")

# Ha az alapbeállítások nem működnek, megadhatunk egyedi formátumot

parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%d/%m/%y")

parse_date("Jan 23 2015", "%b %d %Y")



# 2.4 Fájlok elemzése -----------------------------------------------------

# Hogyan találja ki a readr a változók típusát?
# Megnézi az első 1000 sort, és heurisztikákat alkalmaz

guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))

str(parse_guess("2010-11-01"))

# De lehet, hogy az első 1000 sor speciális, pl.
# - első 1000 sorban egész szám van, de később jönnek tizedestörtek is
# - első 1000 sorban NA van, később jönnek az értékek 

# Lássunk egy példát!

challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)

# Mi volt az oszlopok meghatározása az előző beolvasásnál?

# cols(
#   x = col_integer(),
#   y = col_character()
# )

# Módosítsuk az oszlopok típusát!

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)

# Ezzel az x beolvasára rendben. Mi a helyzet az y-nal?

challenge
tail(challenge)

# Adjuk meg helyesen típuását ennek az oszlopnak is!

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

challenge
tail(challenge)

# Érdemes mindig explicit megadni az oszlopok típusát, 
# következetes és reprodukálhatóbb lesz az adatimportálás. 

# Megoldás lehet még, ha több sor alapján következtetünk 
# az oszlop típusára.

challenge_2 <- read_csv(
  readr_example("challenge.csv"), 
  guess_max = 3000
  
)

# Vagy ha minden oszlopot karakternek olvasunk be, 

challenge_2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)

# És utána a type_convert-tel felismertetjük az oszlopok típusát

type_convert(challenge_2)

# Hogyan találja ki a type_convert a típust? 
# http://r4ds.had.co.nz/data-import.html#parsing-a-file


# 2.5 data.table ------------------------------------------
# fread

# Nagyon gyors, és "okos" beolvasás

# Nézzük meg, mennyi idő alatt olvassa be a flights adattáblát 
# a read.csv, a read_csv, és az fread!

# Előbb írjuk ki csv-be az adatokat

data(flights)

path <- file.path("data", "flights.csv")

fwrite(flights, path, sep = ",", dec = ".")

# Hasonlítsuk össze a három beolvasó sebességét!

microbenchmark(fread(path), read.csv(path), read_csv(path), times = 3L)

# Olvassuk be csak az 5. oszlopot, és csak a fejléc utáni első száz sort!

fl <- fread(path, select = 5, nrows = 100)

# oszlopok kihagyása: drop argumentum

# data.table bővebben: vignette-k és DataCamp kurzus


# 3. Fájlba írás ----------------------------------------------------------

# readr: write_tsv és write_csv
# data.table: fwrite

# Könnyen olvasható fájlokat írnak:
# - karakterláncokat UTF-8-ban kódolják
# - dátum, dátum-idő ISO8601 formátumban

# Két arg-t mindenképp meg kell adni: melyik adatot, és hová írjuk

write_csv(not_cancelled, "output.csv")

ch_again <- read_csv("challenge_out.csv")

# Az oszlopok típusa elveszett időközben!
# Mikor lehet ez zavaró?

# Alternatívák:

# a, RDS (R saját bináris fájlformátuma)

write_rds(challenge, "challenge_out.RDS")

(ch_rds <- read_rds("challenge_out.RDS"))

# b, feather (gyors bináris fájlformátum, más nyelvek is "értik")

write_feather(challenge, "challenge.feather")

read_feather("challenge.feather")

# További adattípusok (xls, xlsx, SPSS, SAS, Stata, ...) 
# http://r4ds.had.co.nz/data-import.html#other-types-of-data 
# https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf 
