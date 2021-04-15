#### A base R alapvet? szintaktik?ja --------------------------------

## Az R, mint szamologep ----------------

5 + 5
10 + 5 * 3

4^2
4**2

sqrt(81)
log10(1000)
mean( c(3, 4, 20) )
abs(-5)


## Ertek rendelese valtozohoz ----------------

# <- RStudio gyorsbillentyű: Alt + "-" 
v1 <- 4

# mukodik, de kevesbe ajanlott: v1 = 4
# egyaltalan nem ajanlott: 4 -> v1
v1

assign("v2", 4)


# A valtozo a workspace-n tarolodik. Nezzuk meg a workspace tartalmat!
objects()
ls()

# Most pedig tavolitsuk el v1 es v2 valtozokat a workspace-rol.
rm(list=c("v1", "v2"))

## Vektorok ----------------

# Elemi (atomic) vektorok és listák
# 1. típus
# 2. hossz
# 3. attribútumok (egyéb metaadatok)

# Elemi vektorok létrehozása: c()

szamok  <- c(4L, 5L, 10L, 99L)
allatok <- c("kutya", "macska")

# Az elemi vektor mindig lapos, akkor is, ha beágyazva hozzuk létre

c(1, c(2,3, c(4))) 
# ugyanaz mint
c(1, 2, 3, 4)

# A listákkal ez máshogy lesz!


# Vektor típusa
typeof(szamok)
typeof(allatok)

# Bizonyos típusú-e egy vektor? Általánosságban: is.valami()
is.double(allatok)
is.character(allatok)

# numeric: double és integer
is.numeric(1L)
typeof(1L)
is.numeric(1.2)
typeof(1.2)

# Egy vektorban csak egy típusú adat lehet!
# Ha többféle típust próbálunk egy vektorba pakolni, akkor a "leglazább" típussá lesznek kényszerítve
# logical < integer < double < character

c("kutya", 4)

# Explicit kényszerítés
c("kutya", as.character(4))

# Ha a kényszerítés során infót veszítünk, általában kapunk egy figyelmeztetést
as.double(c("a", "0.99", "b", "1"))


# Vektorok hossza
length(szamok)


# Muveletek numerikus vektorokkal
x <- c(10.4, 5.6, 3.1, 6.4, 21.7)
1/x
min(x)
max(x)
sort(x)
sort(x, decreasing = TRUE)
order(x)
rank(x)

# Vektorok egymashoz fuzese
y <- c(x, 0, x)

# Ha kulonbozo hosszusagu vektorokon vegzunk muveletet, 
# a rovidebb ujrafelhasznalasra kerul!
v <- 2*x + y + 1

## Sorozatok letrehozasa ----------------

# Elore
1:4

# Hatra
7:4

# A : prioritast elvez mas muveletekkel szemben.
n <- 10
1:n*2
1:(n*2)

# A seq(), a rep(), es a paste() fuggveny.
seq(2, 10)
?seq
seq(from = 2, to = 9, by = 3)


# Hányszor ismétlődjön a vektor?
rep(c("A", "BB", "CCC"), times = 3)

# Hányszor ismétlődjenek a vektor elemei? 
rep(c("A", "BB", "CCC"), each = 3)

paste("a", 1:10, sep = "_")

## Logikai vektorok ----------------

5 > 100
2 == 2
3 >= 1.2

x
x > 4
x > 4 & x < 10
x > 6 | x == 3.1
x != 10.4


# Logika érték számmá alakítható
as.numeric(c(TRUE, FALSE))

# Matematikai függvények általában számmá kényszerítik a logikai vektorokat
mean(c(TRUE, FALSE, TRUE))

# Számok is logikai értékké alakíthatóak!
as.logical(c(1, 0.7777, 0))

# Logikai értékek rövidíthetőek is
TRUE  == T
FALSE == F

# Rövidítéssel óvatosan: T és F felülírható

T <- 3
F <- 3

F == T


TRUE <- 3

## Hianyzo adatok ----------------

# Az NA egy logika érték
typeof(NA)

# Ha vektorba tesszük, a megfelelő típusuvá lesz kényszerítve
b <- c(NA, 4L, 10L)
typeof(b)

# Létrehozhatunk megadott típusa NA-t is
typeof(NA_character_)
typeof(NA_integer_)
typeof(NA_real_)

# Altalanossagban: minden NA-n vegzett muvelet NA-t ad eredmenyul.
mean(b)
b > 5
is.na(b)

# Not a Number
0/0
Inf-Inf

## Vektorok indexelese ----------------

x <- c(4, 4.3, NA, 100, 5623, 7, 1)
x[1]

# Altalanossagban: vektor[index_vektor]

# Tobbfelekeppen is lehet indexelni.
# a) Logikai vektorral
y <- x[!is.na(x)]

# Ez vajon mit csinal?
z <- (x+1)[(!is.na(x)) & x > 6]

