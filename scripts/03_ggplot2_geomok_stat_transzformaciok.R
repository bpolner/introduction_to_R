###### Fedezzunk fel adatokat vizualisan a ggplot2-vel! (folytatas)

require(tidyverse)



# Ismétlés ----------------------------------------------------------------



#### 6. Statisztikai transzformaciok --------------------------------

# A ggplot2 tartalmaz gyémántokról szóló beépített adatokat
?diamonds

# Oszlopdiagram
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut))

# Mi van az x tengelyen? Es mi van az y tengelyen?

# Az y tengelyen a darabszám látszik - ez nincs is benne az adattáblában! 
# Egyes geom-ok uj ertekeket szamitanak az abrazolashoz egy algoritmussal, ezt nevezzük az adott geom stat-jának

# Milyen ertekeket szamol a geom_bar()?


# geom es stat fuggvenyek felcserelhetoek,
# mert minden geom-nak van default stat-ja, es viszont
ggplot(data = diamonds) + 
    stat_count(mapping = aes(x = cut))

## 6.1 Statisztikai transzformaciok explicit meghatarozasa ----------------

# A geom_bar() stat argumentumanak felulirasa: 


# a, mutassa a valtozok nyers erteket 

# Meghatározunk egy adattáblát, amiben már benne vagyok a csiszolások darabszámai
# (ennek a szintaxisát majd később megnézzük részletesen!)
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

# b, mutasson egy másik számított értéket 

# Lassuk inkabb az aranyokat a mennyiseg helyett
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))


# c, Ha jobban ki akarjuk fejteni a statisztikai szamitasokat

# stat_summary(): y ertek statisztikai osszefoglalasa x minden egyedi ertekere

ggplot(data = diamonds) + 
    stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.min = min,
        fun.max = max,
        fun = median
    ) 



# ggplot2 20+ stat fuggvenyt tartalmaz!
# Attekintesuk a ggplot2 cheatsheet-en:
# https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf 

## 6.2 Gyakorlas - statisztikai transzformaciok ----------------

# 1) Mi a stat_summary() default geom-ja? 
# Reprodukald a legutobbi abrat egy geom fuggvennyel!

# 2) Mit csinal a geom_col()? Miben kulonbozik a geom_bar()-tol?

# 3) Milyen ertekeket szamol a stat_smooth()? Milyen parameterekkel vezerelheto?

# 4) Az aranyokat mutato oszlopdiagram kodjaban miert van group=1?
# Mi a problema a ket alatta meghatarozott abraval?
ggplot(data = diamonds) +
    geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))

#### 7. A pozicio finomhangolasa --------------------------------

# Mi a kulonbseg a fill es a colour argumentumok kozott oszlopdiagramnal?
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = cut))

# Ha egy masik valtozot rendelunk a fill argumentumhoz
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity))

# Automatikusan fel lettek "polcolva" (stacked) az oszlopok
# Minden egyes téglalap a csiszolás (cut) és a tisztaság (clarity) egy-egy kombinációt mutatja

## 7.1 A position argumentum ----------------

# Milyen oszlopdiagramot lehet még készíteni?

# a, "identity" minden objektumot oda rak ahová esik a koordinátarendszeren belül
# atfedes miatt oszlopoknal nem szerencses

# Ez lathato, ha attetszore allitjuk az oszlopokat
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
    geom_bar(alpha = 1/5, position = "identity")

# Vagy kitoltetlenul hagyjuk oket
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
    geom_bar(fill = NA, position = "identity")

# b, position="fill" jo, ha aranyokat akarunk osszehasonlitani
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# Vessük össze az ábrát a gyakorisági táblázattal!
table(diamonds$cut, diamonds$clarity)

# c, position = "dodge" egymas melle pakolja az oszlopokat
# Ertekek kozvetlen osszevetesehez nagyon jo


ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# d, van még egy opció, ami pontfelhőknél nagyon jó

# Mi lehet a problema egy ilyen pontfelhovel?
ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy))


# Adjunk egy kis "zajt" az adatokhoz, hogy ne egymason legyen a pontok
ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# Ugyanez rovidebben
ggplot(data = mpg) +
    geom_jitter(mapping = aes(x = displ, y = hwy), width = 0.1)

