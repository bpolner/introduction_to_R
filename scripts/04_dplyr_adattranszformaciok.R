####  Transzformaciok a dplyr csomag hasznalataval


library(tidyverse)
library(nycflights13)


#### 0. Elokeszuletek es alapok ----------------------------------------------

# A dplyr szintaxisanak alapjai:

# Sorok kivalasztasa ertekeik alapjan: filter().
# Sorok ujrarendezese: arrange().
# Valtozok kivalasztasa nev szerint: select().
# Letezo valtozok alapjan uj valtozok szamolasa: mutate().
# Egy osszefoglalo szamolasa sok ertekbol: summarise().

# Műveletek csoportonként: group_by().

# Működésük: 
# Első argumentum mindig egy adattábla 
# Következő argumentumok: mit tegyünk az adattal, melyik változókkal (idézőjel nélkül)
# Eredményül mindig egy adattáblát (data.frame) kapunk vissza

# A flights adattáblán fogjuk kipróbálni, hogy mit tud a dplyr:

flights
# valtozok nevei alatti roviditesek jelzik a valtozok tipusat
# int - integer = egesz szam
# dbl - double = valos szam
# chr - character = betulancok (strings)
# dttm - date-time = datum es ido
# lgl - logical = logikai
# fctr - factor = kategorikus valtozok fix lehetseges ertekekkel
# date - date = datum

# A konzolon nem látszik sem az összes változó, sem az összes sor
# Ha jobban meg akarjuk nézni az adattáblát:

View(flights)

#### 1. Sorok szurese: filter()  --------------------------------

# 1. arg.: adat, következő arg.(ok): szűrési feltételek kifejezése

# Jaratok jan. elsejen:

filter(flights, month == 1, day == 1)

# A dplyr függvények sosem módosítják a bemenetet. 
# Az eredmény tárolásához hozzá kell rendeljük egy változóhoz: 
# <- a hozzárendelés jele, RStudioban (Win): alt + "-" az alap gyorsbillentyű
# (További gyorsbillentyűk: Tools / Keyboard shortcuts help)

jan1 <- filter(flights, month == 1, day == 1)

# Egyszerre taroljuk, es nezzuk is meg a szűrés eredményét: 
# az egész hozzárendelést ()-be csomagoljuk

(dec25 <- filter(flights, month == 12, day == 25))

# Osszehasonlitasok logikai operatorokkal:
# < , > , <= , >= , != , ==

# Vigyazat! Logikai vizsgálathoz kettő egyenlőségjel kell!

filter(flights, month = 1)

# Anomáliák a == használata során tizedestörtekkel:

sqrt(2)^2 == 2
1/49 * 49 == 1

# Az oka a szamitogep veges pontossaga. 
# A problema megkerulheto a near() hasznalataval.

near(sqrt(2)^2, 2)
near(1 / 49 * 49, 1)

# Szűrési feltételek kombinálása logikai operátorokkal:
# http://r4ds.had.co.nz/diagrams/transform-logical.png 
# & , | , ! , xor

filter(flights, month == 11 | month == 12 | month == 3 | month == 1)

# Tobb lehetseges ertek felsorolasa roviden (a fentivel ekvivalens)
# (month értéke eleme a vektorral megadott halmaznak)

nov_dec_mar_jan <- filter(flights, month %in% c(11, 12, 3, 1))


# A hiányzó értékek (NA mint "not available") megkeseríthetik az életünket, 
# ha összehasonlításokat végzünk
# a legtöbb műveletre igaz, hogy ha egy NA keveredik bele, akkor a kimenet is NA lesz

NA > 5
10 == NA
NA + 10
NA / 2

# Ami igazán zavarbaejtő:

NA == NA

  
# Kontextusba helyezve könnyebben érthető:
# Legyen x Anna életkora, ami nem ismert

x <- NA

# Legyen y Béla életkora, ami szintén nem ismert

y <- NA

