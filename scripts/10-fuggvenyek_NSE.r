# 0.1 Libraryk behívása ----------

require("dplyr")
require("lazyeval")
require("ggplot2")
require("purrr")
require("gridExtra")

# 0.2 Ismétlés ----------
# Írjunk olyan parancsot, ami tetszőleges hosszúságú Fibonacci számsort állít elő!
# Fibonacci-sor:
# Olyan sorozat, amely minden n-edik elemének értéke megegyezik az n-1-edik
# és az n-2-edik elem összegével:
# 0, 1, 1, 2, 3, 5, 8, 13, 21, stb.
# Íjrunk egy olyan parancsot, ami megkeresi az x-nél kisebb összes prímszámot!

fib <- c(0,1)
for (i in 3:20) {
  fib[[i]] <- fib[[i-1]] + fib[[i-2]]
  print(i)
  print(fib)
}
plot(1:20,fib,type='l')
# 1. Függvények ----
# Hogyan tudjuk megoldani azt, hogy ugyanazt a parancsot tetszőleges változón,
# vagy bemeneti értéken hajtsuk végre?

x = 99
if (x > 100) {
    print("Juhu, a szam nagyobb szaznal.")
} else if (x == 100) {
    print("Hoho, a szam pont 100!")
} else {
    print("Sajnos a szam kisebb 100-nal")
}

# Jó lenne egy olyan parancs, pléldáulaminek a neve például check100,
# ahova csak beírom a számot és megmondja a választ a kérdésre így:

#     x=99
#     check100(x)
#     output: [1] "A szám kisebb, mint száz!"

# A megoldás: függvény!
# Végrehajtja nekünk ugyanazt a parancsot, tetszőleges bemenettel
# Működése:

#     <<bemenet>> --> függvény --> <<kimenet>>
#     
# Szintaxisa:

#     függvény_név <- function(argumentum) {
#       kimeneti_érték <- csinálj-valamit-az-argumentummal
#       return(kimeneti_érték)
#     }

adj_hozza_egyet <- function(x) {
  x + 1
}

adj_hozza_egyet(3)

check_100 <- function(szam) {
    if (szam > 100) {
        szoveg <- "Juhu, a szam nagyobb szaznal."
    } else if (szam == 100) {
        szoveg <- "Hoho, a szam pont 100!"
    } else {
        szoveg  <-"Sajnos a szam kisebb 100-nal"
    }
    return(szoveg)
}

check_100(77)

check_100(100)

check_100(1000)

# 1.1 Lokális és globális változók --------
# Ha a függvényen belül létrehozunk egy változót, azt nem tudjuk a függvényen kívül elérni!!!

# Miért más az eredménye az alábbi két parancs végrehajtásának?


szoveg <- 'semmi'
szam <- 77

if (szam > 100) {
    szoveg <- "Juhu, a szam nagyobb szaznal."
} else if (szam == 100) {
    szoveg <- "Hoho, a szam pont 100!"
} else {
    szoveg <- "Sajnos a szam kisebb 100-nal"
}

print(szoveg)

szam <- 77
szoveg <- 'semmi'

check_100 <- function(szam) {
    if (szam > 100) {
        szoveg <- "Juhu, a szam nagyobb szaznal."
    } else if (szam == 100) {
        szoveg <- "Hoho, a szam pont 100!"
    } else {
        szoveg <- "Sajnos a szam kisebb 100-nal"
    }
    return(szoveg)
}

check_100(77)
print(szoveg)

# A <<- hozzárendelés globális változót csinál a változóból,
# amihez az értéket rendeljük, így azt a függvényen kívülről is elérjük:

szoveg <- 'semmi'

check_100 <- function(szam) {
    if (szam > 100) {
        szoveg <<- "Juhu, a szam nagyobb szaznal."
    } else if (szam == 100) {
        szoveg <<- "Hoho, a szam pont 100!"
    } else {
        szoveg <<- "Sajnos a szam kisebb 100-nal"
    }
    return(szoveg)
}

check_100(77)
print(szoveg)

# Működőképes lehet a következő függvény?
x <- c(1,2)

