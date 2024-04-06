# %!% works

    Code
      stop("ouch") %!% "bam"
    Condition
      Error:
      ! bam
      Caused by error in `stop()`:
      ! ouch

---

    Code
      g()
    Condition
      Error in `g()`:
      ! bam `boom()`
      Caused by error in `f()`:
      ! ouch

---

    Code
      h()
    Condition
      Error in `foo()`:
      ! bam `boom()`
      Caused by error in `f()`:
      ! ouch