# Nézzük meg, melyik displ+hwy kombinációban van több átfedő adatpont
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), alpha = 0.5)



## 7.2 Gyakorlas - pozicio ----------------

# 1. Mi a gond ezzel az abraval? Hogyan lehetne ertelmesebbe tenni?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_point()

# 2. geom_jitter() fuggvenyben hogyan lehet szabalyozni a zaj merteket?

# 3. Mi a kulonbseg a geom_jitter() es a geom_count() kozott?

#### 8. Koordinata-rendszerek  --------------------------------

# Az alapbeállítás a karteziánus koordináta-rendszer
# x és y értéke határozza meg a pontok helyét
# van még néhány további lehetőség is


# a, x es y tengely felcserelese a coord_flip() fuggvennyel

# ha az x tengelyen egymásba nyúlnak az egyes értékek címkéi

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot()


ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot() +
    coord_flip()


# b, "Polaris" koordinatarendszer a coord_polar() fugvennyel

bar <- ggplot(data = diamonds) + 
    geom_bar(
        mapping = aes(x = cut, fill = cut), 
        show.legend = FALSE,
        width = 1
    ) + 
    theme(aspect.ratio = 1) +
    labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

## 8.1 Gyakorlas - koordinata-rendszerek ----------------

# 1) Keszits "polcolt" (stacked) oszlopbol tortat a coord_polar() fuggvennyel!




# 2) Mit árul el ez az ábra a városi és az országúti fogyasztás kapcsolatáról?
# Miért fontos a coord_fixed() használata?
# Mit csinál a geom_abline()?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed(xlim = c(5, 45), ylim = c(5, 45))

#### 9. Osszefoglalas: a grafika nyelvtana a ggplot2-ben  -------------------------------- 

# ggplot(data = <DATA>) + 
#     <GEOM_FUNCTION>(
#         mapping = aes(<MAPPINGS>),
#         stat = <STAT>, 
#         position = <POSITION>
#     ) +
#     <COORDINATE_FUNCTION> +
#     <FACET_FUNCTION>

# Meg kell adni: adat <DATA>, kapcsolas <MAPPINGS>, es <GEOM>!
# Tobbire van mukodokepes default, ami felulirhato.


# 10. Egy kis ggplot2 egy másik adattal -----------------------------------


# Most nézzük a swiss beépített adathalmazt!
# Betöltése:
data(swiss)

# 1) Hány sorból és hány oszlopból áll az adattábla? 

# 2) Mit tartalmaznak a táblázat sorai?


# 3) Készíts pontfelhőt, ami bemutatja a kapcsolatot 
# a mezőgazdaságban dolgozó férfiak aránya és az 
# iskolázottsági mutató között!


# 4) Egy másik pontfelhőn szemléltesd a katolikusok aránya
# és a katoni vizsgálaton legjobb értékelést elértek aránya (Examination)
# közötti összefüggést!


# 5) Ábrázold pontfelhőn a mezőgazdaságban dolgozók aránya és a 
# katoni vizsgálaton legjobb értékelést elértek aránya (Examination)
# közötti összefüggést! 
# A megjelenítéshez használj teli négyzeteket, méretüket 
# állítsd 5-ösre! Tetszés szerint állítsd be a körvonal színét, 
# és a négyzetek áttetszőségét!
# Az összefüggést szemléltesd két külön faceten az inkább katolikus, 
# és az inkább protestáns "provinciák" esetében!
# A négyzetek kitöltőszíne tükrözze a katolikusok arányát!
# A négyzetek körvonalát állítsd vastagabbra 
# (a geom_point dokumentációjából kiderül, hogyan)!


# 6) Ábrázold kettő, az eddigi feladatokban nem szereplő, tetszőleges változó kapcsolatát, 
# egy harmadik változón alapuló csoportbontás szerint! 


# További javasolt gyakorlás: data() futtatásával megjelenik az összes beépített adathalmaz. 
# ?<ADATHALMAZ NEVE> futtatásával megnézheted az adatok dokumentációját.
# data(<ADATHALMAZ NEVE>) futtatásával pedig betöltheted az adatokat a workspace-re.
# Az eddig tanultakat felhasználva készíts ábrákat egy választott adathalmazról!