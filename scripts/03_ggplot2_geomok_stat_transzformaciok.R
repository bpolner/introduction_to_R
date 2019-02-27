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

# Egyes geom-ok uj ertekeket szamitanak az abrazolashoz a stat algoritmussal

# Milyen ertekeket szamol a geom_bar()?


# geom es stat fuggvenyek felcserelhetoek,
# mert minden geom-nak van default stat-ja, es viszont
ggplot(data = diamonds) + 
    stat_count(mapping = aes(x = cut))

## 6.1 Statisztikai transzformaciok explicit meghatarozasa ----------------

# A geom_bar() stat argumentumanak felulirasa: mutassa a valtozok erteket 
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = price), stat = "identity")

# Az ertekek exponencialis (tudomanyos) formaban vannak az y tengelyen

# Lassuk inkabb az aranyokat a mennyiseg helyett
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))

# Mire valo a group argumentum? Probaljuk ki a sugoban levo peldakat!
?group


# Statisztikai szamitasok reszletezese
# y ertek statisztikai osszefoglalasa x minden egyedi ertekere

ggplot(data = diamonds) + 
    stat_summary(
        mapping = aes(x = cut, y = depth),
        fun.ymin = min,
        fun.ymax = max,
        fun.y = median
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
    geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

#### 7. A pozicio finomhangolasa --------------------------------

# Mi a kulonbseg a fill es a colour argumentumok kozott oszlopdiagramnal?
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = cut))

# Ha egy masik valtozot rendelunk a fill argumentumhoz
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity))

## 7.1 A position argumentum ----------------

# position="identity" atfedes miatt oszlopoknal nem szerencses
# Amint az lathato, ha attetszore allitjuk az oszlopokat
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
    geom_bar(alpha = 1/5, position = "identity")

# Vagy kitoltetlenul hagyjuk oket
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
    geom_bar(fill = NA, position = "identity")

# position="fill" jo, ha aranyokat akarunk osszehasonlitani
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# Vessük össze az ábrát a gyakorisági táblázattal!
table(diamonds$cut, diamonds$clarity)

# position="dodge" egymas melle pakolja az oszlopokat
# Ertekek kozvetlen osszevetesehez nagyon jo
ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# Mi lehet a problema egy ilyen pontfelhovel?
ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy))

# Adjunk egy kis "zajt" az adatokhoz, hogy ne egymason legyen a pontok
ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
# Ugyanez rovidebben
ggplot(data = mpg) +
    geom_jitter(mapping = aes(x = displ, y = hwy), width = 0.1)

ggplot(data = mpg) +
  geom_count(mapping = aes(x = displ, y = hwy), alpha = 0.5)



## 7.2 Gyakorlas - pozicio ----------------

# 1. Mi a gond ezzel az abraval? Hogyan lehetne ertelmesebbe tenni?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_point()

# 2. geom_jitter() fuggvenyben hogyan lehet szabalyozni a zaj merteket?

# 3. Mi a kulonbseg a geom_jitter() es a geom_count() kozott?

#### 8. Koordinata-rendszerek  --------------------------------

# x es y tengely felcserelese a coord_flip() fuggvennyel
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot() +
    coord_flip()

# "Polaris" koordinatarendszer a coord_polar() fugvennyel
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
  coord_fixed()

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


# Kérdés: mi lehet a limitációja annak, ha a csoportok közötti különbségeket oszlopdiagramokkal 
# mutatjuk meg? Hogyan lehetne ezt orvosolni?