# Egyidős Anna és Béla?

x == y

# Nem tudhatjuk!


# Hiányzik-e az adott érték: is.na()

is.na(x)

# a filter csak azokat a sorokat tartja meg, ahol a logikai vizsgálat TRUE
# ahol FALSE vagy NA, azokat eldobja
# Ha meg akarjuk tartani a sorokat, ahol hiányzó érték van, ezt explicitté kell tenni

# Egy mini példa-adat
df <- tibble(x = c(1, NA, 3))
# Így néz ki
df

# Alapbó a filter eldobja az NA-t
filter(df, x > 1)

# Külön jelezni kell, ha az NA-t is meg akarjuk tartani
filter(df, is.na(x) | x > 1)


# 1.1 Gyakorlas - filter() ------------------------------------------------

# 1) Valasszuk ki az osszes jaratot, ami
# a, legalabb 2 ora kesessel erkezetett


# b, nyaron repult (junius, julius, augusztus)


# c, tobb, mint ket orat kesett, pedig pontosan indult


# d, a JFK repülőtérről indult, de nem Miamiba (MIA) érkezett


# e, éjfél és reggel 6 között indult (pontban éjfél és reggel 6 is legyenek benne)


# 2) Mire jo a between() fuggveny? Tudnád-e a fenti kereséseket egyszerűsíteni vele? 


# 3) Hany jaratnak hianyzik az indulasi ideje (dep_time)?





#### 2. Sorok sorbarendezese: arrange() ------------------------

arrange(flights, year, month, day)


# Csokkeno sorrend:

arrange(flights, desc(arr_delay))

# Hianyzo ertekek mindig hatulra kerulnek:

df <- tibble(x = c(5, 2, NA))
df
arrange(df, x)
arrange(df, desc(x))



# 2.1 Gyakorlas - arrange() -----------------------------------------------

# Válaszolj az 1) és 2) kérdésre a flights táblát sorbarendezve!

# 1) Melyik jaratok kestek a legtobbet? Es melyek indultak el leghamarabb?


# 2) Melyik jaratok repultek a legmesszebbre? Es a legkisebb tavolsagra?


# 3) Hogyan lehetne az arrange() függvénnyel a hiányzó értékeket előrehozni? 



#### 3. Valtozok kivalasztasa: select() --------------------------------------

select(flights, year, month, day)

# Ket valtozo, es a koztuk levok is

select(flights, year:day)

# Valtozok kihajitasa

select(flights, -(year:day))

# Hasznos segedfuggvenyek https://dplyr.tidyverse.org/reference/select.html

# Mivel kezdődik a változó neve
select(flights, starts_with("dep"))

# Hogyan végződik a változó neve
select(flights, ends_with("time"))

# Szerepel a változó nevében
select(flights, contains("arr_") )


# Valtozok atnevezesehez: rename() (a többit változót megtartja)

rename(flights, tail_num = tailnum)

# Kiválasztás közben is átnevezhetjük az oszlopokat:

select(flights, tail_num = tailnum)

# Ha nehany valtozot az adattábla elejere akarunk tenni, az összes 
# többit meg csak egyben megfogni: everything()

select(flights, time_hour, air_time, everything())



# 3.1 Gyakorlás: select() -------------------------------------------------

# 1) Tedd előre a flights adattábla azon oszlopait, melyekben késéssel 
# kapcsolatos információ van! Utána következzenek azok az oszlopok, 
# amelyek nevében szerepel a "time"! A táblából vedd ki a légitársaság, a 
# járat, és a gép azonosítóit, illetve az induló- és a célállomást!
# Próbáld meg minél többféle módon megoldani! 


# 2) Válaszd ki flights tábla year, month, day változóit
# Ugyanebben a lépésben nevezd át az oszlopokat: a year legyen ev, a month honap, a day nap!


# 3) Nevezd át a dep_time változót indulas-ra egy paranccsal úgy, hogy megtartod az összes oszlopot, az eredeti sorrendben!


