# ggpackets v0.2.2

* For compatibility with `ggplot2` `v4.0.0`, handle cases where passing of
  arguments produces base R "unused argument" errors, suppressing errors for
  `ggpackets`-style propagation of ellipsis arguments.

# ggpackets v0.2.1

* handle `+.gg` using recommended `ggplot2::ggplot_add` instead of intercepting
  calls (#24, @dgkf)

* remove `crayon` package dependency, only used for console output of missing
  aesthetics

# ggpackets v0.2.0

* initial release on CRAN
