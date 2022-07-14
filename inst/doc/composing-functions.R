## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE, 
  fig.align='center', 
  fig.width = 6,
  fig.height = 4,
  out.width = '600px', 
  out.height = '400px') 
library(ggpackets)

## ----libraries, message = FALSE, warning = FALSE------------------------------
library(ggplot2)

## ----simple_ggpacket----------------------------------------------------------
ggpk_my_template <- ggpacket() + 
  geom_line(size = 1) + 
  geom_point(size = 3)

## ----simple_ggpacket_output---------------------------------------------------
ggplot(Loblolly) + 
  aes(x = age, y = height, color = Seed) + 
  ggpk_my_template() + 
  ggtitle('Growth of Loblolly Pines')

## ----function_ggpacket--------------------------------------------------------
ggpk_my_template <- function(...) {
  ggpacket(...) %+%
    geom_line(size = 1, ...) %+%
    geom_point(size = 3, ...)
}

## ----function_ggpacket_output-------------------------------------------------
ggplot(Loblolly) + 
  aes(x = age, y = height) + 
  ggpk_my_template(aes(color = age), stat = 'summary', fun.data = mean_se, size = 5, alpha = 0.5) + 
  ggtitle('Average Growth of Loblolly Pines')

## ----function_ggpacket_standalone_output--------------------------------------
ggpk_my_template(
  data = Loblolly,
  mapping = aes(x = age, y = height, color = Seed))

## ----granular_ggpacket--------------------------------------------------------
ggpk_my_template <- function(...) {
  ggpacket() %+%
  geom_line(.id = 'line', size = 1, ...) %+% 
  geom_point(.id = 'point', size = 3, ...)
}

## ----granular_ggpacket_output-------------------------------------------------
ggplot(Loblolly) + 
  aes(x = age, y = height, color = Seed) + 
  ggpk_my_template(point.size = 5, line.size = 0.5) + 
  ggtitle('Average Growth of Loblolly Pines')

## ----granular_ggpacket2-------------------------------------------------------
ggpk_my_template <- function(...) {
  ggpacket() %+%
  geom_line(.id = c('all', 'line'), size = 1, ...) %+%
  geom_point(.id = c('all', 'point'), size = 3, ...)
}

## ----granular_ggpacket_output2------------------------------------------------
ggplot(Loblolly) + 
  aes(x = age, y = height) + 
  ggpk_my_template(stat = 'summary', fun.data = mean_se,
    point.size = 5, line.size = 0.5) + 
  ggtitle('Average Growth of Loblolly Pines')

## ----parameters_ggpacket------------------------------------------------------
ggpk_my_template <- function(...) {
  ggpacket() %+%
  geom_line(.id = 'line', size = 3, ...) %+%
  geom_point(.id = 'point', ..., size = 3)
}

## ----parameters_ggpacket_output-----------------------------------------------
ggplot(Loblolly) + 
  aes(x = age, y = height, color = Seed) + 
  ggpk_my_template(line.size = 0.1, point.size = 10) + 
  ggtitle('Average Growth of Loblolly Pines')

