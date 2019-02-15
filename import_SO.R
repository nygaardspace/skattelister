

setwd("~/Norquant_skattelister")
load("skattelisterNov2017.RData")

library(tidyverse)
alle_kommuner <- rbind(oslo, ostfold, akershus, hedmark, oppland, buskerud, vestfold, telemark, aust_agder, vest_agder, rogaland, hordaland, sogn, more, sor_trond, nord_trond, nordland, troms, finnmark)
alle_kommuner <- as.tibble(alle_kommuner)
kommune_names <- c("Oslo")

library(xlsx)
library(stringr)
getTLF <- function(htmlString) {
  #temp <- sub(".*<a href='tel:(\\d{8})'>(\\d{8})</a>","\\2",htmlString)
  #temp <- gsub('\\D+','', temp)
  #pat <- ".*<a href='tel:(\\d{8})'>(\\d{8})</a>"
  #temp <- sub(pat, "\\1", htmlString[grepl(pat, htmlString)])
  temp <- str_match(htmlString, ".*<a href='tel:(\\d{8})'>(\\d{8})</a>")[, 2]
  return(temp)
}
alle_kommuner$tlf1 <- NA
alle_kommuner$tlf2 <- NA
alle_kommuner$tlf3 <- NA
  
alle_kommuner["tlf1"] <- getTLF(alle_kommuner[["contact_1881"]])
alle_kommuner["tlf1"] <- as.numeric(alle_kommuner[["tlf1"]])
alle_kommuner[["tlf2"]] <- getTLF(alle_kommuner[["contact_180no"]])
alle_kommuner[["tlf2"]] <- as.numeric(alle_kommuner[["tlf2"]])
alle_kommuner[["tlf3"]] <- getTLF(alle_kommuner[["contact_gulesider"]])
alle_kommuner[["tlf3"]] <- as.numeric(alle_kommuner[["tlf3"]])
alle_kommuner["address"] <- NA

for(i in 1:nrow(alle_kommuner)){
  temp <- sub(paste0(" <a href='tel:",alle_kommuner$tlf1[i],"'>",alle_kommuner$tlf1[i],"</a> "),"",alle_kommuner$contact_1881[i])
  temp <- sub(paste0(" ",alle_kommuner$navn[i]),"",temp)
  temp <- sub("^\\s+","", temp)
  alle_kommuner$address[i] <- temp
}

alle_kommuner$company_navn <- alle_kommuner$navn
alle_kommuner$category <- "Kunde"
alle_kommuner$business <- "Bank/finans"
alle_kommuner$note <- paste(alle_kommuner[["contact_1881"]],alle_kommuner[["contact_180no"]],alle_kommuner[["contact_gulesider"]],sep = '\n')