# b) Pozitiv egesz szamokkal
x[2]
x[2:4]

# c) Negativ egesz szamokkal kizaras
x[-1]
x[-(3:5)]

# d) String-gel (csak ha a vektor elemeinek van neve)
fruit <- 
  c(orange=5,
    banana=10, 
    apple=1,
    peach=20)

lunch <- fruit[c("apple","orange")]
lunch * 100

# Ertek hozzarendelese vektor indexelt elemeihez

x[x < 5] <- 999

## Gyakorlás 1  ----------------

# 1. Hozzunk letre egy otelemu vektort, ami tizzel kezdodik, es harmasaval novekedik! 
#    Taroljuk a vektort az x valtozoban.

# 2. Emeljuk negyzetre az elobb letrehozott x vektort, es rendezzuk csokkeno sorrendbe!
#    Taroluk ezt a vektort az y valtozoban. 

# 3. Valogassuk ki z vektorbol a 10-nel nagyobb elemeket, es taroljuk a z2 vektorban.
z <- c(3, .2, NA, 50, 4000, 10, 11)


# 4. A hianyzo adatok helyere tegyunk 0-t. Majd szamoljuk ki a vektor atlagat, minimum es 
#    maximum erteket, es taroljuk ezeket a descr vektorban!
numbers <- c(-4, 3.2, NA, NA, 100, 146, 98)


## Lista  ----------------

# Olyan vektor, amiben tobbfele adattipus is lehet.

uj_lista <- list(a = 2.5, b = "kutya", c = 1:10)

uj_lista

# A lista eleme lehet egy másik lista is!

lista_lista <- list(1:5, list("a", "kettő", 5:7), matrix(1:20, 4,5))

str(lista_lista)

# Listák indexelese: [] és [[]]
# [] a lista egy szeletét adja vissza listaként
uj_lista[3]
class(uj_lista[3])

# A lista több elemét is elérhetjük a [] címzéssel
uj_lista[2:3]
uj_lista[c("c", "a")]


# [[]] a lista adott elemét adja vissza
uj_lista[[3]]
class(uj_lista[[3]])
uj_lista[["b"]]

# $ is használható a lista elemeinek címzéséhez
uj_lista$b



# listabol vektor
unlist(uj_lista)

c(list(1, 3))

# A bonyolultabb R adatstruktúrák gyakran listákból épülnek fel,
# pl. a dataframe-k
is.list(iris)

# vagy a lineáris modell objektumok
lin_reg <- lm(mpg ~ wt, mtcars)
is.list(lin_reg)


# Gyakorlás 2 ----

# 1) Listák címzése

x <- 
  list(
    elso    = list("valami", c("a", "b", "c")),
    masodik = list(egy_szam = 1, egy_sorozat = 4:7, beagyazott_lista = list(c(2, 1, 83),"nyerjük ki ezt a stringet") )
  )


# Attribútumok ----

# Minden objektumnak lehetnek attribútumai: itt lehetnek metaadatok
# Mintha egy egyedi nevekkel ellátott listában lennének

y <- 1:10

# Attribútum hozzárendelése
attr(y, "my_attribute") <- "This is a vector"

# Megadott attribútom lekérése
attr(y, "my_attribute")

# Összes attr lekérése egy listában
attributes(y)
str(attributes(y))

# Egy vektor módosításakor általában elvesznek
attributes(y[1])

attributes(sum(y))


# Kivéve a 3 legfontosabb

# - nevek (names)
# - dimenziók (dim)
# - osztály (class)

# Egy vektornak 3 módon adhatunk neveket:

# Amikor létrehozzuk
x <- c(a = 1, b = 2, c = 3)

# Módosítjuk egy meglévő vektor names attr-át:
x <- 1:3
names(x) <- c("a", "b", "c")
x

# Vagy
x <- 1:3
names(x)[[1]] <- c("a")
x # vegyük észre, hogy a 2. és a 3. elemnek hiányzik a neve!


# Létrehozzuk a vektor egy módosított másolatát
x <- setNames(1:3, c("a", "b", "c"))
x

# A neveknek nem kell egyedieknek lenniük, de ha címzéshez akarjuk használni, akkor érdemes!


## Faktor ----------------

# Az attr-k jól jönnek a faktorok kezelésénél. Mi az a faktor? 
# Specialis integervektor. Kategorikus valtozok tarolasanal fontos.
# Két fontos attr: 
# - osztályuk "factor" ezért viselkednek másként, mint a sima integer vektorok
# - levels: ami meghatározza a lehetséges értékek halmazát


f <- factor(c("a", "a", "b", "d"))

f
levels(f)
class(f)

# A levels-ben nem szereplő értékek nem használhatóak egy faktornál

f[1] <- "z"
f

# Faktorokat nem lehet kombinálni

c(factor("a"), factor("b"))

