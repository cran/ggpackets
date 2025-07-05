## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  fig.align = "center",
  fig.width = 6,
  fig.height = 4,
  out.width = "600px",
  out.height = "400px"
)
library(ggpackets)

## ----libraries, message = FALSE, warning = FALSE------------------------------
library(ggplot2)

## ----ex1.ggplot, warning = FALSE----------------------------------------------
ggplot(mtcars) +
  aes(x = carb, y = mpg) +
  geom_bar(
    stat = "summary",
    aes(y = mpg),
    fun.data = function(c) c(y = mean(c))
  ) +
  geom_errorbar(
    stat = "summary",
    aes(y = mpg),
    width = 0.2,
    fun.y = mean,
    fun.min = ~mean(.) - sd(.),
    fun.max = ~mean(.) + sd(.)
  ) +
  geom_text(
    stat = "summary",
    vjust = -0.5,
    color = "white",
    fun.data = function(c) c(label = length(c), y = 0)
  )

## ----ex1.ggpackets.ex0--------------------------------------------------------
my_ggpk_layers <- ggpacket() +
  geom_bar(
    stat = "summary",
    fun.data = function(c) c(y = mean(c))
  ) +
  geom_errorbar(
    stat = "summary",
    width = 0.2,
    fun.data = function(c) {
      c(y = mean(c), ymin = mean(c) - sd(c), ymax = mean(c) + sd(c))
    }
  ) +
  geom_text(
    stat = "summary",
    vjust = -0.5,
    color = "white",
    fun.data = function(c) c(label = length(c), y = 0)
  )

## ----warning = FALSE----------------------------------------------------------
ggplot(mtcars) +
  aes(x = carb, y = mpg, fill = as.factor(am)) +
  my_ggpk_layers() +
  facet_grid(. ~ am, scales = "free")

## ----ex1.ggplot.func----------------------------------------------------------
my_plot <- function(data, x, y, fun.data = mean_se) {  # nolint: object_name
  ggplot(data) +
    aes_string(x = x, y = y) +

    geom_bar(
      stat = "summary",
      aes_string(y = y),
      fun.data = fun.data
    ) +

    geom_errorbar(
      stat = "summary",
      aes_string(y = y),
      width = 0.2,
      fun.data = fun.data
    ) +

    geom_text(
      stat = "summary",
      color = "white",
      vjust = -0.5,
      fun.data = function(c) c(label = length(c), y = 0)
    )
}

## ----warning = FALSE----------------------------------------------------------
my_plot(mtcars, "carb", "wt")

## ----ex1.ggpackets2-----------------------------------------------------------
my_ggpk <- function(...) {
  ggpacket(...) %+%

    geom_bar(
      .id = "bar",
      fun.data = mean_se,
      position = position_dodge(width = 1.0),
      ...,
      stat = "summary"
    ) %+%

    geom_errorbar(
      .id = "errorbar",
      fun.data = mean_se,
      position = position_dodge(width = 1.0),
      width = 0.2,
      ...,
      stat = "summary"
    ) %+%

    geom_label(
      .id = "label",
      position = position_dodge(width = 1.0),
      vjust = -0.5, color = "white",
      alpha = 0.3, label.size = NA,
      ...,
      stat = "summary",
      fun.data = function(d) c(label = length(d), y = 0)
    )
}

## ----warning = FALSE----------------------------------------------------------
ggplot(mtcars) +
  aes(x = carb, y = mpg) +
  my_ggpk(fun.data = mean_se, bar.mapping = aes(fill = carb))

## ----ggpackets.ex2, warning = FALSE-------------------------------------------
ggplot(mtcars) +
  aes(x = carb, y = wt, fill = vs) +
  my_ggpk() +
  facet_grid(. ~ vs, scales = "free")

## ----ggpackets.ex3, warning = FALSE-------------------------------------------
my_ggpk2 <- ggpacket() +
  geom_ribbon(stat = "summary", fun.data = mean_se, alpha = 0.2) +
  geom_line(stat = "summary", fun.data = mean_se, alpha = 0.3, linewidth = 2)

ggplot(mtcars) +
  aes(x = carb, y = wt) +
  my_ggpk() +
  my_ggpk2

## ----ggpackets.ex4------------------------------------------------------------
ggplot(mtcars) +
  aes(x = carb, y = wt, fill = carb) +
  my_ggpk() +
  ggtitle("A beautiful ggpackets plot!") +
  theme_light()

