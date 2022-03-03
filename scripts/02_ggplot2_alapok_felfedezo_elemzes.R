###### Fedezzunk fel adatokat vizualisan a ggplot2-vel!


#### 0. Elokeszuletek ----------------  

# Toltsuk be a tidyverse csomagot 
# Ebben van ggplot2 is, meg egy csomo egyeb hasznos cucc

library(tidyverse)

#### 1. Adatok elso ranezesre ---------------- 

# Ma az mpg dataframe-mel fogunk jatszani.

# Hogy nez ki?
mpg

# Mit tartalmaz? Sugoban leirast talalunk.
?mpg

# Hany sor (~megfigyeles)? Hany oszlop (~valtozo)? 
nrow(mpg)
ncol(mpg)
dim(mpg)

# Mi a strukturaja? Az str() egy nagyon hasznos fuggveny.
str(mpg)

# Hogy nez ki az eleje es a vege? Erdemes ellenorizni beolvasas utan.
head(mpg)
tail(mpg)

#### 2. Ábrázoljunk!  --------------------------------

# Vajon milyen összefüggés van az autók fogyasztása és a hengerűrtartalom között?

# Az első sor létrehoz egy koordináta-rendszert, amihez hozzáadhatunk rétegeket
ggplot(data = mpg) +
  # Hozzáadunk egy réteget, ahol a pontok x és y koordinátáihoz rendeljük a változókat
  geom_point(mapping = aes(x = displ, y = hwy))

# Minden geom függvénynek van mapping argumentuma.
# A mappinget mindig az aes() fgv-nyel adjuk meg.
# A ggplot2 a mapping-ben megadott változókat a data argumentumnál 
# meghatározott adatban keresi. 

# Általános alak:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

## 2.1 Gyakorlas - az abrakeszites alapjai ----------------

# 1) Mit mutat a drv valtozo? 

# 2) Keszitsunk pontfelhot hwy es cty valtozokrol!



#### 3. Esztetikai parameterek beallitasa --------------------------------

# Néhány autó mintha "kilógna" a mintára jellemző trendből. 
# Milyen szempontból lehetnek speciálisak azok az autók?
# Jelenítsük meg a különböző osztályú autókat eltérő színnel!

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

# a colour-hoz rendelt változó minden egyedi szintje saját színt kapott az ábrán
# jelmagyarázat is automatikusan létrejött

# Más esztétikai paraméterekhez is hozzárendelhetünk egy változót

# Áttetszőséghez (bár ebben az esetben nincs igazán értelme)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Hogyan rendelnétek hozzá az osztályt a pontok méretéhez?


# És a pontok formájához?


# Az esztétikai paramétereket kézileg is állíthatjuk. 
# Ilyenkor az aes() után, a geom függvény egy argumentumának 
# értékét megadva állíthatjuk be a megjelenést. 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "darkblue")

# Színek: string
# Méret: szám (mm)
# Forma: egész szám

# Milyen formák közül választhatunk?

minta_adat <- data.frame(x = 0:25, 
                         y = 0:25, 
                         z = factor(0:25)
)

ggplot(data = minta_adat) +
  geom_point(aes(x = x, y = y, shape = z), colour = "black", fill = "red", size = 8) + 
  scale_shape_manual(values = 0:25)


## 3.1 Gyakorlas - esztétikai paraméterek ----------------

# 1) Miért nem kékek a pontok?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# 2) Melyek a folytonos es kategorikus változók az mpg-ben? 


# 3) color, shape, size hogyan viselkedik, ha folytonos változót rendelünk hozzá?


# 4) Mi történik, ha egy változót több esztétikai paraméterhez is hozzárendelünk?


# 5) Mi történik, ha nem egyszerűen egy változót használunk az esztétika megadásánál?
# pl. aes(color=displ<5) ?


# 6) Miért nem működnek ezek a kódok?

ggplot(data = mpg) 
+ geom_point(mapping = aes(x = displ, y = hwy))


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue")
             
# 7) Készíts egy pontfelhőt, ahol az x tg-en a displ, az y tg-en a hwy változó szerepel.
# Használj 10-es méretű pontokat! Mi lehet a probléma ezzel az ábrával? 
# Hogyan lehetne javítani az ábrán, anélkül, hogy a pontok méretén változtatnál?



#### 4. Facet-ek --------------------------------

# Nem csak az esztétikai paraméterekkel jeleníthetünk meg további változókat.
# Elkészíthetjük ugyanazt az ábrát az adat alhalmazain.

# Ha az alhalmazokat csak egy kategorikus változó mentén szeretnénk létrehozni,
# használjuk a facet_wrap-et!

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  # 1. argumentuma egy formula (ami egy adatstruktúra az R-ben):
  # formátuma: ~ <változó neve>
  facet_wrap( ~ class, nrow = 2)

# Ha két változót kombinálva szeretnénk alhalmazokat képezni, 
# használjuk a facet_grid-et!

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  # formula formátuma facet_grid esetében:
  # <változó az y tg-re> ~ <változó az x tg-re>
  facet_grid(drv ~ class)

# facet_grid létrehozható csak egy változó szerint is:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

## 4.1 Gyakorlas - facetek ----------------

# 1) Mi történik, ha folytonos változót rendelünk facet-hez?

# 2) Mit jelentenek az ures cellak a facet_grid(drv~class) abran?
# Hogyan viszonyulnak ehhez?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

# 3) Mi tortenik itt? Mit csinal a . ?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# 4) Készíts pontfelhőt, ahol a vízszintes tg-en a városi, 
# a függőleges tengelyen pedig az országúti fogyasztás van megjelenítve!
# A pontok színe tükrözze a hengerek számát!
# Az üzemanyag típusa szerint hozz létre faceteket!



# 5) Mik az előnyei és hátrányai a fazettázásnak az 
# esztétikai paraméterekhez rendeléshez képest?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# 6) facet_wrap-ban mit csinal ncol es nrow? Mit lehet meg beallitani?

#### 5. Geometriai objektumok (geom) --------------------------------

# A ggplot2-ben többféle geometriai objektummal 
# reprezentálhatjuk az adatokat.

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy))

ggplot(data=mpg) + 
  geom_smooth(mapping=aes(x=displ, y=hwy))

# Minden geom függvénynek van mapping argumentuma.
# DE: az egyes geom tipusok eltérő esztétikai paraméterekkel rendelkeznek.

# Pl. trendvonalnál állítható a vonaltípus.

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# A pontfelhőnél pedig pl. a pont formája.

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy, shape = drv))

# Több, azonos megjelenésű geom csoportonkénti bontásban: group

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

# Elhelyezhetünk több geom-ot is egy ábrán:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Ugyanazt a mapping-et adtuk meg kétszer. Ezt jó lenne egyszerűbben megadni.

# Globális mapping megadása a ggplot() függvénynek.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# A globális mapping-et felülírhatjuk csak egy adott rétegben.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# Trendvonal illesztésének meghatározása

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(method = "lm") +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), color = "red")

# A geom-ok által reprezentált adatokat is felülírhatjuk lokálisan 
# a data argumentum felulirasa csak egy retegben.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
# a trendvonalat csak a subcompact osztályú autókra illesztettük
# (a filter függvénnyel majd később foglalkozunk)

## 5.1 Gyakorlas - geometriai objektumok  ----------------

# 1) Melyik geom_ függvényt használnád... 
#    vonaldiagram, boxplot, hisztogram készítéséhez?



# 2) A kód futtatása előtt írd le szavakkal, hogy fog kinézni az ábra!

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3) A kód futtatása nélkül mondd meg, lesz-e különbség a két ábra között!
# Miért / miért nem?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