#Add kommune nummere
oslo1 <- c("301")
oslo2 <- c("Oslo")
ostfold1 <- c("101","104","105","106","111","118","119","121","122","123","124","125","127","128","135","136","137","138")
ostfold2 <- c("Halden","Moss","Sarpsborg","Fredrikstad","Hvaler","Aaremark","Marker","Rømskog","Trøgstad","Spydeberg","Askim","Eidsberg","Skiptvet","Rakkestad","Råde","Rygge","Våler","Hobøl")
akershus1 <- c("211","214","215","216","217","219","220","221","226","227","228","229","230","231","233","234","235","236","237","238","239")
akershus2 <- c("Ski","Ås","Frogn","Nesodden","Oppegård","Bærum","Asker","Aurskog-Høland","Sørum","Fet","Rælingen","Enebakk","Lørenskog","Skedsmo","Nittedal","Gjerdrum","Ullensaker","Nes","Eidsvoll","Nannestad","Hurdal")
hedmark1 <- c("402","403","412","415","417","418","419","420","423","425","426","427","428","429","430","432","434","436","437","438","439","441")
hedmark2 <- c("Kongsvinger","Hamar","Ringsaker","Løten","Stange","Nord-Odal","Sør-Odal","Eidskog","Grue","Åsnes","Våler","Elverum","Trysil","Åmot","Stor-Elvdal","Rendalen","Engerdal","Tolga","Tynset","Alvdal","Folldal","Os")
oppland1 <- c("501","502","511","512","513","514","515","516","517","519","520","521","522","528","529","532","533","534","536","538","540","541","542","543","544","545")
oppland2 <- c("Lillehammer","Gjøvik","Dovre","Lesja","Skjåk","Lom","Vågå","Nord-Fron","Sel","Sør-Fron","Ringebu","Øyer","Gausdal","Østre Toten","Vestre Toten","Jevnaker","Lunner","Gran","Søndre Land","Nordre Land","Sør-Aurdal","Etnedal","Nord-Aurdal","Vestre Slidre","Øystre Slidre","Vang")
buskerud1 <- c("602","604","605","612","615","616","617","618","619","620","621","622","623","624","625","626","627","628","631","632","633")
buskerud2 <- c("Drammen","Kongsberg","Ringerike","Hole","Flå","Nes","Gol","Hemsedal","Ål","Hol","Sigdal","Krødsherad","Modum","Øvre Eiker","Nedre Eiker","Lier","Røyken","Hurum","Flesberg","Rollag","Nore og Uvdal")
vestfold1 <- c("701","702","704","706","709","711","713","714","716","719","720","722","723","728")
vestfold2 <- c("Horten","Holmestrand","Tønsberg","Sandefjord","Larvik","Svelvik","Sande","Hof","Re","Andebu","Stokke","Nøtterøy","Tjøme","Lardal")
telemark1 <- c("805","806","807","811","814","815","817","819","821","822","826","827","828","829","830","831","833","834")
telemark2 <- c("Porsgrunn","Skien","Notodden","Siljan","Bamble","Kragerø","Drangedal","Nome","Bø","Sauherad","Tinn","Hjartdal","Seljord","Kviteseid","Nissedal","Fyresdal","Tokke","Vinje")
austagd1 <- c("901","904","906","911","912","914","919","926","928","929","935","937","938","940","941")
austagd2 <- c("Risør","Grimstad","Arendal","Gjerstad","Vegårshei","Tvedestrand","Froland","Lillesand","Birkenes","Åmli","Iveland","Evje og Hornnes","Bygland","Valle","Bykle")
vestagd1 <- c("1001","1002","1003","1004","1014","1017","1018","1021","1026","1027","1029","1032","1034","1037","1046")
vestagd2 <- c("Kristiansand","Mandal","Farsund","Flekkefjord","Vennesla","Songdalen","Søgne","Marnardal","Åseral","Audnedal","Lindesnes","Lyngdal","Hægebostad","Kvinesdal","Sirdal")
rogaland1 <- c("1101","1102","1103","1106","1111","1112","1114","1119","1120","1121","1122","1124","1127","1129","1130","1133","1134","1135","1141","1142","1144","1145","1146","1149","1151","1160")
rogaland2 <- c("Eigersund","Sandnes","Stavanger","Haugesund","Sokndal","Lund","Bjerkreim","Hå","Klepp","Time","Gjesdal","Sola","Randaberg","Forsand","Strand","Hjelmeland","Suldal","Sauda","Finnøy","Rennesøy","Kvitsøy","Bokn","Tysvær","Karmøy","Utsira","Vindafjord")
hordaland1 <- c("1201","1211","1216","1219","1221","1222","1223","1224","1227","1228","1231","1232","1233","1234","1235","1238","1241","1242","1243","1244","1245","1246","1247","1251","1252","1253","1256","1259","1260","1263","1264","1265","1266")
hordaland2 <- c("Bergen","Etne","Sveio","Bømlo","Stord","Fitjar","Tysnes","Kvinnherad","Jondal","Odda","Ullensvang","Eidfjord","Ulvik","Granvin","Voss","Kvam","Fusa","Samnanger","Os","Austevoll","Sund","Fjell","Askøy","Vaksdal","Modalen","Osterøy","Meland","Øygarden","Radøy","Lindås","Austrheim","Fedje","Masfjorden")
sogn1 <- c("1401","1411","1412","1413","1416","1417","1418","1419","1420","1421","1422","1424","1426","1428","1429","1430","1431","1432","1433","1438","1439","1441","1443","1444","1445","1449")
sogn2 <- c("Flora","Gulen","Solund","Hyllestad","Høyanger","Vik","Balestrand","Leikanger","Sogndal","Aurland","Lærdal","Årdal","Luster","Askvoll","Fjaler","Gaular","Jølster","Førde","Naustdal","Bremanger","Vågsøy","Selje","Eid","Hornindal","Gloppen","Stryn")
more1 <- c("1502","1505","1504","1511","1514","1515","1516","1517","1519","1520","1523","1524","1525","1526","1528","1529","1531","1532","1534","1535","1539","1543","1545","1546","1548","1551","1554","1560","1557","1560","1563","1566","1567","1571","1573")
more2 <- c("Molde","Kristiansund","Ålesund","Vanylven","Sande","Herøy","Ulstein","Hareid","Volda","Ørsta","Ørskog","Norddal","Stranda","Stordal","Sykkylven","Skodje","Sula","Giske","Haram","Vestnes","Rauma","Nesset","Midsund","Sandøy","Aukra","Fræna","Eide","Averøy","Frei","Gjemnes","Tingvoll","Surnadal","Rindal","Halsa","Smøla")
sor_trond1 <- c("1601","1612","1613","1617","1620","1621","1622","1624","1627","1630","1632","1633","1634","1635","1636","1638","1640","1644","1648","1653","1657","1662","1663","1664","1665")
sor_trond2 <- c("Trondheim","Hemne","Snillfjord","Hitra","Frøya","Ørland","Agdenes","Rissa","Bjugn","Åfjord","Roan","Osen","Oppdal","Rennebu","Meldal","Orkdal","Røros","Holtålen","Midtre Gauldal","Melhus","Skaun","Klæbu","Malvik","Selbu","Tydal")
nord_trond1 <- c("1702","1703","1711","1714","1717","1718","1719","1721","1724","1725","1736","1738","1739","1740","1742","1743","1744","1748","1749","1750","1751","1755","1756")
nord_trond2 <- c("Steinkjer","Namsos","Meråker","Stjørdal","Frosta","Leksvik","Levanger","Verdal","Verran","Namdalseid","Snåsa","Lierne","Røyrvik","Namsskogan","Grong","Høylandet","Overhalla","Fosnes","Flatanger","Vikna","Nærøy","Leka","Inderøy")
nordland1 <- c("1804","1805","1811","1812","1813","1815","1816","1818","1820","1822","1824","1825","1826","1827","1828","1832","1833","1834","1835","1836","1837","1838","1839","1840","1841","1845","1848","1849","1850","1851","1852","1853","1854","1856","1857","1859","1860","1865","1866","1867","1868","1870","1871","1874")
nordland2 <- c("Bodø","Narvik","Bindal","Sømna","Brønnøy","Vega","Vevelstad","Herøy","Alstahaug","Leirfjord","Vefsn","Grane","Hattfjelldal","Dønna","Nesna","Hemnes","Rana","Lurøy","Træna","Rødøy","Meløy","Gildeskål","Beiarn","Saltdal","Fauske","Sørfold","Steigen","Hamarøy","Tysfjord","Lødingen","Tjeldsund","Evenes","Ballangen","Røst","Værøy","Flakstad","Vestvågøy","Vågan","Hadsel","Bø","Øksnes","Sortland","Andøy","Moskenes")
troms1 <- c("1903","1902","1911","1913","1917","1919","1920","1922","1923","1924","1925","1926","1927","1928","1929","1931","1933","1936","1938","1939","1940","1941","1942","1943")
troms2 <- c("Harstad","Tromsø","Kvæfjord","Skånland","Ibestad","Gratangen","Lavangen","Bardu","Salangen","Målselv","Sørreisa","Dyrøy","Tranøy","Torsken","Berg","Lenvik","Balsfjord","Karlsøy","Lyngen","Storfjord","Kåfjord","Skjervøy","Nordreisa","Kvænangen")
finnmark1 <- c("2002","2003","2004","2011","2012","2014","2015","2017","2018","2019","2020","2021","2022","2023","2024","2025","2027","2028","2030")
finnmark2 <- c("Vardø","Vadsø","Hammerfest","Kautokeino","Alta","Loppa","Hasvik","Kvalsund","Måsøy","Nordkapp","Porsanger","Karasjok","Lebesby","Gamvik","Berlevåg","Tana","Nesseby","Båtsfjord","Sør-Varanger")
mapdf <- as.tibble(rbind(cbind(oslo1,oslo2),cbind(ostfold1,ostfold2),cbind(akershus1,akershus2),cbind(hedmark1,hedmark2),cbind(oppland1,oppland2),cbind(buskerud1,buskerud2),cbind(vestfold1,vestfold2),cbind(telemark1,telemark2),cbind(vestagd1,vestagd2),cbind(austagd1,austagd2),cbind(rogaland1,rogaland2),cbind(hordaland1,hordaland2),cbind(sogn1,sogn2),cbind(more1,more2),cbind(sor_trond1,sor_trond2),cbind(nord_trond1,nord_trond2),cbind(nordland1,nordland2),cbind(troms1,troms2),cbind(finnmark1,finnmark2)))
mapdf$oslo1 <- as.numeric(mapdf$oslo1)
names(mapdf) <- c("kommune_nr","kommune")
alle_kommuner <- inner_join(alle_kommuner, mapdf)
alle_kommuner$contact_no <- seq(1:nrow(alle_kommuner)) + 1000000*alle_kommuner$kommune_nr

  temp <- alle_kommuner %>% select(aar,navn,i,f,fylke,tlf1,tlf2,tlf3,company_navn,kommune,kommune_nr,contact_no,category,business,address,note)
  temp <- split(temp,temp$fylke)

  write.xlsx2(temp["Oslo"], paste0("Oslo.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Østfold"], paste0("Østfold.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Akershus"], paste0("Akershus.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Hedmark"], paste0("Hedmark.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Oppland"], paste0("Oppland.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Buskerud"], paste0("Buskerud.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Vestfold"], paste0("Vestfold.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Telemark"], paste0("Telemark.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Aust-Agder"], paste0("Aust-Agder.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Vest-Agder"], paste0("Vest-Agder.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Rogaland"], paste0("Rogaland.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Hordaland"], paste0("Hordaland.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Sogn og Fjordane"], paste0("Sogn_og_Fjordane.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Møre og Romsdal"], paste0("Møre_og_Romsdal.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Sør-Trøndelag"], paste0("Sør-Trøndelag.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Nord-Trøndelag"], paste0("Nord-Trøndelag.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Nordland"], paste0("Nordland.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Troms"], paste0("Troms.xlsx"), col.names=FALSE)
  write.xlsx2(temp["Finnmark"], paste0("Finnmark.xlsx"), col.names=FALSE)


 

