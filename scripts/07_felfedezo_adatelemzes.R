# Felfedező adatelemzés és ábrák készítése közleményekhez
# Encoding: UTF-8

require(markdown)
require(tidyverse)
require(plotly)
require(htmlwidgets)
require(GGally)
require(gridExtra)
require(corrplot)

library(plotly)
library(htmlwidgets)
library(listviewer)



# 1. Felfedező adatelemzés (Exploratory Data Analysis; EDA) -----------------

# 1. Találj ki kérdéseket az adatokkal kapcsolatban!
# 2. Próbáld megválaszolni őket ábrázolások, transzformációk, és modellek által!
# 3. Ezek fényében finomítsd a kérdéseket, és tegyél fel újakat!

# Érdemes jó sok kérdéssel indítani.
# Nagy vonalakban két dolog érdekes: 
# - milyen a változók variabilitása?
# - milyen a változók közös varianciája?


# 1.1 Változók variabilitásának vizsgálata --------------------------------

# Eloszlások megjelenítése

# Kategorikus változók

# Oszlopdiagram

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# Oszlopok magassága = x egyes értékeinek darabszáma

diamonds %>% 
  count(cut)

# Folytonos változók

# Hisztogram

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

# A megjelenített értékek kiszámolása

diamonds %>% 
  count(cut_width(carat, 0.5))

# geom_histogram binwidth argumentuma mondja meg, 
# hogy az x változót mekkora intervallumokra szabdaljuk fel
# az ábrázoláshoz - érdemes kipróbálni több értéket!
# Pl. csak a három karátnál kisebb gyémántok, keskenyebb binekkel:

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) 

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) + 
  facet_wrap(~ cut, nrow = 5)

ggplot(data = smaller, mapping = aes(x = carat, fill = cut)) +
  geom_histogram(binwidth = 0.1, alpha = .3) 


# Lehetőleg ne pakoljunk egymásra több hisztogramot!
# Használjunk inkább vonalakat:

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1, size = 3, alpha = .3)


# Mire érdemes figyelni?
# - Leggyakoribb és legritkább értékek. Miért? Váratlan dolgok?
# - Szokatlan mintázatok?

# Mi az érdekes ezen az ábrán?

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram()

# És ezen?

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

# Szokatlan értékek (outlier)

# - adatrögzítési hiba
# - váratlan és informatív megfigyelés

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

# Hol van itt az outlier?
# Közelítsünk rá az ábrára!

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  ylim(c(0, 50))



# Nézzük meg jobban ezeket a megfigyeléseket!

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)

unusual


# 1.1.1 Gyakorlás - eloszlások --------------------------------------------

# 1) Vizsgáld meg a price változó eloszlását! 
# Észreveszel-e valami furát?

ggplot(diamonds)  + 
  geom_histogram(aes(price))

ggplot(diamonds)  + 
  geom_histogram(aes(price), binwidth = 10)

ggplot(diamonds)  + 
  geom_histogram(aes(price), binwidth = 5) +
  coord_cartesian(xlim = c(1450,1550))




# 1.2 Hiányzó értékek -----------------------------------------------------

# Mit tegyünk ezekkel a furcsa gyémántokkal?

# A) eldobhatjuk őket

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

# Miért nem szerencsés?

# B) a furcsa értékeiket átírjuk hiányzóra

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

# ifelse(<logikai vektor>, <érték ha igaz>, <érték ha hamis>)

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

# ggplot2 figyelmeztet az NA-kra!

# Lehet, hogy pont a hiányzó értékeket tartalmazó megfigyelések érdekesek 
# Pl. mi jellemző a törölt járatokra?

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

# Miért nem túl informatív ez az ábra?



# 1.3 Változók közös varianciája ------------------------------------------


# Kategorikus vs. folytonos

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

# A gyakoriságokban nagy eltérések vannak, ezért nem túl jó az ábra

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

# Ilyenkor darabszám helyett érdemes a sűrűséget mutatni:

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)


# Vagy használhatunk boxplotot is

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# A rosszabb minőségű gyémántok drágábbak lennének?

# Nem minden kategorikus változó ordinális

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

# Az ábra áttekinthetőbb lehet, ha a 
# fogyasztás szerint sorbarendezzük a kategóriákat

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

# Ha hosszúak a változónevek, forgassunk egyet az ábrán:

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

# Kategorikus vs. kategorikus

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))


diamonds %>% 
  count(color, cut) 


diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


# Folytonos vs. folytonos

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

# Nagy adathalmazokon nem mindig segít az áttetszőség szabályzása
# Ilyenkor binekre is oszthatjuk az adatokat

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price), bins = 50)

# Készíthetünk boxplotot is:

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

# Gyors adatfelfedezés: corrplot és GGally 

ggpairs(mtcars)





