# A kódot Markója Ádám írta, amikor doktoranduszként a BME Kognitív Tudományi Tanszékén részt vett a kurzus oktatásában.
# Nagyon köszönjük, Ádám!

# 0.1 Libraryk behívása ----------
require(stringr)
require(dplyr)
require(ggplot2)
require(gridExtra)
require(nycflights13)

# 1 Print, writeLines és cat függvények ----------

print(1)
print('Ez egy szöveg')
print('Ez egy szöveg\nEz egy másik szöveg')
cat('Ez egy szöveg\nEz egy másik szöveg')
writeLines(c('Ez egy szöveg','Ez egy másik szöveg'))
cat(c('Ez egy szöveg','Ez egy másik szöveg'))
cat(c('Ez egy szöveg','Ez egy másik szöveg'),sep='\n')

# 2 Az R alapvető szintaktikája ----------

# Ezt jó megjegyezni!!!

#     operátor(állítás) {
#         parancs
#     }


# 3 Feltételhez kötött végrehajtás ----------
# Mi van, ha feltételhez szeretnénk kötni valamely parancs teljesítését?
# Például.: Írj ki valamit, ha a szám értéke nagyobb 100-nál

x <- 101
print('A szam nagyobb szaznal')


x <- 99
print("A szam kisebb szaznal")

# 3.1 Az if parancs ----------
# Megvizsgálja, hogy az adott állítás igaz-e és csak akkor hajtja végre a megadott utasítást, ha igaz.
# Szintaktika:

#     if(<<állítás>>) {
#       csináld-ezt-meg-azt-ha-<<állítás>>-igaz
#     }

# Mi lesz az eredménye a végrehajtásnak?


x <- 99
if (x > 100) {
  print('Juhu, a szam nagyobb szaznal.')
}

# És most?

x <- 101
if (x > 100) {
  print('Juhu, a szam nagyobb szaznal.')
}

# Prettify: Sok elrendezésben lefut a kódunk, az elsődleges szempont mindig az áttekinthetőség:
if (x > 100) {
  print('Juhu, a szam nagyobb szaznal.')
}

# Nem muszáj behúzást alkalmazni!
if (x > 100) {
print('Juhu, a szam nagyobb szaznal.')
}

if (x > 100) {print('Juhu, a szam nagyobb szaznal.')}
if (x > 100)print('Juhu, a szam nagyobb szaznal.')

if (x > 100)
  {print('Juhu, a szam nagyobb szaznal.')}

# 3.2 Az else kapcsoló ----------

# Mi van, ha akkor is szeretnénk valami mást végrehajtani, ha nem teljesül az állítás, pl. írja ki,
# hogy sajnos a szám nem nagyobb 100-nál 

# else parancs: akkor hejtódik végre, ha az if mögött állítás nem teljesül.
# Szintaktika:

#     if(<<állítás>>) {
#       csináld-ezt-meg-azt-ha-<<állítás>>-igaz
#     } else {
#       csinálj-valami-mást
#     }

x <- 101
if (x > 100) {
  print('Juhu, a szam nagyobb szaznal.')
} else {
  print('Sajnos a szam nem nagyobb 100-nal')
}

x <- 100
if (x > 100) {
  print('Juhu, a szam nagyobb szaznal.')
} else {
  print('Sajnos a szam nem nagyobb 100-nal')
}

# 3.2.1 Feladatok ----------

# Emlékeztek erre a feladatra?
# Nyerd ki egy string középső karakterért az str_length és azt str_sub használatával!
# Csináljuk meg elágazással: Ha a szöveg páros számú betűből áll, a középső két betűt,
# ha páratlanból, akkor csak a középső betűt adja vissza!
# Emlékeztetőül: str_length(string) + str_sub(string, start=, end=)