# 4) Válaszd ki a flights tábla második, ötödik, és tizenegyedik oszlopát! 
# Használd a select függvényt, de a változók neveit nem használhatod!


# 5) Meglepő eredményt ad ez a kód? 
# Mi a segédfüggvények alapbeállítása a kisbetű/nagybetű kezelésére?
# Hogyan lehet megváltoztatni? 

select(flights, contains("TIME"))

# 6) Mire jó az any_of()? Mire lehet jó, ha ezzel a vektorral együtt használjuk? 
  
valtozok <- c("year", "month", "day", "dep_delay", "arr_delay", "evszam")


#### 4. Uj valtozok szamolasa: mutate() --------------------------------------

# Válasszunk ki néhány oszlopot, hogy a konzolon is jól lássuk, 
# mi történik!

flights_sml <- 
  select(
    flights, 
    year:day, 
    ends_with("delay"), 
    distance, 
    air_time
  )


# Uj valtozok szamolasa

mutate(
  flights_sml,
  gain = arr_delay - dep_delay,    # mennyi késést szedett fel menet közben a gép?
  speed = distance / air_time * 60 # átlagos sebesség (mérföld / óra)
)


# Egy mutate-n belül utalhatunk akar az eppen letrehozott valtozokra is!

mutate(
  flights_sml,
  gain = arr_delay - dep_delay, # mennyi késést szedett fel menet közben a gép?
  hours = air_time / 60,        # hány órát volt a levegőben a gép?
  gain_per_hour = gain / hours  # óráként átlagosan mennyivel nőtt a késés?
)


# transmute: ha csak a létrehozott változókat akarod visszakapni:

transmute(
  flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)


# mutate()-n belül bármilyen vektorizált függvény használható
# (azaz bemenete vektor és egyező hosszúságú vektort ad vissza)
# Bővebben: https://r4ds.had.co.nz/transform.html#add-new-variables-with-mutate 5.5.1

# Néhány hasznos példa

# A) aritmetikai műveletek: + - * / ^ 
# - vektorizáltak az újrafelhasználási szabályok szerint:
# ha az egyik paraméter rövidebb, automatikusan meg lesz hosszabbítva, hogy egyforma hosszúak legyenek
# ez jól jön, ha pl. konstanssal akarunk osztani pl. percek száma / 60 
# vagy ha az átlagtól való eltérést akarjuk kiszámolni y - mean(y)

# B) moduláris aritmetika

# maradékos osztás 

6 %/% 4

# maradékképzés 

6 %% 4

# C) logaritmus log() log2() log10() 

# D) eltolások

(x <- 1:10)
lag(x)
lead(x)

# Különbség az előző elemtől

x - lag(x)

# Eltér-e az előző elemtől?

x != lag(x)

# E) kumulált és gördülő aggregálás (összeg, szorzat, min, max, átlag)
# Kumulált összeg és átlag pl.: 
x

cumsum(x)

cummean(x)

# RccpRoll csomagban: gördülő aggregálás

# F) logikai vizsgálat

# G) Rangsorolás pl. 

y <- c(1, 2, 2, NA, 3, 4)

min_rank(y)

min_rank(desc(y))

# 4.1 Gyakorlás: mutate() -------------------------------------------------


# 1) Számold ki újra az indulási és érkezési késést! 
# Előtte gondolkozz el azon, hogy ehhez megfelelő formátumban vannak-e a tárolva az indulási és érkezési információk? 
# Ha kell, a számítás előtt alakítsd át őket!

# 2) Miért kapjuk az alábbi eredményt?

1:3 + 1:10



#### 5. Összefoglalások: summarise() ----------------------------

# A summarise() bemenete egy adattábla (data.frame), és visszaad egyetlen sort!

summarise(
  flights, 
  delay = mean(dep_delay, na.rm = TRUE)
)

