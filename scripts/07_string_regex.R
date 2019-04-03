# String-ek és reguláris kifejezések 

# Bevezetés az R programozásba (2018. április 12.)

require(tidyverse)

# 1 String alapok ----

# Az R-ben a dupla és az egyszeres idézőjelek egyaránt használhatóak string-ek létrehozására:

string1 <- "Ez egy string"
string2 <- 'Ha "idézetet" akarok a stringen belül, az egyszeres idézőjelet használjuk'

# Ha idézőjelet akarsz a string-en belül elhelyezni, használd a \ escape karaktert:
  
double_quote <- "\"" # vagy '"'
single_quote <- '\'' # vagy "'"

# Visszaperhez:
  
"\\"

# Ahogy a string megjelenik a konzolon, az nem ugyanaz, mint a string maga:
# a konzolra nyomtatott reprezentációban látszódnak az escape karakterek is.
# Egy string nyers tartalmát a writeLines függvénnyel lehet megnézni.

x <- c("\"", "\\")
x
writeLines(x)

# Egyéb spec. karakterek:  
  
# \n = új sor 
# \t = tab

# Bővebben lásd:
?"'"

# Több string-et általában karaktervektorban tárolunk. Létrehozása: c()

c("első", "második", "harmadik")


# String-ek kezelésére ajánlott a stringr csomag:
#   
# * konzisztens viselkedés
# * intuitív fgv nevek
# * minden fgv str_ - el kezdődik (auto kieg. miatt is nagyon hasznos!)

# Még több string-függvény a stingi csomagban
# https://www.rdocumentation.org/packages/stringi/versions/1.1.6

# Pl. milyen hosszú egy string (=hány karakterből áll)?
  
str_length(c("a", "R for data science", NA))

# String-ek kombinálása

str_c("x", "y")

# Elválasztó szabályzása

str_c("x", "y", "z", sep = "%%%%")

# Hasonló célt szolgál a base R paste() és paste0() fgv-e

paste("x", "y", "z")

paste0("x", "y", "z")

# A hiányzó adatokra a stringr fgv-ek is NA-t adnak vissza!
  
x <- c("abc", NA)

str_c("|-", x, "-|")


# Ha hiányzó adat esetén NA-t szeretnénk látni string-ként: str_replace_na()

str_c("|-", str_replace_na(x), "-|")

# Az str_c vektorizált: rövidebb vektorok "újrahasznosítja", amíg a leghosszabb vektor tart

str_c("prefix-", c("a", "b", "c"), "-suffix")

# Karaktervektorból egyetlen string-et:
  
str_c(c("x", "y", "z"), collapse = ";   ")

# Részek kivágása string-ekből

x <- c("Apple", "Banana", "Pear")

str_sub(x, start = 1, end = 3)


# Ha hátulról számítva szeretnénk megadni a pozíciót, 
# adjunk meg negatív számokat:

str_sub(x, start = -3, end = -1)

# Az str_sub akkor is lefut, ha a string "túl rövid"

str_sub("a", 1, 5)


# str_sub string-ek egyes részeinek címzésére is jó (string-ek átírásához)

x
str_sub(x, 1, 1) <- "X"
x


# Locale beállítások: nyelvi sajátosságok
# Pl. török nyelvben kétféle nagy I:
  
str_to_upper(c("i", "i"))
str_to_upper(c("i", "i"), locale = "tr")

# Locale kódok listája a Wikipédián:
# https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes

# Ha nem adjuk meg, akkor az operációs rendszer által megadott locale lesz érvényes
# A locale a sorbarendezést is befolyásolhatja

# base R order() és sort() az aktuális locale szerint működnek

# str_sort() és str_order() locale argumentuma hasznos:
  
x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")  # English
str_sort(x, locale = "haw") # Hawaiian


# 1.1 Gyakorlás - string alapok ----

# 1) Nyerd ki a lenti string-ek középső karakterért az str_length és az str_sub használatával!
  
str_2 <- "Második"

str_3 <- "Harmadik"


# 2 Reguláris kifejezések (regex) 1 .----

# A reguláris kifejezésekkel leírhatunk mintázatokat stringekben

