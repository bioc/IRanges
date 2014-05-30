### =========================================================================
### IMPORTANT NOTE - 4/29/2014: Most of the stuff that used to be in that
### file is now in S4Vectors/R/Vector-class.R. The stuff that does not belong
### to S4Vectors/R/Vector-class.R was temporarily left here but will need to
### find a new home (in S4Vectors or in IRanges).
###


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Coercion
###

setAs("Hits", "DataFrame", function(from) {
  DataFrame(as.matrix(from),
            if (!is.null(mcols(from))) mcols(from)
            else new("DataFrame", nrows = length(from)))
})

### S3/S4 combo for as.data.frame.Hits
as.data.frame.Hits <- function(x, row.names=NULL, optional=FALSE, ...)
{
    if (!(is.null(row.names) || is.character(row.names)))
        stop("'row.names' must be NULL or a character vector")
    if (!identical(optional, FALSE) || length(list(...)))
        warning("'optional' and arguments in '...' are ignored")
    as.data.frame(as(x, "DataFrame"), row.names = row.names)
}
setMethod("as.data.frame", "Hits", as.data.frame.Hits)

### Turns Hits object 'from' into an IntegerList object with one list element
### per element in the original query.
.from_Hits_to_IntegerList <- function(from)
{
    ans_partitioning <- PartitioningByEnd(queryHits(from),
                                          NG=queryLength(from))
    relist(subjectHits(from), ans_partitioning)
}
setAs("Hits", "IntegerList", .from_Hits_to_IntegerList)
setAs("Hits", "List", .from_Hits_to_IntegerList)

### S3/S4 combo for as.list.Hits
.as.list.Hits <- function(x) as.list(.from_Hits_to_IntegerList(x))
as.list.Hits <- function(x, ...) .as.list.Hits(x, ...)
setMethod("as.list", "Hits", .as.list.Hits)

setAs("Hits", "list", function(from) as.list(from))


### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Displaying
###

setMethod("show", "Hits", function(object) {
  cat("Hits of length ", length(object), "\n", sep = "")
  cat("queryLength: ", queryLength(object), "\n", sep = "")
  cat("subjectLength: ", subjectLength(object), "\n", sep = "")
  df_show <- capture.output(show(as(object, "DataFrame")))
  cat(paste(tail(df_show, -1), "\n"))
})
