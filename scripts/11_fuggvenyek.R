# 0.1 Libraryk behívása ----------

# Az anyagot összeállította: Markója Ádám

library(tidyverse)
library(gridExtra)

# 0.2 Ismétlés ----------
# Írjunk olyan parancsot, ami tetszőleges hosszúságú Fibonacci számsort állít elő!
# Fibonacci-sor:
# Olyan sorozat, amely minden n-edik elemének értéke megegyezik az n-1-edik
# és az n-2-edik elem összegével:
# 0, 1, 1, 2, 3, 5, 8, 13, 21, stb.



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
  return(x + 1)
}

x1 <- adj_hozza_egyet(3)
x1

szam <- 50

check_100 <- function(szam){
  if (szam > 100) {
    return("Juhu, a szam nagyobb szaznal.")
  } else if (szam == 100) {
    return("Hoho, a szam pont 100!")
  } else {
    return("Sajnos a szam kisebb 100-nal")
  }
}

check_100(200)

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



# 2 A tanultak alkalmazása elemzésnél ----

# 2.1 Statisztikai függvények --------
# Készíthetünk függvényeket különböző statisztikai problémákra

# Példa:
# A standard hiba kiszámításához szükség van a szórás [sd()],
# az elemszám [length()] és a gyök [sqrt] függvények kombinálására:

mtcars$mpg

sd(mtcars$mpg)/sqrt(length(mtcars$mpg))

sem <- function(data) {
    return(sd(data)/sqrt(length(data)))
}

sem(mtcars$mpg)

# De kiszámíthatjuk a konfidencia-intervallumot is!
# A konfidencia intervallum n>30 esetén a standard normál eloszláshoz,
# míg n<=30-nál a megfelelő szabadságfokú t eloszláshoz tartozó érték.
# A két eloszláshoz az qnorm() és qt() függvények lesznek segítségül.

# Értelmezzük az elkészített függvényt, mit csinál pontosan:


CI_err <- function(dataset) {
    if (length(dataset) > 30) {
        m = qnorm(0.975)
    }
    else {
        m = qt(0.975,df=(length(dataset)-1))
    }
    return(m*sem(dataset))
}

CI_err(mtcars$mpg)

# 2.1.1 Feladat ------------
# Készítsünk olyan függvényt, ami megadja a konfidencia-intervallum
# átlagtól számított alsó és felső határát egy vektorban!