# Mi van, ha csak bizonyos típusú változókon szeretnénk parancsot végrehajtani?
x <- 'szoveg'
print(x+1)
# Szeretnénk ezt a hibaüzenetet elkerülni:
# Írjuk olyan elágazást, ami megszorozza kettővel a változó értékét, ha az szám, 
# Egyéb esetben kiírja a változó tartalmát.
# Segítség: típus ellenőrzése: pl. is.numeric() függvény
is.numeric(2)
is.numeric('blabla')
is.numeric('2')


# 3.4 Az else if kapcsoló ----------
# Mi van, ha arra is szeretnenk egy kiirast, ha a szam pont 100?
# Az else if közbeiktatása: ha nem igaz az if mögötti állítás, de az else if mögötti igen, akkor végrehajtja.
# Szintaktika:

#     if(<<állítás1>>) {
#       csinád-ezt-meg-azt-ha-<<állítás1>>-igaz
#     } else if(<<allitas2>>) {
#       csinál-valami-mást-ha-<<állítás1>>-nem-igaz-de-<<állítás2>>-igaz
#     } else {
#       csinál-valami-mást-ha-egyik-állítás-sem-igaz
#     }

x = 100
if (x > 100) {
  print("Juhu, a szam nagyobb szaznal.")
} else if (x == 100) {
  print("Hoho, a szam pont 100!")
} else {
  print("Sajnos a szam kisebb 100-nal")
}

# Van különbség az alábbi két parancs végrehajtásának eredményében?

x = 0.5
if (x < 2) {
  print("Kisebb, mint ketto")
}
if (x < 1) {
  print("Kisebb, mint egy")
}

x = 0.5
if (x < 2) {
  print("Kisebb, mint ketto")
} else if (x < 1) {
  print("Kisebb, mint egy")
}

# 3.4.1 Feladatok ----------
# a)
# Csináljunk egy olyan döntési struktúrát, ami meghatározza,
# hogy az adott szám osztható-e tízzel, kettővel, vagy öttel.
# Ha tízzel osztható, csak annyit írjon ki, hogy tízzel osztható,
# ha kettővel, vagy öttel osztható, azt írja ki,
# ha pedig egyikkel sem, akkor írja ki,
# hogy "nem osztható egyikkel sem".
# Segítség: oszthatóság ellenőrzése: x%%y = x/y osztás maradéka

# b)
# Csináljunk olyan elágazásláncot, ami megvizsgálja, milyen típusú a változónk
# és kiírja nekünk. Pl ha a változónk data.frame kiírja, hogy "Ez data.frame"
# A következő adattípusokkal működjön: vektor, szám, karakter, lista, data.frame
# Tipp: Figyelni kell a típusok sorrendjére, mert némelyik nagyobb halmaz, mint a másik!
# Próbáljuk ki különböző típusú változókkal!


valami <- list(TRUE, NA)


# 4 Ciklusok ----------

# 4.1 A while ciklus ----------
# Mi van, ha ugyanazt a műveletet többször szeretnénk elvégezni, például írd ki örször azt, hogy NA?

# Favágó megoldás:

print(NA)
print(NA)
print(NA)
print(NA)
print(NA)

# Jó lenne egy olyan lehetőség, amivel megmondhatjuk neki, hányszor végezze el az adott műveletet, például:

#     csináld(5) {
#         print(NA)
#     }

# Erre jó a ciklus!
# Az R 2 fajta ciklust ismer:
#      while: (alacsonyabb szintű)
#      for: (magasabb szintű)

# A while ciklus szintaktikája:
#     
#     while(<<állítás>>) {
#       csináld-ezt-meg-azt-amíg-<<állítás>>-igaz
#     }

# Jelentése: Hajtsd végre a megadott parancsot, ameddig az állítás igaz
# Minden végrehajtás után ellenőrzi, hogy igaz-e az állítás!


# Mit csinálhat ez a parancs?

# while(TRUE) {
#  print('Hello world!')
# }

# És ez?

# while(FALSE) {
#   print('Hello world!')
# }

# Látszólag egyiknek sem volt értelme. Az első végtelen végrehajtáshoz vezetett, a második pedig nem csinált semmit.
# Akkor mégis hogyan működhet a while parancs, hogyan válhatna hasznunkra?