# str_view() és str_view_all() megmutatják, 
# hogy egy regex hol egyezik egy string-gel

# Legegyszerűbb eset: konkrét mintázat keresése

x <- c("apple", "banana", "pear")
str_view(x, "an")

# Bármilyen karakterrel (kivéve sortörés \n) való egyezés: . 

str_view(x, ".a.")

# De akkor hogyan keresünk rá a pontokra?
str_view(c("abc", "a.c", "bef"), "a.c")

# Escape karaktert (\) kell használni hozzá
# Csakhogy a regex-eket string-gel adjuk meg,
# és a string-ekben is escape karakternek számít a \ 
# ezért a \. reguláris kifejezés megadásához \\ kell
dot <- "\\."

# De magában a kifejezésben már csak egy \ van:
dot
writeLines(dot)

# Így már tudunk keresni  konkrét  .-ot string-ben:
str_view(c("abc", "a.c", "bef"), "a\\.c")
str_view(c("abc", "a.c", "bef"), "a.c")

str_view(c("abc", "a\nc", "bef"), "a\\nc")

# Hogyan keressünk rá egy \-re egy string-ben?

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

# Miért? A regex meghatározásakor, és a regex meghatározó string meghatározásakor is escape-elni kell!

# Milyen mintázatokkal egyezne ez a regex: \..\..\.. ?


# Lehorgonyzás

# String eleje és vége

x <- c("apple", "banana", "pear")

# Eleje:

str_view(x, "^a")

# Vége

str_view(x, "a$")


# Teljes egyezés keresése a kettőt kombinálva:

x <- c("apple pie", "apple", "apple cake")

str_view(x, "apple")

str_view(x, "^apple$")

# Szóhatárok: \b

teszt <- "kis kisautó kiskunfélegyháza"
str_view_all(teszt, "kis")
str_view_all(teszt, "kis\\b")

# Karakterosztályok és alternatívák

# \d - bármely számjegy

str_view("c1_bd", "\\d")

# \s - szóköz, tab, sortörés

str_view(c("nincsszóköz", "van szóköz", "van\ttab", "van\nsortörés"), "\\s")

# Felsorolt karakterek keresése: []
str_view(c("abc", "cde", "tfsag"), "[ab]")


# Karakterek keresése kivéve a felsoroltak: [^]
str_view(c("abc", "cde", "tfsag"), "[^abc]")

# Különböző változatok: |
str_view(c("grey", "gray"), "gr(e|a)y")

str_view(c("abc", "hhahad", "edhahjaja"), "abc|h")

# 2.1 Gyakorlás - regex 1. ----

# 1) Írj olyan regexeket, amik a stringr words korpuszán visszaadják 
# (str_view() match argumentuma!)
# 
# a) az y-nal kezdődő szavakat

# b) az x-re végződő szavakat

# c) pontosan három betűből állnak (az str_length használata nélkül!)

# d) hét, vagy több betűből állnak


# 2) Írj olyan reguláris kifejezést, 
# ami megtalálja azokat a szavakat
# a) amik ed-re (de nem eed-re) végződnek!


# b) amik vége ing vagy ise!


# 3 Reguláris kifejezések (regex) 2 .----

# Ismétlődés

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"

# Egyszer vagy egyszer sem ismétlődik a megelőző elem:
# ?

str_view(x, "CC?")

# Egyszer vagy többször ismétlődik a megelőző elem: 
# +

str_view(x, "CC+")

str_view(x, "C[LX]+")

str_view(x, "C+L+X+")

# Egyszer sem vagy többször ismétlődik a megelőző elem:
# *

str_view(x, "CS*L*X")

# Az ismétlődés számának pontos meghatározása

# {n}: pontosan n-szer

str_view(x, "C{2}")

# {n,}: n-szer vagy többször

str_view(x, "C{1,}")

# {n,m}: n és m közötti alkalommal

str_view(x, "C{2,3}")

# Ezek a keresések mohók: a lehető leghosszabb string-et találják meg
# Lazává alakíthatjuk őket (lehető legrövidebb string), ha ?-et teszünk utánuk

