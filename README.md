# CDISC SDTM → ADaM → TLFs in R with pharmaverse

CDISC clinical reporting workflow in R with pharmaverse: SDTM → ADaM (ADSL, ADAE) → safety TLFs. Derives treatment start, safety population and treatment-emergent AE flags with admiral, includes data quality checks, and produces demographic and adverse event tables with gtsummary in a reproducible Quarto report. Simulated CDISC pilot data.


Reproducible clinical reporting workflow in R, following the standard used in regulatory submissions, built with the open-source [pharmaverse](https://pharmaverse.org) ecosystem instead of SAS.

```
SDTM (collected data)  →  ADaM (analysis datasets)  →  TLFs (tables, listings, figures)
   DM, EX, AE               ADSL, ADAE                  Demographics, AE by SOC
```

## What it does

| Step | Output | Key derivations |
|---|---|---|
| ADaM | **ADSL** (one row per subject) | Planned/actual treatment, treatment start date from first valid dose, safety population flag (`SAFFL`) |
| ADaM | **ADAE** (one row per adverse event) | Analysis start date, treatment-emergent flag (`TRTEMFL`) |
| QC | Data checks | Unique subjects, ADAE–ADSL consistency, population flag logic |
| TLF | **Table 14.1.1** Demographics – Safety Population | Mean (SD), median (Q1, Q3), min–max; n (%) by arm |
| TLF | **Table 14.3.1** Subjects with TEAEs by System Organ Class | Subjects counted once per SOC, n (%) by arm |

## Data

Simulated CDISC pilot study (Xanomeline vs placebo in Alzheimer's disease) loaded from the `pharmaversesdtm` package. No real patient data are used or stored in this repository.

## How to run

```r
install.packages(c("admiral", "pharmaversesdtm", "dplyr", "tidyr", "gtsummary"))
```

Open `cdisc_adam_tlf_demo.qmd` in RStudio and click **Render**. The rendered report is `cdisc_adam_tlf_demo.html`.

## Tools

R · admiral · pharmaversesdtm · dplyr · tidyr · gtsummary · Quarto

## Author

Maria Pais Fajin · [LinkedIn](https://www.linkedin.com/in/maria-pais-fajin) · [GitHub](https://github.com/Finarosalina)

Co-Authored-By: Claude <noreply@anthropic.com>
