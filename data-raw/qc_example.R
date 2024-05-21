
# Make `qc_example.csv`  and
# This is an auto QC'd CSV file output by `qc_deployment()`
# Running the code here updates the example QC'd data based on the
# example calibrated data and the current workflow.

# Create empty directory to work in
td <- file.path(tempdir(), "prepare_bb")
if (file.exists(td))
  unlink(td, recursive = TRUE)
dir.create(td)

# Setup the example (calibrated) data there.
paths <- setup_example_dir(td)

# Run auto QC
a <- qc_deployment(dir = paths$deployment)

# Copy the result to the package example data folder
csv_path <- file.path(paths$deployment,
                      paste0("Auto_QC_", a$md$site, "_", a$md$deployment_date,
                             ".csv"))

file.copy(csv_path, "./inst/extdata/qc_example.csv")

# Copy the result to the package example data folder
yml_path <- file.path(paths$deployment,
                      paste0("Metadata_", a$md$site, "_", a$md$deployment_date,
                             ".yml"))

file.copy(yml_path, "./inst/extdata/qc_example.yml")
