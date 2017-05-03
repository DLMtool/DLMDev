
#
# Functions from the pkgdown package with some nasty hacks to customize the website
#
# Works with pkgdown version 0.1.0.9000 but undoubtedly will break with any new updates


build_siteDLM <- function(pkg = ".",
                          path = "docs",
                          examples = TRUE,
                          run_dont_run = FALSE,
                          mathjax = TRUE,
                          preview = interactive(),
                          seed = 1014,
                          encoding = "UTF-8"
) {
  old <- pkgdown:::set_pkgdown_env("true")
  on.exit(pkgdown:::set_pkgdown_env(old))
  
  pkg <- as_pkgdown(pkg)
  path <- rel_path(path, pkg$path)
  
  init_site(pkg, path)
  
  build_home(pkg, path = path, encoding = encoding)
  
  ### Adrian's dodgy additions ###
  topics <- pkg$topics
  funNames <- topics$name
  classes <- unlist(lapply(funNames, defineCat))
  paths <- unique(classes)
  
  for (X in seq_along(paths)) {
    path2 <- paths[X]
    ind <- which(classes == path2)
    Subpkg <- pkg
    Subpkg$topics <- Subpkg$topics[ind,]
    build_referenceAH(Subpkg,
                      lazy = FALSE,
                      examples = TRUE,
                      run_dont_run = run_dont_run,
                      mathjax = mathjax,
                      seed = seed,
                      path = file.path(path, "reference", path2),
                      depth = 2L,
                      subdir=path2
    )  
  }
  
  build_articles(pkg, path = file.path(path, "articles"), depth = 1L, encoding = encoding)
  build_news(pkg, path = file.path(path, "news"), depth = 1L)
  
  if (preview) {
    pkgdown:::preview_site(path)
  }
  invisible(TRUE)
}


build_referenceAH <- function(pkg = ".",
                              lazy = TRUE,
                              examples = TRUE,
                              run_dont_run = FALSE,
                              mathjax = TRUE,
                              seed = 1014,
                              path = "docs/reference",
                              depth = 1L,
                              subdir=subdir
) {
  old <- pkgdown:::set_pkgdown_env("true")
  on.exit(pkgdown:::set_pkgdown_env(old))
  
  pkg <- as_pkgdown(pkg)
  path <- rel_path(path, pkg$path)
  
  pkgdown:::rule("Building function reference")
  
  if (!is.null(path)) {
    pkgdown:::mkdir(path)
  }
  
  # copy everything from man/figures to docs/reference/figures
  figures_path <- file.path(pkg$path, "man", "figures")
  if (file.exists(figures_path) && !is.null(path)) {
    out_path <- file.path(path, "figures")
    message("Copying man/figures/")
    pkgdown:::mkdir(out_path)
    pkgdown:::copy_dir(figures_path, out_path)
  }
  
  build_reference_indexAH(pkg, path = path, depth = depth, subdir=subdir)
  
  if (examples) {
    devtools::load_all(pkg$path)
    set.seed(seed)
  }
  
  pkg$topics %>%
    purrr::transpose() %>%
    purrr::map(pkgdown:::build_reference_topic, path,
               pkg = pkg,
               lazy = lazy,
               depth = depth,
               examples = examples,
               run_dont_run = run_dont_run,
               mathjax = mathjax
    )
  invisible()
}


build_reference_indexAH <- function(pkg = ".", path = "docs/reference", depth = 1L, subdir=subdir) {
  pkg <- as_pkgdown(pkg)
  path <- rel_path(path, pkg$path)
  
  # Copy icons, if needed
  logo_path <- file.path(pkg$path, "icons")
  if (file.exists(logo_path)) {
    pkgdown:::mkdir(path, "icons")
    pkgdown:::copy_dir(logo_path, file.path(path, "icons"))
  }
  
  render_page(
    pkg, "reference-index",
    data = data_reference_indexAH(pkg, depth = depth, subdir),
    path = pkgdown:::out_path(path, "index.html"),
    depth = depth
  )
}

data_reference_indexAH <- function(pkg = ".", depth = 1L, subdir) {
  pkg <- as_pkgdown(pkg)
  
  meta <- pkg$meta[["reference"]] %||% default_reference_indexAH(pkg, subdir)
  sections <- meta %>%
    purrr::map(pkgdown:::data_reference_index_section, pkg = pkg, depth = depth) %>%
    purrr::compact()
  
  # Cross-reference complete list of topics vs. topics found in index page
  all_topics <- meta %>%
    purrr::map(~ pkgdown:::select_topics(.$contents, pkg$topics)) %>%
    purrr::reduce(union)
  in_index <- seq_along(pkg$topics$name) %in% all_topics
  
  missing <- !in_index & !pkg$topics$internal
  if (any(missing)) {
    warning(
      "Topics missing from index: ",
      paste(pkg$topics$name[missing], collapse = ", "),
      call. =  FALSE,
      immediate. = TRUE
    )
  }
  
  pkgdown:::print_yaml(list(
    pagetitle = gsub("_", " ", subdir), # "Function reference",
    sections = sections
  ))
}

default_reference_indexAH <- function(pkg = ".", subdir) {
  pkg <- as_pkgdown(pkg)
  
  pkgdown:::print_yaml(list(
    list(
      title = gsub("_", " ", subdir),
      desc = NULL,
      contents = paste0('`', pkg$topics$name[!pkg$topics$internal], '`')
    )
  ))
}