str_view(x, "C{1,}?")
# Miért működik ez így?

# Csoportosítás és visszautalás 

# A zárójellel körülhatárolt csoportokra később visszautalhatunk \1, \2, stb.

# Pl. ismétlődő betűpárok keresése:

str_view(fruit, "(..)\\1", match = TRUE)

# 3.1 Gyakorlás - regex 2. ----

# 1) Hogyan írnád fel a ?-t, a +-t és a *-t {m,n} formában?

# ? = Egyszer vagy egyszer sem ismétlődik a megelőző elem
# + = Egyszer vagy többször ismétlődik a megelőző elem
# * = Egyszer sem vagy többször ismétlődik a megelőző elem

str_view("aaabbcddEEEE", "E?")

str_view("aaabbcddEEEE", "E+")

str_view("aaabbcddEEEE", "E*")

# 2) Mit keresnek ezek a regex-ek? Írjuk le szavakkal!
# (néhol a regex, máshol a regex-et megadó string látható!)

# a) ^.*$
# b) "\\{.+\\}"
# c) \d{4}-\d{2}-\d{2}
# d) "\\\\{4}"

# 3) Írjunk egy olyan regex-et, 
# ami megtalálja azokat a szavakat, amik
# ugyanolyan a karakterrel kezdődnek és végződnek!


# 4 A regex alkalmazásai 1. ----

# Melyik string-ek egyeznek?
# Hol vannak az egyezések?
# Mik az egyezések?
# Egyezések cseréje új értékekre
# String darabolása az egyezések mentén

# Melyik string-ek egyeznek?

x <- c("apple", "banana", "pear")

str_detect(x, "e")

# Logikai vektorokon végezhetünk számításokat:

# Hány szó kezdődik t-vel?

sum(str_detect(words, "^t"))

# Milyen arányban végződnek a szavak magánhangzóval?

mean(str_detect(words, "[aeiou]$"))

# Néha jobb egy egyszerű regex kombinálva logikai operátorokkal,
# mint egy bonyolult regex:

# Keressük meg a magánhangzókat nem tartalmazó szavakat!

# 1: megkeressük a magánhangzót tartalmazó szavakat, majd tagadunk

no_vowels_1 <- !str_detect(words, "[aeiou]")

# 2: megkeressük a csak msh-kból (nem mgh-kból) álló szavakat:

no_vowels_2 <- str_detect(words, "^[^aeiou]+$")

# A kettő ugyanarra az eredményre vezet:

identical(no_vowels_1,no_vowels_2)

# Mintázattal egyező elemek kiválasztása logikai vektorral:

words[str_detect(words, "x$")]

# Röviden:

str_subset(words, "x$")

# Ha a string-ek egy adattábla oszlopában vannak, 
# és a string változó szerint szeretnénk szűrni:

# A példa kedvéért tegyük be egy adattáblába a words vektort!
df <- tibble(
  word = words, 
  i = seq_along(word)
)

# Tartsuk meg az "x"-re végződő szavakat!
df %>% 
  filter(str_detect(words, "x$"))

# Hány darab egyezés van egy string-en belül? str_count()

x <- c("apple", "banana", "pear")

str_count(x, "a")

# Azt is megmondhatjuk, átlagosan hány mgh van egy szóban:

mean(str_count(words, "[aeiou]"))

# Adja magát, hogy az str_count()-t a mutate()-tel kombináljuk:

df %>% 
  mutate(
    mgh = str_count(word, "[aeiou]"),
    msh = str_count(word, "[^aeiou]")
  )

# Figyelem: átfedő találatok nem számítanak!

str_view("abababa", "aba") 
str_view_all("abababa", "aba") # _all végződésű stringr fgv-ek az összes egyezést mutatják

# 4.1 Gyakorlás - regex alkalmazások 1. ----

# Oldjuk meg az alábbi problémákat egyetlen regex 
# ÉS több str_detect() kombinálásával IS!


# 1) y-nal kezdődő vagy x-re végződő szavak kigyűjtése


# 2) Mgh-val kezdődő és msh-val végződő szavak kigyűjtése
  

