# Data wrangling

library(tidyverse)


# 1. Adatrendezes (tidy data) ---------------------------------------------

# Ugyanaz az adat tobbfelekeppen is tárolható

table1
table2
table3
table4a; table4b

# Mitol lesz rendezett (tidy) az adat?
# 1. Minden valtozo kulon oszlop
# 2. Minden megfigyeles kulon sor
# 3. Minden ertek kulon cella

# A fenti 4 pelda kozul melyik tekintheto tidy-nak (rendezettnek)?

# Konzisztensen rendezett adatok segitik altalanos elvek alkalmazasat,
# amikor az adatokkal dolgozunk
# tidyverse csomagjai feltetelezik az adatok rendezettseget

# Pl. 10 000 fore eso gyakorisagi arany
table1 %>% 
    mutate(rate = cases / population * 10000)

# Vagy az evenkenti esetek szama
table1 %>% 
    count(year, wt = cases)

# Valtozas egy ev alatt
ggplot(table1, aes(year, cases)) + 
    geom_line(aes(group = country), colour = "grey50") + 
    geom_point(aes(colour = country))

# Hogyan készítenétek el ugyanezeket a kimutatásokat és
# az ábrát table2, ill. table4a és table4b alapján?


# 1.1 Szetterites es osszegyujtes -------------------------------------------

# Az adatok sajnos a legtöbbször nincsenek tidy formátumba rendezve.
# Miért?
# Sokan nem ismerik, és nem evidens
# Az adatok rendezése sokszor nem az elemzést, hanem a bevitelt segíti


# Hogyan tudjuk tidy formátumba rendezni az adatokat?

# 1. lépés: Mik a változók és a megfigyelések?

# 2. lépés: Két probléma lehet:
# - egy változóhoz tartozó adatok több oszlopban lehetnek
# - egy megfigyelés több sorba is szét lehet szóródva
# Általában egyszerre csak az egyik áll fenn.

# Ezeket a problémákat orvosolja a tidyr két alapvető függvénye:
# gather() és spread()
  
# gather (=összegyűjtés): ha az oszlopnevek egy változó értékeit veszik fel

table4a

# Három fontos paraméter:

# - Melyek az oszlopok, amikben nem változók, hanem értékek vannak?
# - Mi az a változó, aminek az értékeit a változónevek ebben a táblában? (key)
# - Mi az a változó, aminek az értékei a cellákban vannak? (value)

table4a %>% 
    gather(`1999`, `2000`, key = "year", value = "cases")

# Az oszlopokat úgy határozzuk meg, mint a dplyr::select()-nél.


# Hasonloan eljarhatunk a table4b eseteben is, csak itt ugye
# egy másik változó értékei vannak a cellákban, módosítsuk a value paramétert!

table4b %>% 
    gather(`1999`, `2000`, key = "year", value = "population")

# Ahhoz, hogy egy tibble-be kerüljenek az adataink, hasznaljuk a left_join()-t

tidy4a <- table4a %>% 
    gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
    gather(`1999`, `2000`, key = "year", value = "population")

left_join(tidy4a, tidy4b)

# Kicsit később lesz szó a join függvényekről is!

# spread (=szétterítés): ha van egy oszlop, 
# amiben változók nevei szerepelnek

table2

# Most két dolog fontos:
# - Melyik az az oszlop, amelyik a változók neveit tartalmazza? (key)
# - Melyik az az oszlop, ami több változó értékeit is tartalmazza? (value)

spread(table2, key = type, value = count)

# gather: szélesből hosszúba (wide to long)
# spread: hosszúból szélesbe (long to wide)


# 1.1.1 Gyakorlas - spread es gather --------------------------------------

# 1) Rendezd a preg adatokat tidy formátumba!

preg <- tribble(
    ~pregnant, ~male, ~female,
    "yes",     NA,    10,
    "no",      20,    12
)


# 2) Miért nem tökéletesen szimmetrikus a gather és a spread? 

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

