# CDISC SDTM → ADaM → TLFs in R with pharmaverse

Reproducible clinical reporting workflow in R, following the standard used in regulatory submissions, built with the open-source [pharmaverse](https://pharmaverse.org) ecosystem instead of SAS.

```
SDTM (collected data)  →  ADaM (analysis datasets)  →  QC  →  TLFs (tables, listings, figures)
   DM, EX, AE               ADSL, ADAE                         Demographics, AE by SOC
```

## What it does

| Step | Output | Key derivations |
|---|---|---|
| ADaM | **ADSL** (one row per subject) | Planned/actual treatment, treatment start date from first valid dose, safety population flag (`SAFFL`) |
| ADaM | **ADAE** (one row per adverse event) | Analysis start date, treatment-emergent flag (`TRTEMFL`) |
| QC | Data checks | Unique subjects, ADAE–ADSL consistency, population flag logic |
| TLF | **Table 14.1.1** Demographics – Safety Population | Mean (SD), median (Q1, Q3), min–max; n (%) by arm |
| TLF | **Table 14.3.1** Subjects with TEAEs by System Organ Class | Subjects counted once per SOC, n (%) by arm |
| TLF | **Figure 14.3.1** Most frequent TEAEs by System Organ Class | Grouped bars by arm, SOCs reported in ≥ 15% of subjects in any arm |

## Key results

- 306 subjects in the source data; 254 received at least one dose (safety population).
- Skin and nervous system adverse events show a dose-dependent pattern (placebo < low dose < high dose).
- Skin and administration-site events are consistent with the transdermal patch route. Results are descriptive only.

## Data

Simulated CDISC pilot study (Xanomeline vs placebo in Alzheimer's disease) loaded from the `pharmaversesdtm` package. No real patient data are used or stored in this repository.

## Files

| File | Content |
|---|---|
| `cdisc_adam_tlf_demo.qmd` | Quarto source of the report |
| `cdisc_adam_tlf_demo.html` | Rendered report |
| `cdisc_adam_tlf_demo.R` | R code extracted from the report |

## How to run

```r
install.packages(c("admiral", "pharmaversesdtm", "dplyr", "tidyr", "gtsummary", "ggplot2"))
```

Open `cdisc_adam_tlf_demo.qmd` in RStudio and click **Render**, or run `cdisc_adam_tlf_demo.R` directly.

## Tools

R · admiral · pharmaversesdtm · dplyr · tidyr · gtsummary · ggplot2 · Quarto

## AI-assisted development

Developed with Claude (Anthropic) as an AI coding assistant for code drafting and documentation. I ran, debugged and validated all code in my own environment, reviewed each derivation against CDISC ADaM conventions, and am responsible for the final content.

## Author

Maria Pais Fajin · [LinkedIn](https://www

Co-developed with Claude (Anthropic), AI coding assistant..linkedin.com/in/maria-pais-fajin) · [GitHub](https://github.com/Finarosalina)