# 5 Regex alkalmazásai 2. ----

# Hol vannak az egyezések?
# Mik az egyezések?
# Egyezések cseréje új értékekre
# String darabolása az egyezések mentén

# Egyező string kinyerése: str_extract() 

# Harvard sentences 
# https://en.wikipedia.org/wiki/Harvard_sentences

length(sentences)

head(sentences)

# Keressük ki azokat a mondatokat, amelyekben színekről van szó

# Hozzunk létre egy vektort a színek neveivel?

colours <- c("red", "orange", "green", "blue", "yellow", "purple")

# Ebből hozzunk létre egy regex-et!

colour_match <- str_c(colours, collapse = "|")

# Ennek segítségével kinyerhetjük a színeket tartalmazó mondatokat

has_colour <- str_subset(sentences, colour_match)

# És a mondatokból is kinyerhetjük az egyező színeket:

matches <- str_extract(has_colour, colour_match)
head(matches)

# Figyelem: az str_extract() csak az első egyezést nyerte ki
# Járjunk utána!

more <- sentences[str_count(sentences, colour_match) > 1]

str_view_all(more, colour_match)

str_extract(more, colour_match)

str_extract_all(more, colour_match)

# Gyakorlás: nyerjük ki minden mondatból az első szót!


# Csoportos egyezések 

# Hogyan nyerjünk ki főneveket a mondatokból?
# Heurisztika: "a" vagy "the" után következő szavakat nyerünk ki.
# Hogyan határozzuk meg a szavakat? 
# Közelítés: 
# legalább egy karakterből álló sorozat, amiben szóköz nem szerepel

fn <- "(a|the) ([^ ]+)"

# Első tíz főnevet tartalmazó mondatot eltesszük egy vektorba:

van_fn <- sentences %>%
  str_subset(fn) %>%
  head(10)

# Kiszedjük belőlük a főneveket:

van_fn %>% 
  str_extract(fn)

# str_extract() visszaadta a teljes egyezést
# str_match() egy mátrixban adja vissza a 
# teljes egyezést és az egyezés "darabjait"

van_fn %>% 
  str_match(fn)

# Ha már tibble-ban vannak az adatok,
# ilyesmi célra még jobb a tidyr::extract()
# ahol nevet kell adni az egyezéseknek, 
# amik aztán külön oszlopokba kerülnek:


tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = FALSE
  )

# Egyezések cseréje

x <- c("apple", "pear", "banana")

# Futtatás előtt: mi fog történni itt?

str_replace(string = x, pattern = "[aeiou]", replacement = "-")

str_replace_all(string = x, pattern = "[aeiou]", replacement = "-")

# str_replace_all()-nak megadható névvel ellátott vektor

x <- c("1 house", "2 cars", "3 people")

str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

# Darabolás

# Pl. mondatokat szavakra szét tudjuk szedni

sentences %>%
  head(5) %>% 
  str_split(pattern = " ")

# lista helyett mátrixot is kérhetünk

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)


# Mintázatok helyett határok mentén is darabolhatunk

x <- "Ez egy mondat. Ez meg egy másik mondat."
str_view_all(x, boundary("word"))
str_view_all(x, boundary("sentence"))

str_split(x, " ")

str_split(x, boundary("word"))
str_split(x, boundary("sentence"))
str_split(x, boundary("character"))

# Egyezések keresése

x <- "Jobb egy lúdnyak tíz tyúknyaknál"

# Hol kezdődik, és hol ér véget az első nyak?

str_locate(x, "\\b[:alpha:]*nyak")

# Hol kezdődnek és hol érnek véget a nyakak?

str_locate_all(x, "\\b[:alpha:]*nyak")

# Milyen nyakakról van itt szó?

str_sub(x, start = str_locate_all(x, "\\b[:alpha:]*nyak")[[1]][1,1], end = str_locate_all(x, "\\b[:alpha:]*nyak")[[1]][1,2])

str_sub(x, start = str_locate_all(x, "\\b[:alpha:]*nyak")[[1]][2,1], end = str_locate_all(x, "\\b[:alpha:]*nyak")[[1]][2,2])