append_x <- function(number) {
    x <- append(x,number)
}

append_x(3)
print(x)

# Hogy lehetne működőképessé tenni?


append_x(3)
print(x)

adj_nullat <- function(){
  return(0)
}

x <- adj_nullat()
x

# 1.2 Feladatok --------

# Írjunk olyan függvényt, ami az adott számra megmondja nekünk,
# hogy az pozitív, negatív, vagy 0!


# Írjunk a Fibonacci sorozatra függvényt, ami tetszőleges szám beadására
# kiadja az annak megfelelő hosszúságú Fibonacci-sort, pl.:

#     fib(8)
#     Output: [1] 0,1,1,2,3,5,8,13

x <- fib(fib_hossz=8)
x
# 2 A tanultak alkalmazása elemzésnél ----

# 2.1 Statisztikai függvények --------
# Készíthetünk függvényeket különböző statisztikai problémákra

# Példa:
# A standard hiba kiszámításához szükség van a szórás [sd()],
# az elemszám [length()] és a gyök [sqrt] függvények kombinálására:

mtcars$mpg

sem <- function(data) {
    return(sd(data)/sqrt(length(data)))
}

sem(mtcars$mpg)

# De kiszámíthatjuk a konfidencia-intervallumot is!
# A konfidencia intervallum n>30 esetén a standard normál eloszláshoz,
# míg n<=30-nál a megfelelő szabadságfokú t eloszláshoz tartozó érték.
# A két eloszláshoz az qnorm() és qt() függvények lesznek segítségül.

# Értelmezzük az elkészített függvényt, mit csinál pontosan:


CI <- function(dataset) {
    if (length(dataset) > 30) {
        m = qnorm(0.975)
    }
    else {
        m = qt(0.975,df=(length(dataset)-1))
    }
    return(m*sem(dataset))
}

CI(mtcars$mpg)

# 2.1.1 Feladat ------------
# Készítsünk olyan függvényt, ami megadja a konfidencia-intervallum
# átlagtól számított alsó és felső határát egy vektorban!


# 2.2 Könyvtárak saját függvényeinek módosítása --------

# Nézzük meg az mtcars adatbázist a dplyr csomagból!


head(mtcars)
str(mtcars)

# A summarize segítségével készítsünk pivot táblát!


pivot_table <- summarize(group_by(mtcars, am, cyl),
                         mean = mean(mpg),
                         error = sd(mpg),
                         n = length(mpg))
pivot_table

# Egy kis kitérő:
# 2.2.1 Mi az az NSE? ------------

# Mi a különbség a két parancs között?

pivot_table <- summarize(group_by(mtcars,
                                  am, cyl),
                         mean = mean(mpg),
                         error = sd(mpg),
                         n = length(mpg))

pivot_table

pivot_table <- summarize_(group_by_(mtcars,
                                    "am", "cyl"),
                          mean = "mean(mpg)",
                          error = "sd(mpg)",
                          n = "length(mpg)")

pivot_table

# Látszik, hogy a két pivot függvény eltlrő parancsokat használ:
# Az egyiknek a group_by, illetve a summarize, míg a másiknak pedig a group_by_
# és a summarize_ parancs szerepel az argumentumati között!
# A dplyr alapértelmezésben NSE-t, azaz nem standard kiértékelést használ az argumentumoknál.
# Ez azt jelenti, hogy a megadott argumentumot egy speciális környezetben értelmezi, például:

cyl

# Ez egy nem létező változó, az mtcars adattábla egy oszlopa, amihez úgy férünk hozzá, hogy:

mtcars$cyl

mtcars[["cyl"]]

# Akkor a summarize függvény vajon honnan tudja,
# hogy a group_by(mtcars, cyl, gear) esetében a cyl kifejezést
# az mtcars táblázat egy oszlopára kell érteni??
# Onnan, hogy van egy speciális (és veszélyes) függvény, ami képes értelmezni
# az adott változót egy másik környezetben.
# Ehhez az kell, hogy képesek legyünk kiértékelés nélkül továbbvinni egy kifejezést.

x <- 10

