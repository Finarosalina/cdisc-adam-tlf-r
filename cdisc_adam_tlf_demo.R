## ------------------------------------------------------------------------------------------------
library(admiral)
library(pharmaversesdtm)
library(dplyr)
library(tidyr)
library(gtsummary)

dm <- convert_blanks_to_na(pharmaversesdtm::dm)
ex <- convert_blanks_to_na(pharmaversesdtm::ex)
ae <- convert_blanks_to_na(pharmaversesdtm::ae)


## ------------------------------------------------------------------------------------------------
ex_ext <- ex %>%
  derive_vars_dtm(dtc = EXSTDTC, new_vars_prefix = "EXST")

adsl <- dm %>%
  select(-DOMAIN) %>%
  mutate(TRT01P = ARM, TRT01A = ACTARM) %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add  = (EXDOSE > 0 | (EXDOSE == 0 & grepl("PLACEBO", EXTRT))) & !is.na(EXSTDTM),
    new_vars    = exprs(TRTSDTM = EXSTDTM),
    order       = exprs(EXSTDTM, EXSEQ),
    mode        = "first",
    by_vars     = exprs(STUDYID, USUBJID)
  ) %>%
  derive_vars_dtm_to_dt(source_vars = exprs(TRTSDTM)) %>%
  mutate(SAFFL = if_else(!is.na(TRTSDT), "Y", "N"))

count(adsl, TRT01A, SAFFL)


## ------------------------------------------------------------------------------------------------
adae <- ae %>%
  derive_vars_merged(
    dataset_add = adsl,
    new_vars    = exprs(TRTSDT, TRT01A, SAFFL),
    by_vars     = exprs(STUDYID, USUBJID)
  ) %>%
  derive_vars_dt(dtc = AESTDTC, new_vars_prefix = "AST") %>%
  mutate(TRTEMFL = if_else(!is.na(ASTDT) & ASTDT >= TRTSDT, "Y", NA_character_))


## ------------------------------------------------------------------------------------------------
# One row per subject in ADSL
stopifnot(!any(duplicated(adsl$USUBJID)))

# Every ADAE subject exists in ADSL
stopifnot(all(adae$USUBJID %in% adsl$USUBJID))

# Subjects without a treatment start date are not in the safety population
stopifnot(all(adsl$SAFFL[is.na(adsl$TRTSDT)] == "N"))


## ------------------------------------------------------------------------------------------------
arm_levels <- c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
adsl_saf <- adsl %>%
  filter(SAFFL == "Y") %>%
  mutate(TRT01A = factor(TRT01A, levels = arm_levels))


## ------------------------------------------------------------------------------------------------
adsl_saf %>%
  select(TRT01A, AGE, SEX, RACE) %>%
  tbl_summary(
    by = TRT01A,
    label = list(AGE ~ "Age (years)", SEX ~ "Sex", RACE ~ "Race"),
    type = list(AGE ~ "continuous2"),
    statistic = list(AGE ~ c("{mean} ({sd})", "{median} ({p25}, {p75})", "{min}, {max}")),
    digits = list(AGE ~ c(1, 1, 0, 0, 0, 0, 0))
  ) %>%
  add_overall()


## ------------------------------------------------------------------------------------------------
n_arm <- count(adsl_saf, TRT01A, name = "N")

adae %>%
  filter(SAFFL == "Y", TRTEMFL == "Y") %>%
  mutate(TRT01A = factor(TRT01A, levels = arm_levels)) %>%
  distinct(USUBJID, TRT01A, AEBODSYS) %>%
  count(AEBODSYS, TRT01A) %>%
  left_join(n_arm, by = "TRT01A") %>%
  mutate(value = sprintf("%d (%.1f%%)", n, 100 * n / N)) %>%
  select(AEBODSYS, TRT01A, value) %>%
  pivot_wider(names_from = TRT01A, values_from = value, values_fill = "0") %>%
  arrange(AEBODSYS) %>%
  knitr::kable(col.names = c("System Organ Class", arm_levels))


## ------------------------------------------------------------------------------------------------
sessionInfo()