# 3) Miért nem lehet szétteríteni ezt a táblát? Mit kellene tenni, hogy lehessen

people <- tribble(
  ~name,             ~key,    ~value, 
  #-----------------|--------|------
  "Phillip Woods",   "age",       45, 
  "Phillip Woods",   "height",   186, 
  "Phillip Woods",   "age",       50, 
  "Jessica Cordero", "age",       37, 
  "Jessica Cordero", "height",   156
)


# 1.2 Elválasztás es egyesítés --------------------------------------------

# Előfordulhat az is, hogy egy oszlopban több változó értéke is szerepel!

table3

# Ilyenkor jön jól a separate()

table3 %>% 
    separate(rate, into = c("cases", "population"))

# A separate() elvalasztokent azonosítja a nem-alfanumerikus karaktereket.
# Az elválasztót meg is adhatjuk:

table3 %>% 
    separate(rate, into = c("cases", "population"), sep = "/")

# Hoppa! A szamok karakterkent kepezodtek le 
# - mert ugye karakterkent voltak a forrasban, és alapesetben
# a separate() nem változtatja meg az oszlopok típusát
# convert=TRUE: megprobalja jobb adattipusra alakitani 
# az oszlopot az elvalasztas utan

table3 %>% 
    separate(rate, into = c("cases", "population"), convert = TRUE)

# sep argumentumnak egész számokkal azt is megadhatjuk, hogy
# hány karakterenként vágjon:

table3 %>% 
    separate(year, into = c("century", "year"), sep = 2)

# Ez itt most nem túl hasznos, de van, amikor jól jöhet!

# unite() (=egyesítés): több oszlopból egy értéket

table5

table5 %>% 
  unite(new, century, year)

# Alapértelmezett szeparátor: _ 
# Ha nem szeretnénk szeparátort:

table5 %>% 
    unite(new, century, year, sep="")



# 1.2.1 Gyakorlás - elválasztás és egyesítés ------------------------------

# 1) Mit tud a separate() extra és fill argumentuma?

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))


tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))



# 1.3 Hiányzó adatok  -----------------------------------------------------

# Hiányzó adatok kétféleképpen lehetnek jelen az adattáblában:
# - Explicit: NA-val jelölve (a hiány jelenléte)
# - Implicit: egyszerűen csak nincs meg az adat (a jelenlét hiánya)

# A lenti peldaban hol vannak ilyenek?