# A quote(kifejezés) függvény "nem hagyja" a programnak, hogy kiértékelje a bevitt kifejezést:

x

quote(x)

# Ez hasznos lehet, ha szeretnénk kinyerni a változó nevét, példáaul a deparse függvénnyel:

deparse(10)

deparse(x)

deparse(quote(x))

# Az eval(kifejezés,környezet) függvény pont az ellenkezőjét teszi:
# mindenképpen kiértékeli a kifejezést az adott környezet szerint.

eval(x)

# Akkor ez vajon miért nem működik:

eval(x, list(x = 2))

# Mert x már kiértékelésre kerül a függvényen belül. Ezt akadályozhatjuk meg azzal,
# hogy az eval-t a quote-tal kombináljuk:

eval(quote(x), list(x=2))

# De x értéke ettől még nem változik:

x

# A substitute függvény, amit a legtöbb könyvtár (például a dpylr és a ggplot2)
# használ ennek a két vüggvénynek az ötvözete:

substitute(x, list(x=2))
x
# Egy példa:

substitute(cyl, mtcars)
mtcars$cyl
# A summarize() és a gorup_by() függvényekkel ellentétben
# a summarize_() és a gorup_by_() függvények SE-t, azaz standard kiértékelést használnak,
# tehát sima argumentumként kezelik a bevitt változókat,
# ezért stringként (vagy formulaként) kell őket beadni.

# NSE változat:

summarize(mtcars, mean(mpg))

# Ennek viszont nincs értelme:

summarize_(mtcars, mean(mpg))

# De ezeknek már van:

summarize_(mtcars, "mean(mpg)")

summarize_(mtcars, quote(mean(mpg)))

# Ez egy speciális változat, mert itt formulát használunk, aminek további nagyon sok előnye van:

summarize_(mtcars, ~mean(mpg))

# (Már) Mindegyik változat múködik saját függvényekkel is:

summarize(mtcars, sem(mpg))

summarize_(mtcars, ~sem(mpg))

summarize_(mtcars, "sem(mpg)")

# Így már egészen másképp látjuk a summarize és a summarize_ közti különbséget:


pivot_table <- summarize_(group_by_(mtcars,
                                    quote(am),
                                    quote(cyl)),
                          mean = ~mean(mpg),
                          error = ~sem(mpg),
                          n = ~length(mpg))

pivot_table

# Még egy kiegészítés: mi a helyzet, ha egy változó nevét,
# vagy értékét szeretnénk bevinni egy szöveges argumentumba?

# Ez így nem valami jó:

depvar <- mpg

summarize(mtcars, mean(depvar))

# Ez sem járható út:

depvar <- 'mpg'

summarize_(mtcars, ~mean(depvar))

# A megoldás az interp függvény a lazyeval csomagból!

?interp

# Mit csinálhatott a függvény?

interp("x + y +z", x = 1, y = 3)

# Akkor ennek mi lesz az eredménye?

interp(~x + y, x = 1)

# Ez már majdnem elég arra, hogy előállítsuk a kívánt formulát!

depvar <- "mpg"

interp(~mean(x), x = depvar)

# De sajnos idézüjelben marad az mpg, ami a summarize_-nak nem jó bemenet:

summarize_(mtcars, interp(~mean(x), x = depvar))

# Ennek a megoldásához a következő plusz lépésre van szükség:

depvar

as.name(depvar)

# Ez a stringből objektumot/szimbólumot csinál, amit már beilleszthetünk a kifejezésbe:

depvar <- "cyl"
interp(~mean(x), x = as.name(depvar))

# És így kapjuk meg azt a kifejezést, amire a sumamrize_-nak szüksége van bemenetként:

summarize_(mtcars, interp(~mean(x),
                          x = as.name(depvar)))

# Most már készen állunk arra, hogy saját változatot csináljunk a summarize_() függvényből!

summarize_mod <- function(data, depvar, ...) {
    # a '...' lehetove teszi, hogy a fuggveny meghivasanal
    # hozzadjunk tovabbi, nem nevesitett argumentumokat.
    summarize_(group_by_(data, ...),
               mean = interp(~mean(x), x=as.name(depvar)),
               error = interp(~sem(x), x=as.name(depvar)),
               n = interp(~length(x), x=as.name(depvar))
               )
}

