
# Test read of excel file

dir <- "C:/Users/plunkett/Downloads/"
xf <- file.path(dir, "Mx8011 2024-10-26 10_53_16 EDT (Data EDT)_example.xlsx")
stopifnot(file.exists(xf))

library(readxl)

# Note each row in the details tab has one non-empty cell in one of the
# first four columns.
# Here we:
# * reformat the data as text with indentations indicating column
#   adding two leading spaces for every empty column before each item
# * insert a dash before everything that is indented
#     to indicate list membership,
# * delete all but the first colon on every line as colons separate names and
#     values but leave colons if bounded by digits as in times (12:00:00)
# * Add a trailing colon on lines that are not fully indented
# * Add null after a colon if the next line doesn't have additional indentation
#  * Delete all but the last colon on every line.
# And convert to a list with read_yaml()


d <- readxl::read_excel(xf, sheet = 3, col_types = "text", col_names = FALSE)
d2 <- lapply(d, function(x) paste0(x, ":")) |> as.data.frame()

restore_na <- function(x) {
  x[grepl("^NA:$", x)] <- NA
  x
}

d3 <- lapply(d2, restore_na)  |> as.data.frame()

indent_na <- function(x) {
  x[is.na(x)] <- "  "
  x
}

d4 <- lapply(d3, indent_na) |> as.data.frame()

# drop trailing ":" in last column
last <- ncol(d4)
d4[, last] <- gsub(":$", "", d4[, last])




text <- apply(d4, 1, function(x) paste(x, collapse = ""))
text <- gsub("\n", " ", text) # eliminate internal carriage returns


# Dropping first line ("Details") because it breaks list heirarchy
text <- text[-1]

# Drop trailing white space
text <- gsub("[[:blank:]]*$", "", text)


### Indentation problems
# If a line ends in a colon than the next line should be indented more
###
indentation <- gsub("^( *)[^ ].*$", "\\1", text, perl = TRUE) |> nchar()
next_line_indented <- indentation < c(indentation[-1], NA)
next_line_indented[is.na(next_line_indented)] <- FALSE
ends_in_colon <- grepl(":[[:blank:]]*$", text)
indentation_problems <-   ends_in_colon & !next_line_indented

# Show problems in context
i <- which(indentation_problems)
if (length(i > 0)) {
  context <- unique(c(i - 1, i, 9 + 1)) |> sort()
  text[context] |> cat(sep = "\n")
}

# Resolve indentation problems by adding "null" to end of line.
text[indentation_problems] <- paste0(text[indentation_problems], "NA")

# Add leading - for all indented items
text <- gsub("(^[[:blank:]]{6})", "\\1- ", text)

### Double colon problems
# A line should only have one colon
# Drop first colon if there are two
while (any(grepl(":.*:", text))) {
  text <- gsub(":(.*:)", "\\1", text, perl = TRUE)
}

# Insert spaces after all :
text <- gsub(":[[:blank:]]*", ": ", text)

l <- yaml::read_yaml(text = text)

l <- simplify_list(l)

l <- clean_names(l)