# Akkor igazán hasznos, ha a group_by()-al egyutt hasznaljuk

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# Mit csinalt a group_by() ?

class(flights)
class(by_day)


## 5.1 Tobb muvelet osszekotese a pipe (%>%) hasznalataval  -------------------

# Hogyan függ össze a célállomásonkénti átlagos késés azza, hogy milyen messze van a célállomás?
# Csak azokat a célállomásokat vegyük figyelembe, amelyeknél több, mint 20 járatról vannak adataink!
# Honolulut (HNL) ne vegyük figyelembe! 

by_dest <- group_by(flights, dest)

delay <- 
  summarise(
    by_dest,
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  )

delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# Ez most 4 lepes volt: adatok csoportositasa, osszegzes, szures, majd ábrázolás.
# A koztes adattáblák foloslegesek, ráadásul a dolgokat elnevezni fárasztó.
# Szóval jo lenne kihagyni oket.

# Na erre lesz jó a pipe azaz a %>% (CTRL + SHIFT + M az RStudio-ban Win alatt)

flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist  = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL") %>% 
  ggplot(mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


# Mit csinal a %>% ?
# x %>% f(y) = f(x, y)
# Olvashatjuk úgy is, hogy %>% = "aztán": 
# csoportosítsd, AZTÁN összegezd, AZTÁN szűrd, AZTÁN ábrázold

# Hianyzo adatok szurese

# Mire volt jó fentebb az na.rm = TRUE?

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Az aggregációs függvényekre is érvényes:
# ha hiányos adatsort kapnak, NA-t adnak vissza

# A flights adattáblában a hianyzo keses a lemondott jaratoknal szerepel
# Egy megoldás lehet, ha kihajítjuk ezeket a sorokat:
  
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month) %>% 
  summarise(mean = mean(dep_delay))

#  Aggregálásnál érdemes figyelni, hogy mennyi adat alapján készült
#  Erre jó a n() vagy a nem-hiányzó értékek számolása sum(!is.na(x))

# Nezzuk meg mondjuk gepenkent (tailnum) az atl. indulasi kesest!

delays <- 
  not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

# Van olyan gep, ahol az ATLAG indulasi keses ~5 ora!

# Aggregációknál érdemes megnézni, hány megfigyelést összegeztünk.
# Hany ut alapjan lett az atlag keses megallapitva?

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Jellemző mintázat: mintanagyság növekedésével csökken az összegző statisztika szóródása
# Aggregalasnal mindig erdemes rogziteni az esetek szamat: 
# n() vagy sum(!is.na())

# Szűrjük a kevés megfigyelésen alapuló átlagokat, és aztán ábrázoljunk

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Aggregalas es logikai indexeles egyutt:

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # az átlagos pozitív késés
  )


## 5.2 Leiro statisztikak keszitesenel hasznos fuggvenyek. -----------------

# Középérték: mean, median

# Szorodas

?sd
?IQR

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Rang

?min
quantile(1:6, probs = 0.33)
?max

# Keressük meg minden napra az első és utolsó indulás idejét!

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

# Pozíció: first(2), nth(x, 2), last(x)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

# Ezt kiegészíti a rangokra szűrés
# Ilyenkor minden megfigyelés külön sorban marad

not_cancelled %>% 
  group_by(year, month, day) %>% 
  # Minden napon belül rangsorolunk indulási idő szerint
  mutate(r = min_rank(dep_time)) %>% 
  # Azokat a sorokat tartjuk meg, amik adott napon belül a legkisebb 
  # és a legnagyobb rangot kapták
  filter(r %in% range(r)) %>% 
  select(year:day, dep_time, r)

# Darabszam

?n # darabszám
?n_distinct # egyedi esetek


# Melyik célállomásra jár a legtöbb légitársaság?

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

# Darabszam gyorsan - hany jarat ment az egyes celallomasokra?

not_cancelled %>% 
  count(dest)