# A megoldás: iterátor változó:

i <- 1 # iterator valtozo
while(i < 5) { # Csinald, amig i kisebb 5-nel
  # ird ki i erteket
  print(i)
  # noveld meg i-t eggyel,
  # ezutan visszater a ciklus elejere
  i = i+1
}

# Vagy írjuk ki ötször azt, hogy NA:

i = 1
while (i <= 5) {
  print(NA)
  i = i + 1 # ezt a sort soha ne felejtsuk el while ciklusnal!!! Ellenkezo esetben vegtelen ciklus...
}
print('Batman!')


# 4.1.1 Előltesztelő és hátultesztelő ciklusok: a break parancs használata ------------------

# A break parancs azonnal megszakítja a ciklus futását:

while(TRUE) {
  print('Hello world!')
  break
}

while(TRUE) {
  break
  print('Hello world!')    
}

# Így nézne ki az iterátor értékét kiíró függvény hátultesztlő változata:

i <- 1
while (TRUE) {
  print(i)
  i = i + 1
  if (i >= 5) {
      break
  }
}

# Egy kis kitérő:
# 4.1.2 műveletek vektorokkal ----------

v1 <- c('a','b','c','d')
print(v1)

# 4.1.2.1 Az append parancs ----------

# Hozzáad egy elemet a listához:

print(v1)
v1 <- append(v1,'e')
print(v1)

# Rövidebb megoldás:
v1 <- c(v1,'f')
v1

# 4.1.2.2 Vektor elemeinek száma és indexelés ----------

# A length visszaadja a lista elemeinek számát:

length(v1)

# Érvényes indexelés:

v1[1]

# Érvénytelen indexelés (az index magasabb, mint a lista elemeinek a száma):

v1[10]

# A negatív index visszaadja az egész listát, a negatívan indexelt elemet kivéve:

v1[-3]

# Vektor segítségével több elemet is lekérhetünk:

v1[c(1:3)]
# Ez egyenértékű a következővel:
v1[1:3]

# Azonban:
v1[1,3]
# Ez az indexelés többdimenziós mátrixot vár!
v1[c(1,3)]


# A vektor és a length kombinálásával visszakérhetjük a listánk utolsó x elemét:

v1[c(3:length(v1))]
v1[3:length(v1)]

# 4.1.3 Feladatok ----------

# Készítsünk a while ciklus segítségével olyan vektort, ami kettő hatványait tartalmazza
# Legyen a maximum 2^20!
# Segítség: A hatványozás operátora a "^", vagy a "**".
2**20
2^20

# Ha ez kész, paraméterezzük változó (mondjuk x) segítségével a vektorunk maximális elemszámát!


# Írjunk olyan parancsot, ami tetszőleges hosszúságú Fibonacci számsort állít elő!
# Fibonacci-sor:
# Olyan sorozat, amely minden n-edik elemének értéke megegyezik az n-1-edik és az n-2-edik elem összegével:
# 0, 1, 1, 2, 3, 5, 8, 13, 21, stb.

# 4.2 A for ciklus ----------

# Hogyan tudnánk egymás után kiíratni a v1 vektor értékeit?

print(v1)

# "Favágó" megoldás a while ciklussal:

i <- 1
while (i <= length(v1)) {
    print(v1[i])
    i = i + 1
}

# Ennél van egy egyszerűbb módszer!
# A for cilus: végigmegy a vektor összes elemén.
# A ciklusban létrehozunk egy iterátor változót, ami minden körben a vektor soron következő elemének értékét veszi fel.
# Szintaktika:

#     for (<<elem>> in <<vektor>>): {
#       csinald-ezt-meg-azt, pl.
#       print(<<elem>>) --> kiírja a vektor soron következő elemét.
#     }


for (elem in v1) {
    print(elem)
}

# A for ciklus működik tartományokon, szekvenciákon is:
  
0:10
seq(0,10,2)

# Mi fog történni a parancsok végrehajtásakor?