pivot_table = summarize_mod(data=mtcars, depvar='mpg', 'am', 'cyl')
pivot_table

# De az összesítésnél használt függvényt is kicserélhetjük sajáttal:
osszesitsd <- function(data,aggfunc=mean){
  aggfunc(data)
}

osszesitsd(mtcars$mpg,mean)

summarize_mod <- function(data, depvar, ..., aggfunc=mean, errfunc=sem) {
  # a '...' lehetove teszi, hogy a fuggveny meghivasanal
  # hozzadjunk tovabbi, nem nevesitett argumentumokat.
  summarize_(group_by_(data, ...),
             agg = interp(~aggfunc(x), x=as.name(depvar)),
             error = interp(~errfunc(x), x=as.name(depvar)),
             n = interp(~length(x), x=as.name(depvar))
  )
}

pivot_table_2 = summarize_mod(data=mtcars, 'mpg', 'am', 'cyl', aggfunc=median)
pivot_table_2

# 2.3 A korábbiak kombinálása az ábrázolással --------

# Az elkészült pivot táblát ábrázolhatjuk a ggplot-tal:

# készítünk egy változót arra, amiben az oszlopok távolságát tároljuk:

dodge <- position_dodge(width = 0.9)

# Alternatív meghívása a ggplot-nak: a plotunkat  egy változóhoz rendeljük és
# egyenként adjuk hozzá az elemeket:

# A plot:

ax1 <- ggplot(pivot_table,
              aes(x=factor(cyl),
                  y=mean,
                  fill=factor(am)))

# Oszlopok:

ax1 <- ax1 + geom_bar(stat="identity",
                      position=dodge)

# Hibasávok:

ax1 <- ax1 + geom_errorbar(position = dodge,
                           width = 0.25,
                        aes(ymin=mean-error,
                            ymax=mean+error))

# És jelenítsük meg!

ax1

# Egy kis kitérő:
# 2.3.1 Listák (avagy szótárak) ------------

#     list1 <- list(kulcs1=érték1, kulcs2=érték2)
# A list1[kulcs] paranccsal megkapjuk a kulcshoz hozzárendelt értéket.

proba_lista <- list('x'=c(1,2), 'y'=c(3,4))
proba_lista

# Utólag is hozzáadhatunk értéket a listához:

proba_lista[['z']] = c(5,6)
proba_lista

# Adjunk az mtcars tábla minden oszlopának nevéhez egy leírást a súgó alapján,
# amit majd egy listában tárolunk:

?mtcars

names_list <- list("mpg"="Miles/(US) gallon",
                   "cyl"="Number of cylinders",
                   "disp"="Displacement (cu.in.)",
                   "hp"="Gross horsepower",
                   "drat"="Rear axle ratio",
                   "wt"="Weight (1000 lbs)",
                   "qsec"="1/4 mile time",
                   "vs"="V/S",
                   "am"="Transmission (0 = automatic, 1 = manual)",
                   "gear"="Number of forward gears",
                   "carb"="Number of carburetors")
names_list

# Kilistázhatjuk a kulcsokat:

names(names_list)

# Vagy kereshetünk leírásokat a kulcsok alapján:

names_list[["mpg"]]

# És ezt a listát felhasználhatjuk arra, hogy a diagramon
# a változók nevei helyett a leírást jelenítsük meg:

ax1

ax1 <- ax1 + scale_fill_discrete(name = names_list[["gear"]]) +
             labs(x = names_list[["cyl"]], y = names_list[["mpg"]])

ax1

# Miért jó az, hogy listával definiáljuk a neveket ahelyett, hogy kézzel beírnánk őket?
# Azért, mert így írhatunk saját függvényt a grafikus ábrázolásra!