stocks <- tibble(
    year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
    qtr    = c(   1,    2,    3,    4,    2,    3,    4),
    return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# Másfajta elrendezés explicitté teheti az összes hiányzó adatot

stocks %>% 
    spread(year, return)

# Ha a hianyzo adatok explicit megjelenitese nem erdekes, implicitte tehetjuk
# gather(na.rm = TRUE)

stocks %>% 
    spread(year, return) %>% 
    gather(year, return, `2015`:`2016`, na.rm = TRUE)

stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`)


# Az implicit hiányzó adatokat explicitté tehetjük a complete()-tal is:

stocks %>% 
    complete(year, qtr)

# Meg egy fontos dolog: 
# hianyzo adatok "macskakormozest" is jelenthetnek 
# (adatbeviteli gyakorlat)

treatment <- tribble(
    ~ person,           ~ treatment, ~response,
    "Derrick Whitmore", 1,           7,
    NA,                 2,           10,
    NA,                 3,           9,
    "Katherine Burke",  1,           4
)

# Ilyenkor használjuk a fill()-t!

treatment %>% 
    fill(person)

# Fentről lefelé haladva a megadott oszlopban a hiányzó értékeket
# a legutolsó nem hiányzó értékkel helyettesíti be
# ("last observation carried forward" módszer)

# fill() .direction argumentuma:

treatment %>% 
  fill(person, .direction = "up")


# Még a tidy formátumról: www.jstatsoft.org/v59/i10/paper 
# A nem-tidy formátumokról: https://simplystatistics.org/2016/02/17/non-tidy-data/ 


# 2. Adattablak kapcsolasa ------------------------------------------------

library(nycflights13)

# Az adataink gyakran több adattáblában vannak.
# Pl. jegyzőkonyv + kísérleti eredmények + kérdőívek. 

# nycflights13 csomagban több tibble is van:
airlines
airports
planes
weather

# Hogyan kapcsolódnak egymáshoz ezek a táblák?
# http://r4ds.had.co.nz/diagrams/relational-nycflights.png

# Az adattablakat "kulcsok" (keys) segitsegevel köthetjük össze
# Kulcs: olyan változó (vagy változóhalmaz), 
# ami egy megfigyelés azonosítására alkalmas
# 
# Elsodleges (primary) kulcsok: 
#   egyertelmuen azonositanak egy megfigyelest adott tablan belul
#   pl. planes$tailnum
# Idegen (foreign) kulcsok: 
#   egyertelmuen azonositanak egy megfigyelest egy masik tablan 
#   pl. flights$tailnum 
# 
# Egy valtozo lehet egyszerre mindketto is!
# 
# Egy elsődleges kulcs és egy másik tábla idegen kulcsa 
# együttesen alkotnak egy kapcsolatot

# Ha azonositottunk egy elsodleges kulcsot, 
# erdemes ellenorizni, hogy tenyleg egyedi-e.
# Nem tartozik-e veletlenul tobb megfigyeleshez is?

planes %>% 
    count(tailnum) %>% 
    filter(n > 1)

weather %>% 
    count(year, month, day, hour, origin) %>% 
    filter(n > 1)

# Előfordulhat, hogy egy táblában nincs elsődleges kulcs!
# A járatszám / gép sorszáma + dátum elsődleges kulcs a flights táblában? 






# Ilyenkor célszerű létrehozni minden megfigyelésnek egy sorszámot 
# (mesterséges/helyettesítő kulcs  = surrogate key)

stocks %>% 
  mutate(
    rownumm = row_number()
  )


# 2.1 Mutating join -------------------------------------------------------

# Egyezteti a megfigyeleseket a kulcsok alapjan, aztan 
# egyik táblából a másikba masol valtozokat

# Hasznaljunk egy keskenyebb tablat, 
# hogy jol lassuk a kapcsolasok eredmenyet:

flights2 <- flights %>% 
    select(year:day, hour, origin, dest, tailnum, carrier)

flights2

# Pl. légitársaság teljes nevét (airlines tábla) 
# adjuk hozzá a flights2 táblához:

flights2 %>%
    select(-origin, -dest) %>% 
    left_join(airlines, by = "carrier")

# Ugyanezt megoldhattuk volna a mutate használatával is,
# igaz, kevésbé átlátható, és több változóval sokkal bonyolultabb lenne

flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# A kapcsolások alapjait ezeken az egyszerű táblákon fogjuk szemlélteni:

x <- tribble(
    ~nev, ~kor,
    "Anna", "20",
    "Béla", "30",
    "Csaba", "40"
)

y <- tribble(
    ~nev, ~macska,
    "Anna", 0,
    "Béla", 4,
    "Dávid", 1
)

z <- tribble(
    ~nev, ~kedvenc_szine,
    "Anna", "kék",
    "Béla", "piros",
    "Zsuzsi", "szürke"
)

# Inner join
# Csak a mindkét táblában meglévő megfigyeléseket tartja meg

x %>% 
    inner_join(y, by = "nev")

# Outer join
# Akkor tart meg egy megfigyelést, 
# ha az legalább az egyik táblában előfordult
# http://r4ds.had.co.nz/diagrams/join-outer.png 

# left_join(): az összes bal oldali táblában meglévő megfigyelést megtartja

x %>% 
    left_join(y,  by = "nev") 

# right_join(): a jobb oldali táblából tartja meg az összes megfigyelést

x %>% 
    right_join(y, by = "nev") 

# full_join(): mindkét tábla összes megfigyelését megtartja

x %>% 
    full_join(y, by = "nev")

# join-ok Venn-diagramon: http://r4ds.had.co.nz/diagrams/join-venn.png 

# Mi történik, ha a kulcsok nem azonosítanak egyértelműen egy megfigyelést?

# A) Egyik tablaban duplikalt, masikban egyedi
# pl. ha egy külön táblában tárolunk extra információt
# egy-kapcsolódik-sokhoz (pl. járatok-repterek)

x <- tribble(
    ~nev, ~mai_ebed,
    "Anna", "rakott krumpli",
    "Béla", "tökfőzelék",
    "Béla", "pörkölt",
    "Anna", "szendvics"
)

y <- tribble(
    ~nev, ~uni,
    "Anna", "BME",
    "Béla", "ELTE"
)

left_join(x, y, by = "nev")

# B) Mindket tablaban duplan van egy kulcs: 
# ez altalaban hiba, mert a kulcs egyik táblában sem elsődleges.
# Ha ezeket egyesitjuk, az osszes lehetseges kombinaciot megkapjuk

x <- tribble(
    ~nev, ~kor,
    "Anna", "20",
    "Béla", "30",
    "Béla", "50",
    "Csaba", "40"
)

y <- tribble(
    ~nev, ~testtomeg,
    "Anna",  "60",
    "Béla",  "80",
    "Béla",  "100",
    "Csaba", "90"
)

left_join(x, y, by = "nev")

# Kulcsok meghatarozasa *_join() fuggvenyek by argumentuma

# A) Alapbeallitas: by=NULL. Minden kozos valtozot felhasznal (natural join)

flights2 %>% 
    left_join(weather)

# B) Karaktervektorral meghatarozva
# Pl year valtozo van mindket tibble-ben, de nem ugyanazt jelenti!

flights2 %>% 
    left_join(planes, by = "tailnum")

# C) Nevesitett karaktervektorral pl. c("a" = "b")

# Célállomás koordinátáit kapcsoljuk:

flights2 %>% 
    left_join(airports, c("dest" = "faa"))

# Kiinduló állomás koordinátáit kapcsoljuk:

flights2 %>% 
  left_join(airports, c("origin" = "faa"))


# 2.1.1 Gyakorlás - mutating join -----------------------------------------

# 1) Van-e összefüggés egy repülőgép életkora és a késései között?




# 2) Az időjárásnak milyen vonatkozásai függenek össze az indulási késéssel?


  

# 2.2 Filtering join ------------------------------------------------------

# A logika hasonló, mint a mutating join-nak,
# de csak a megfigyelésekre van hatással

# semi_join(x, y) - megtart minden megfigyelést x-ből, aminek van párja y-ban

# anti_join(x, y) - kidob minden megfigyelést x-ből, aminek van párja y-ban

# Melyik a tíz legfrekventáltabb reptér?

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

# Melyik járatok mentek ezekre a repterekre?

# Használhatnánk egy filtert:

flights %>% 
  filter(dest %in% top_dest$dest)

# Több változóval nehezebb lenne 
# (pl. megkeresni a top10 napot napi átlag késés mentén),
# ezért jobb a semi_join:

flights %>% 
  semi_join(top_dest)

# az anti_join pedig hasznos lehet, 
# ha a kapcsolás során az egyezés hiányát akarjuk megnézni

# Melyik járatoknak nincs párja a planes táblában?

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)


# 2.2.1 Gyakorlás - filtering join ----------------------------------------

# 1) Szűrd le a flights táblát úgy, hogy csak azok a gépek járatai maradjanak benne,
# amik legalább 100 utat megtettek!



# 2) Találd meg az évnek azt a 48 óráját, amikor a legtöbbet késtek a gépek!
# Kösd össze a weather táblával. Látsz-e mintázatokat?