# Több panelből álló ábrák összeállítása: gridExtra -----------------------



p1 <- ggplot(diamonds) + 
  geom_freqpoly(aes(price))

p2 <- ggplot(diamonds) + 
  geom_jitter(aes(price, carat))

o1 <- grid.arrange(p1, p2)

# Interaktív ábrák: plotly ------------------------------------------------

# https://plotly-book.cpsievert.me/ 



plot_ly(z = ~volcano)

p <- ggplot(txhousing, aes(date, median)) +
  geom_line(aes(group = city), alpha = 0.2)

# Két út a plotly objektumok létrehozására:
# 1) ggplotly(): egy ggplot objektum átalákítása

subplot(
  p, 
  ggplotly(p, tooltip = "city"), 
  ggplot(txhousing, aes(date, median)) + geom_bin2d(),
  ggplot(txhousing, aes(date, median)) + geom_hex(),
  
  nrows = 2, shareX = TRUE, shareY = TRUE,
  titleY = FALSE, titleX = FALSE
)

# 2) plot_ly(): közvetlenül az adatok megadása

# Adatok manipulálásra a dplyr függvényeit használhatjuk
library(dplyr)

# Pl. a csoportosított adatokat "érti" a plotly
tx <- group_by(txhousing, city)

# létrehozunk egy plotly objektumot
p <- plot_ly(tx, x = ~date, y = ~median)

# plotly_data() visszaadja egy plotly objektumhoz tartozó adatokat
plotly_data(p)


# Similar to geom_line() in ggplot2, the add_lines() function connects 
# (a group of) x/y pairs with lines in the order of their x values, 
# which is useful when plotting time series as shown in Figure 1.2.

# add a line highlighting houston
add_lines(
  # plots one line per city since p knows city is a grouping variable
  add_lines(p, alpha = 0.2, name = "Texan Cities", hoverinfo = "none"),
  name = "Houston", data = filter(txhousing, city == "Houston")
)

# Minden plotly függvény módosít egy plotly objektumot 
# (vagy a mögöttes adatokat), így a többrétegű ábrákat
# adatmódosítások és vizuális kapcsolások sorozataként is leírhatjuk,
# a %>% operátor használatával. 
# Tehát az előző ábra egyszerűbben:

allCities <- txhousing %>%
  group_by(city) %>%
  plot_ly(x = ~date, y = ~median) %>%
  add_lines(alpha = 0.2, name = "Texan Cities", hoverinfo = "none")



allCities %>%
  filter(city == "Houston") %>%
  add_lines(name = "Houston")

# Így viszont a pipeline végén már nem lehet az eredeti adatokat 
# visszanyerni, csak a Houstonra szűrt adatokat. 

plotly_data(allCities)

plotly_data(
  allCities %>%
    filter(city == "Houston") %>%
    add_lines(name = "Houston")
)

# Az add_fun függvénnyel kezelhető ez a probléma: 
# csak a plotly objektumot módosítja, az adatokat nem érinti

# Pl. egy pipelineban két várost is kiemelhetünk az ábrán:

allCities %>%
  add_fun(function(plot) {
    plot %>% filter(city == "Houston") %>% add_lines(name = "Houston")
  }) %>%
  add_fun(function(plot) {
    plot %>% filter(city == "San Antonio") %>% 
      add_lines(name = "San Antonio")
  })


# Az add_fun függvénynek további argumentumokat is megadhatunk,
# - az add_fun-nal valójában rétegeket adhatunk az ábrához!

# Create a reusable function for layering 
# both a particular city as well as the 
# first, second, and third quartile of median
# monthly house sales (by city).

# Írjunk egy függvényt, amivel ki tudunk emelni egy adott várost,
# és az 1., 2. és 3. kvartilisét a havi ingatlanértékesítések mediánjának!

#  fgv egy adott város kiemelésére
layer_city <- function(plot, name) {
  plot %>% filter(city == name) %>% add_lines(name = name)
}

# fgv a medián és az IQR megjelenítésére
layer_iqr <- function(plot) {
  plot %>%
    group_by(date) %>% 
    summarise(
      q1 = quantile(median, 0.25, na.rm = TRUE),
      m = median(median, na.rm = TRUE),
      q3 = quantile(median, 0.75, na.rm = TRUE)
    ) %>%
    add_lines(y = ~m, name = "median", color = I("black")) %>%
    add_ribbons(ymin = ~q1, ymax = ~q3, name = "IQR", color = I("black"))
}

allCities %>%
  add_fun(layer_iqr) %>%
  add_fun(layer_city, "Houston") %>%
  add_fun(layer_city, "San Antonio")

# A rétegképző függvényeknek nem muszáj pipeline-okat tartalmazniuk
# Egy szabály van: bemenetük és kimenetük is egy plot objektum legyen

