# Run this in R and send me ALL the output


# base_name <- 'report_AB2_2024'      # Brad's version
base_name <- 'report_JMS4_2025'    # Lilia's version

options(tinytex.verbose = TRUE)

# 1. Check TinyTeX installation
message("--- TinyTeX info ---")
message("TinyTeX installed: ", tinytex::is_tinytex())
message("pdflatex path: ", Sys.which("pdflatex"))
message("TinyTeX root: ", tinytex::tinytex_root())

# 2. Try compiling the .tex file that was left behind
tex_file <- file.path(tempdir(), paste0(base_name, ".tex"))
if (file.exists(tex_file)) {
   message("--- Compiling leftover .tex file ---")
   tryCatch(
      tinytex::pdflatex(tex_file),
      error = function(e) message("pdflatex error: ", e$message)
   )
} else {
   message("No leftover .tex file found. Re-rendering...")
   # Re-render to generate it, then check the log
   tryCatch(
      rmarkdown::render(
         input = system.file('rmd/seasonal_report.rmd', package = 'BuzzardsBay', mustWork = TRUE),
         output_file = file.path(tempdir(), paste0(base_name, ".pdf")),
         params = list(title = "test", date = "test",
                       stat = NULL, value = NULL),
         quiet = FALSE
      ),
      error = function(e) message("Render error: ", e$message)
   )
   tex_file <- file.path(tempdir(), base_name(base_name, ".tex"))
}

# 3. Grab the .log file — this is what actually matters
log_file <- sub("\\.tex$", ".log", tex_file)
if (file.exists(log_file)) {
   message("--- LaTeX log (last 80 lines) ---")
   log_lines <- readLines(log_file)
   cat(tail(log_lines, 80), sep = "\n")
} else {
   message("No .log file found at: ", log_file)
}

# 4. Check what LaTeX packages are installed
message("--- Installed LaTeX packages (first 30) ---")
pkgs <- tinytex::tl_pkgs()
message(length(pkgs), " packages installed")
cat(head(pkgs, 30), sep = "\n")