mean_bar_plot <- function(data, depvar, gvar1, gvar2) {
    # Elkeszitjuk a pivot tablat:
    pivot_table = summarize_mod(data=data, depvar=depvar, gvar1, gvar2)
    dodge <- position_dodge(width = 0.9)
    # print(pivot_table)
    return(ggplot(pivot_table, aes(x=as.factor(pivot_table[[gvar1]]),
                            y=agg, # Vigyazat: itt kombinaljuk az NSE-t es az SE-t!
                            fill=as.factor(pivot_table[[gvar2]]))) +
            geom_bar(stat="identity", position=dodge) +
            geom_errorbar(position = dodge, width = 0.25,
                aes(ymin=agg-error, ymax=agg+error)) +
            # Itt mar csak a cimkeket kell hozzaadni, azaz minden argumentumhoz
            # ki kell keresni a hozza illo nevet a names_list listabol:
            scale_fill_discrete(name = names_list[[gvar2]]) +
            labs(x = names_list[[gvar1]], y = names_list[[depvar]])
    )
}

mean_bar_plot(data=mtcars, depvar='mpg', gvar1='am', gvar2='cyl')
# Rovidebb valtozat: mean_bar_plot(mtcars, 'mpg', 'cyl', 'gear')

# Ezután elrakhatjuk a vizsgált függő változók neveit egy vektorba:

depvars = c('mpg','disp','wt')

# És egyszerűen csinálhatunk plotot minden minden függő változóra:

plots <- list()
for (var in depvars) {
    plots[[var]] <- mean_bar_plot(data=mtcars, depvar=var, gvar1='cyl', gvar2='gear')
}
do.call(grid.arrange,plots)

# 3. Parancsok ciklikus végrehajtása ----------
# Mi van, ha szeretnénk egy olyan függvényt, ami negatív számokra 0-t ad, pozitív számokra önmagukat
# Megj.: Ez egy gyakran használt, ún. relu, vagy rectifier aktivációs fv. neurális hálókban

relu <- function(x) {
  if(x >= 0){
    return(x)
  } else {
    return(0)
  }
}

relu(1)
#     output: [1] 1
relu(-1)
#     output: [1] 0

# Mi a helyzet, ha ezt a függvényt vektoron szeretnénk alkalmazni?
-10:10
relu(-10:10)

# 1. megoldás: Map() függvény: alkalmaz egy adott függvényt egy vektor összes elemén
?Map
Map(relu, -10:10)

# Ez nem a legelegánsabb... Szerencsére a purrr csomagban rendelekzésre állnak
# Olyan map függvények, amelyek megadott adattípusokat adnak vissza
# VIGYÁZAT: az argumentumok sorrendje pont fordított a Map()-hez képest!
?map
map(-10:10, relu)
map_dbl(-10:10, relu)

# Azért nagyon jó a fordított argumentumsorrend, mert így könnyű pipe-pal
# használni a függvényt:
-10:10 %>% 
  map_dbl(relu)

# Megjegyzés: a map...() függvénycsalád és a Map() működik névtelen függvényekkel:
# elég, ha az argumentumon belül definiáljuk a függvényt
map_dbl(-10:10, function(x) if (x > 0) {x} else {0})
# Egyszerűbben:
map_dbl(-10:10, function(x) max(x,0))

# Nyakatekert megoldás: map_if() -> feltételesen hajt végre egy függvényt:
map_if(-10:10, function(x) x < 0, function(x) 0)

# 2. megoldás: a függvény újradefiniálása for ciklussal

relu <- function(x){
  v <- c()
  for (xi in x){
    if (xi > 0){
      v <- c(v,xi)
    }else{
      v <- c(v,0)
    }
  }
  return(v)
}

relu(-10:10)

# 3. megoldás: a for-if párosítás helyett az ifelse függvényt használjuk,
# ami egy if-else elágazást képes egyetlen paranccsal végrehajtani egy elágazást
# egy vektor minden elemén
?ifelse
relu <- function(x) {
  ifelse(x > 0, x, 0)
}

relu(-20:20)

x <- seq(-100,100,0.01)
relu(x)
plot(x, relu(x), type='l')

# Ennek nagy előnye, hogy annyira egyszerűen használható,
# hogy még külön definiálnunk sem kell a függvényt, mégis átlátható lesz:
plot(x, ifelse(x > 0, x, 0), type="l")