# Akkor jön jól, ha előre tudjuk, milyen értékeket vehet fel egy változó

sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)

table(sex_factor)

# as.factor megtartja az eredeti szinteket, ha egy faktorra hívjuk meg
# factor elveszti az eredeti szinteket
factor(sex_factor)
as.factor(sex_factor)


# Bár a faktor string-nek tűnik, valójában integer!
sex_factor <- factor(c("m", "m", "f"), levels = c("m", "f"), labels = c("male", "female"))
typeof(sex_factor)

# Ha a címkéken akarunk műveletet végezni, az a biztos, ha explicit módon karakterré alakítjuk
as.character(sex_factor)

f <- factor(c(0,1,0,1,1))
f
as.numeric(f)

## Matrix ----------------

# Olyan vektor, aminek két dimenziója is van



# Vektorbol matrixot a dimenziók megadásával
mat <- 1:20
# 4 sor, 5 oszlop
dim(mat) <- c(4,5)

mat <- matrix(1:12, nrow = 3, ncol = 4)
mat
mat[ ,1 ]
dim(mat)

length(mat)
nrow(mat)
ncol(mat)

rownames(mat) <- c("elso", "masodik", "harmadik")
colnames(mat) <- c("a","b","c","d")

# Oszlopok és sorok kombinálása

cbind(mat, e = 1:3)
rbind(mat, negyedik = 1:4)

# Tomb = tobbdimenzios matrix
tomb <- array(1:20, dim = c(2, 2, 5))
tomb

tomb <- 1:20
dim(tomb) <- c(2,2,5)

## Dataframe ----------------

# Olyan, mint egy matrix, amiben tobbfele adattipus is lehet.
# Valojaban egy spec. lista, amelyben a vektorok hossza egyezik, és a lista elemei a változók

adatok <- 
  data.frame(
    test_score = c(10, 11, 9, 7, 4, 15),
    patient    = factor(c("patient", "control", "control", "patient", "patient", "control")),
    age        = c(40, 42, 35, 52, 46, 40)
)

adatok

# Sorok es oszlopok (=valtozok) indexelese szammal
adatok[2:4, ]
adatok[ , 1:2]

# dplyr-ben hogyan?

# Indexelés logikai vektorral
adatok[adatok$age < 40, ]

# dplyr-ben hogyan?


# Dataframe indexelese karakterrel
adatok[ , c("patient", "test_score")]
adatok[ , c("test_score", "patient")]

# dplyr-ben hogyan?

# Sornévvel
mtcars["Volvo 142E", ]

# dplyr-ben hogyan?

# A karaktervektort egy változóban is tárolhatjuk, és ezt a változót is használhatjuk az indexeléshez
valtozok <- c("age", "test_score")
adatok[, valtozok]

adatok$test_score

# Váltózónevek elérése
colnames(adatok)

# Változók betűrend szerinti rendezése
adatok2 <- adatok[sort(colnames(adatok))]

# Új változónevek kiosztása
colnames(adatok2) <- c("kor", "beteg", "teszt")

# Indexelt oszlopnevekhez új érték rendelésével átnevezhetjük a változókat 
colnames(adatok2)[2] <- "csoport"


## Kodolasi stilus tanacsok ----------------

# Forrasok: 
# http://handsondatascience.com/StyleO.pdf 
# http://adv-r.had.co.nz/Style.html 

# Az objektumok neve legyen egyertelmu, egyedi, es a leheto legrovidebb.
# Keruljuk a mar foglalt neveket, pl. NE IRJUNK OLYAT, HOGY: mean <- function(x) min(x)

# Valtozo - fonev. Also vonassal elvalasztva, ha tobb szobol all. 
edu_years 

# Fuggveny - ige. Szokoz nelkul, szokezdo nagybetukkel.
computeAverageScore()

# Igazitas. Ezt kezzel kell, de olvashatobb lesz a kod. 
var1         <- 50
b            <- "B"
cutoff_point <- 0.5



# Extra gyakorlás -------------------------------------------------------

# 1) 

# Készíts egy sorozatot, ami 12 elemből áll, és 2-től indul, és 13-mal növekszik! 
# Tárold el ezt a sorozatot egy változóban!


# Készíts ebből a sorozatból egy 3 sorból és 4 oszlopból álló mátrixot! 
# A vektort soronként töltsd be mátrixba! 
# Tárold el ezt a mátrixot is egy változóban! 


# A mátrix páratlan elemeihez adj hozzá 1000-et, és az eredménnyel írd felül az eredeti mátrixot! 


# Készíts egy 4 elemű listát, aminek az elemei a mátrix oszlopai 
# Az elemeket nevezd el (pl. "első", "második", ...)


# Nyerd ki a lista 1. elemének 3. elemét, és a 4. elem 2. elemét, és pakold őket egy karaktervektorba! 
# Mentsd el ezt is egy változóba! 

