#' Extract date of birth from UIN.
#'
#' \code{dob_from_uin} Unique identifiers (UINs) in the MSNZ study have the date
#' of birth embedded. This function extracts and returns it.
#'
#' @param uin A character variable of the format \code{03121999MAB} i.e. DOB
#' followed by M/F followed by two initials.
#'
#' @return \code{'1999-12-03'} The DOB in YYYY-MM-DD format.
#'
#' @export
dob_from_uin <- function(uin) {
  dob = substr(uin, start = 1, stop = 8) # e.g. 01021950

  # convert to a proper date object using lubridate to
  # allow for subsequent calculations:
  dob = lubridate::dmy(dob)

  return(dob)
}

#' Extract sex from UIN.
#'
#' \code{sex_from_uin} Unique identifiers (UINs) in the MSNZ study have the sex
#' embedded. This function extracts and returns it.
#'
#' @param uin A character variable of the format \code{03121999MAB} i.e. DOB
#' followed by M/F followed by two initials.
#'
#' @return \code{'Female', 'Male'} or \code{'F', 'M'}. If
#' \code{return_as_factor} is \code{TRUE}, then a factor variable is returned,
#' with labels set as \code{'Female', 'Male'}, and \code{Female} as the
#' reference level. Otherwise, returns the raw values as \code{'F', 'M'}.
#'
#' @export
sex_from_uin <- function(uin, return_as_factor = TRUE) {
  sex = substr(uin, start = 9, stop = 9) # i.e. F or M

  if (return_as_factor){
  # convert to a factor with F as the reference level and nice labels:
  sex = factor(sex, levels = c('F', 'M'), labels = c('Female', 'Male'))
  }

  return(sex)
}

#' Extract initials from UIN.
#'
#' \code{dob_from_uin} Unique identifiers (UINs) in the MSNZ study have the sex
#' embedded. This function extracts and returns it.
#'
#' @param uin A character variable of the format \code{03121999MAB} i.e. DOB
#' followed by M/F followed by two initials.
#'
#' @return \code{'AB'}.
#'
#' @export
initials_from_uin <- function(uin) {

  return(substr(uin, start = 10, stop = 11)) # e.g. AB

}