# Sulyozassal - hány mérföldet repultek az egyes celallomasokra osszesen?

not_cancelled %>% 
  count(dest, wt = distance)

# Feltetelnek megfelelo esetek száma és aránya, pl.:  
# Az egyes napokon hány járat indult 5:00 előtt?

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# Mi történt? 
# Amikor numerikus bemenetet váró függvényeknek logikai értékeket adunk, 
# akkor IGAZ = 1 és HAMIS = 0

# Az adott hónapban a gépek hány %-a indult 20:00 után?




# Csoportosítás több változó mentén

daily <- group_by(flights, year, month, day)

# több summarise-zal fokozatosan lehet felgöngyölni az adattáblát

(per_day   <- summarise(daily, flights = n())) # ez már csak év és hónap szerint van csoportosítva!

(per_month <- summarise(per_day, flights = sum(flights))) # ez pedig már csak év szerint! 

(per_year  <- summarise(per_month, flights = sum(flights))) 


# Csoportositas megszuntetese

daily %>% 
  ungroup() %>%             # megszűnt a csoportosítás
  summarise(flights = n())  # összes járat számát kapjuk vissza


# 5.3 Gyakorlás: summarise() ----------------------------------------------


# 1) Hozz létre a lentiek eredményét a count() használata nélkül!

not_cancelled %>% 
  count(dest)


not_cancelled %>%
  count(tailnum, wt = distance)


# 2) A törölt járatok meghatározása (is.na(dep_delay) | is.na(arr_delay) ) 
# nem a legoptimálisabb. Miért? 


# 3) Nézd meg a hónap napjai szerinti bontásban a lemondott járatok számát.
# Látsz-e valamilyen mintázatot? 
# A lemondott járatok aránya összefügg-e az átlagos késéssel?



# 4) Melyik légitársaság (carrier) késik a legtöbbet? 
# El tudjuk-e különíteni a rossz repterek vs. a rossz légitársaságok
# hatását? Miért / miért nem?
# (Tipp: flights %>% group_by(carrier, dest) %>% summarise(n()))



# 6. Haladó dplyr ------------------------------------------------------------


# 6.1 Több oszlop transzformálása röviden ----

# http://dplyr.tidyverse.org/reference/summarise_all.html 


# 1) Az összes oszlopra:

iris %>% 
  group_by(Species) %>% 
  summarise_all(median)

# Több összefoglalás egyszerre:

# a) függvények felsorolása egy listában

iris %>% 
  group_by(Species) %>% 
  summarise_all(list("Med" = median, "M" = mean))

# b) függvények nevének megadása karaktervektorban

iris %>% 
  group_by(Species) %>% 
  summarise_all(c("median", "mean"))


# 2) Megadott feltételtől függően:

# Átlag számítása az összes valós számot tartalmazó oszlopra

flights %>% 
  summarise_if(is.double, mean, na.rm = TRUE)

# Karaktereket tartalmazó változók faktorrá alakítása

flights %>% 
  mutate_if(is.character, as.factor)

# 3) Oszlopok neve alapján:

# a) select()-ben használt módszerrel a vars()-on belül (segédfüggvények is működnek!)

flights %>%
  summarise_at(vars(dep_time:arr_time), max, na.rm = T)

flights %>% 
  summarise_at(vars(ends_with("delay")), mean, na.rm = TRUE)

# b) karaktervektorral megadva

flights %>% 
  summarise_at(c("arr_delay", "dep_delay"), mean, na.rm = TRUE)


# 6.2 Műveletek es szűrők csoportosítással ----

# Minden napra a 3 legtöbbet késő járat kikeresése:

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 4)


# Kuszobnel nagyobb csoportok meghatarozasa
# Pl. csak a népszerű célállomások:

popular_dests <- 
  flights %>% 
  group_by(dest) %>% 
  filter(n() > 3000)

popular_dests

# Standardizalas es csoportokon beluli mutatok szamolasa

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay) 