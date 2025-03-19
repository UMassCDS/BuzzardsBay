# aggreg works

    Code
      aggreg(x$x1, by = x$group, FUN = sum)
    Output
      [1] 21 15 55 29 34

---

    Code
      aggreg(x$x1, by = x$group, FUN = sum, drop_by = FALSE)
    Output
        Group.1  x
      1       1 21
      2       2 15
      3       3 55
      4       4 29
      5       5 34

---

    Code
      aggreg(x$x2, by = x$group, FUN = sum, nomiss = 0.5)
    Output
      [1] NA NA 55 15 34

---

    Code
      aggreg(x$x2, by = x$group, FUN = sum, nomiss = 0.6)
    Output
      [1] NA NA 55 NA 34