for (i in 0:10) {
    print(i^2)
}

for (i in seq(0,10,2)) {
    print(i^2)
}

# 4.2.1 Feladatok ----------
# Csináljuk meg a korábbi, hatványos példát a for ciklus és a tartományok/seq parancs kombinálásával!


# Készítsünk v3 néven olyan vektort, aminek 
# az első eleme a v2 vektor első elemének az egyszerese, 
# a második a v2 második elemének a kétszerese, 
# a harmadik a v2 harmadik elemének háromszorosa, stb, 
# az n-edik elem a v2 n-edik elemének n-szerese.
v2 <- c(3, 7, 4, 2, 123, 5678, 134, 23, 57, 23324)

# Íjrunk egy olyan parancsot, ami megkeresi az x-nél kisebb összes prímszámot!

# x <- 5000

# Csak önmagával és 1-gyel osztható - más számokkal nem osztható



# 5 Gyakorlati alkalmazás ----------

# 5.1 Ciklus használata data.frame-eken ábrázoláshoz ----------

# Cél: Ábrázoljuk az iris adattábla összes numerikus változójának eloszlását hisztogram segítségével!
head(iris,5)
str(iris)

# 1. tároljuk egy vektorban a folytonos változókat, egy vektorban pedig a faktorokat

# Alap  syntax:
ggplot(data=iris, aes(Sepal.Length)) + 
  geom_histogram()

hist(iris$Sepal.Length)
hist(iris[['Sepal.Length']])
# Ez sajnos nem lesz jó nekünk, mert az NSE változókat nem tudjuk listába rakni
# Ebben segít az aes_string(): Hasonló, mint az aes(), de stringként kéri a változónevet
# Megj.: az NSE-ről bővebben a következő órán beszélünk
ggplot(data=iris, aes_string('Sepal.Length')) + 
  geom_histogram()

colname = 'Sepal.Length'
ggplot(data=iris, aes_string(colname)) + 
  geom_histogram()

# Indexelés változóval:
# Így miért nem működik?
iris$colname

# Miben különbözik a fentitől?
iris[colname]
iris[[colname]]
typeof(iris[colname])
typeof(iris[[colname]])

# Ellenőrizzük, hogy az oszlop számokat tartalmaz:
is.numeric(iris[[colname]])

iris_plots <- list()

# iris_plots['szeprvirag'] <- 2

for (colname in colnames(iris)) { # Menjünk végig az összes oszlopon
  if(is.numeric(iris[[colname]])){ # Ellenőrizzük, hogy a változó számadatot tartalmaz
     # A ggplot-nak szüksége van a print függvényre a cikluson belül, hogy outputot kapjunk
    p <- ggplot(data=iris, aes_string(colname)) +
      geom_histogram()
    iris_plots[[colname]] <- p
    
    cat(c('Ábrázolva: ',colname,'\n')) # Visszajelzés nekünk
  }else{
    cat(c('Nem tudom ábrázolni: ',colname,'\n')) # Visszajelzés nekünk
  }
}


# A kész plotokat tárolhatjuk strukturált változókban, pl. listába

# Nézzük meg, hogy a diamonds adattáblában a különböző minőségű (cut) gyémántoknál
# hogyan jár együtt az ár a mélységgel (depth) és a relatív magassággal (table)
# A plotokat tároljuk úgy egyetlen változóban, hogy utána könnyen azonosíthassuk őket
str(diamonds)

# Először tervezzük meg a változónk strukturáját!
# cut_plots
# |
# |----cut1 (Ideal)
# |      |---- price×depth
# |      |---- price×table
# |----cut2 (Premium)
# |      |---- price×depth
# |      |---- price×table
# |----cut3 (Good)
# |      |---- price×depth
# |      |---- price×table
# stb.

cut_plots <- list()
cuts <- unique(diamonds$cut)
for(c in cuts){
  dat <- subset(diamonds, cut==c)
  plot_pair <- list()
  plot_pair[['table']] <- ggplot(dat, aes(price,table)) + geom_point() + 
    ggtitle(c)
  plot_pair[['depth']] <- ggplot(dat, aes(price,depth)) + geom_point() + 
    ggtitle(c)
  cut_plots[[c]] <- plot_pair
}

# Végigiterálhatjuk az összes plotot:
for (pp in cut_plots){
  print(pp)
}

# Vagy kiválaszthatunk egy-egy adott plotot is:
print(cut_plots$Ideal$table)
print(cut_plots$Premium$depth)

# Lassan kezelhetetlen mennyiségű plotunk lesz... mit tehetünk velük?

# A grid.arrange rácsos szerkezetben egyszerre több plotot is képes megjeleníteni.
grid.arrange(cut_plots$Premium$table,cut_plots$Premium$depth)

grid.arrange(cut_plots$Premium$table,cut_plots$Premium$depth,cut_plots$Ideal$table)

# Igen ám, de hogy tudunk plotot kérni egy változópárra?
grid.arrange(cut_plots$Premium)

# Ez nem működik, mert a grid.arrange külön-külön várja az argumentumokat, nem egyetlen változóban tárolva
# Itt segít a do.call függvény! Kibontja a listában található argumentumokat
# és egyesével adja be a füvvgénynek:
# pl. do.call(grid.arrange,list(plot1,plot2)) = grid.arrange(plot1,plot2)
?do.call
do.call(grid.arrange,cut_plots$Premium)

# Ezután már csak végig kell iterálni a párosokat:
for (plot_pair in cut_plots) {
  # a do.call függvény összefűzi az argumentumokat
  # pl. do.call(grid.arrange,list(plot1,plot2)) = grid.arrange(plot1,plot2)
  do.call(grid.arrange,plot_pair)
}

# Most már nincs más dolgunk, mint nyitni egy pdf-et és abba küldeni a plot párosainkat!
pdf("diamond_plots.pdf", onefile = TRUE) # Itt tudatjuk a géppel, hogy innentől nem a saját ablakunkba, hanem egy podf fájlba kérjük a plotokat.
for (plot_pair in cut_plots) {
  do.call(grid.arrange, plot_pair)
}
dev.off() # Bezárjuk a fájlt és visszatérünk az IDE-ben történő plotoláshoz

# 5.1.1 Feladatok ----------

# Ábrázoljuk a flights tábla összes numerikus változóját hisztogramon!

# Nézzük meg az mtcars táblán, hogyan alakul a kocsik fogyasztása (mpg), illetve gyorsulása (qsec)
# a teljesítmény (hp) függvényében, lebontva a 4, 6, vagy 8 hengeres (cyl) kocsikra!

# 5.2 Ciklus és elágazás adatbeolvasáshoz ----------
# Könyvtár tartalmának listázása: dir() függvény
# Ha sokat dolgozunk ugyanabban a könyvtárban, érdemes a nevét változóba tenni!
stroop_dir <- 'data/stroop_rawdata/'
stroop_files <- dir(stroop_dir)

# itt is alkalamzhatjuk a head() és tail() parancsokat:
head(stroop_files)
tail(stroop_files)

# Szerertnénk minden fájlt beolvasni, ami tartalmazza a ".csv" kiterjesztést,
# ám van egy zip fájlunk is!
# Segítség: szöveg keresése szövegben a grepl() függvénnyel
grepl('.csv','az_en_kis_mappam/proba_log.csv')
grepl('.csv','az_en_kis_mappam/osszes_log.zip')

fulldf <- c()
for (fname in stroop_files){
  if (grepl('.csv',fname)){
    fullpath <- paste0(stroop_dir,fname)
    fulldf <- rbind(fulldf,read.csv(fullpath, header=T))
  }
}


# DE a dir() függvény teli van hasznosabbnál hasznosabb argumentumokkal!
?dir

fulldf <- c()
for (fname in dir(path = stroop_dir, pattern = '*.csv', full.names = T)){
  fulldf <- rbind(fulldf,read.csv(fname, header=T))
}

str(fulldf)
