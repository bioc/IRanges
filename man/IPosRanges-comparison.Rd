\name{IPosRanges-comparison}

\alias{IPosRanges-comparison}

\alias{pcompare}
\alias{pcompare,IPosRanges,IPosRanges-method}
\alias{rangeComparisonCodeToLetter}

\alias{match,IPosRanges,IPosRanges-method}
\alias{selfmatch,IPosRanges-method}

\alias{is.unsorted,IPosRanges-method}
\alias{order,IPosRanges-method}


\title{Comparing and ordering ranges}

\description{
  Methods for comparing and/or ordering the ranges in \link{IPosRanges}
  derivatives (e.g. \link{IRanges}, \link{IPos}, or \link{NCList} objects).
}

\usage{
## match() & selfmatch()
## ---------------------

\S4method{match}{IPosRanges,IPosRanges}(x, table, nomatch=NA_integer_, incomparables=NULL,
      method=c("auto", "quick", "hash"))

\S4method{selfmatch}{IPosRanges}(x, method=c("auto", "quick", "hash"))

## order() and related methods
## ----------------------------

\S4method{is.unsorted}{IPosRanges}(x, na.rm=FALSE, strictly=FALSE)

\S4method{order}{IPosRanges}(..., na.last=TRUE, decreasing=FALSE,
           method=c("auto", "shell", "radix"))

## Generalized parallel comparison of 2 IPosRanges derivatives
## -----------------------------------------------------------

\S4method{pcompare}{IPosRanges,IPosRanges}(x, y)

rangeComparisonCodeToLetter(code)
}

\arguments{
  \item{x, table, y}{
    \link{IPosRanges} derivatives e.g. \link{IRanges}, \link{IPos}, or
    \link{NCList} objects.
  }
  \item{nomatch}{
    The value to be returned in the case when no match is found.
    It is coerced to an \code{integer}.
  }
  \item{incomparables}{
    Not supported.
  }
  \item{method}{
    For \code{match} and \code{selfmatch}: Use a Quicksort-based
    (\code{method="quick"}) or a hash-based (\code{method="hash"}) algorithm.
    The latter tends to give better performance, except maybe for some
    pathological input that we've not encountered so far.
    When \code{method="auto"} is specified, the most efficient algorithm will
    be used, that is, the hash-based algorithm if \code{length(x) <= 2^29},
    otherwise the Quicksort-based algorithm.

    For \code{order}: The \code{method} argument is ignored.
  }
  \item{na.rm}{
    Ignored.
  }
  \item{strictly}{
    Logical indicating if the check should be for \emph{strictly} increasing
    values.
  }
  \item{...}{
    One or more \link{IPosRanges} derivatives. The 2nd and following objects
    are used to break ties.
  }
  \item{na.last}{
    Ignored.
  }
  \item{decreasing}{
    \code{TRUE} or \code{FALSE}.
  }
  \item{code}{
    A vector of codes as returned by \code{pcompare}.
  }
}

\details{
  Two ranges of an \link{IPosRanges} derivative are considered equal iff
  they share the same start and width.
  \code{duplicated()} and \code{unique()} on an \link{IPosRanges}
  derivative are conforming to this.

  Note that with this definition, 2 empty ranges are generally
  not equal (they need to share the same start to be considered equal).
  This means that, when it comes to comparing ranges, an empty range is
  interpreted as a position between its end and start. For example, a
  typical usecase is comparison of insertion points defined along a string
  (like a DNA sequence) and represented as empty ranges.

  The "natural order" for the elements of an \link{IPosRanges}
  derivative is to order them (a) first by start and (b) then by width.
  This way, the space of integer ranges is totally ordered.

  \code{pcompare()}, \code{==}, \code{!=}, \code{<=}, \code{>=}, \code{<}
  and \code{>} on \link{IPosRanges} derivatives behave accordingly to
  this "natural order".

  \code{is.unsorted()}, \code{order()}, \code{sort()}, \code{rank()} on
  \link{IPosRanges} derivatives also behave accordingly to this
  "natural order".

  Finally, note that some \emph{inter range transformations} like
  \code{\link{reduce}} or \code{\link{disjoin}} also use this "natural order"
  implicitly when operating on \link{IPosRanges} derivatives.

  \describe{
    \item{\code{pcompare(x, y)}:}{
      Performs element-wise (aka "parallel") comparison of 2
      \link{IPosRanges} objects of \code{x} and \code{y}, that is,
      returns an integer vector where the i-th element is a code describing
      how \code{x[i]} is qualitatively positioned with respect to \code{y[i]}.

      Here is a summary of the 13 predefined codes (and their letter
      equivalents) and their meanings:
      \preformatted{
      -6 a: x[i]: .oooo.......         6 m: x[i]: .......oooo.
            y[i]: .......oooo.              y[i]: .oooo.......

      -5 b: x[i]: ..oooo......         5 l: x[i]: ......oooo..
            y[i]: ......oooo..              y[i]: ..oooo......

      -4 c: x[i]: ...oooo.....         4 k: x[i]: .....oooo...
            y[i]: .....oooo...              y[i]: ...oooo.....

      -3 d: x[i]: ...oooooo...         3 j: x[i]: .....oooo...
            y[i]: .....oooo...              y[i]: ...oooooo...

      -2 e: x[i]: ..oooooooo..         2 i: x[i]: ....oooo....
            y[i]: ....oooo....              y[i]: ..oooooooo..

      -1 f: x[i]: ...oooo.....         1 h: x[i]: ...oooooo...
            y[i]: ...oooooo...              y[i]: ...oooo.....

                      0 g: x[i]: ...oooooo...
                           y[i]: ...oooooo...
      }

      Note that this way of comparing ranges is a refinement over the
      standard ranges comparison defined by the \code{==}, \code{!=},
      \code{<=}, \code{>=}, \code{<} and \code{>} operators. In particular
      a code that is \code{< 0}, \code{= 0}, or \code{> 0}, corresponds to
      \code{x[i] < y[i]}, \code{x[i] == y[i]}, or \code{x[i] > y[i]},
      respectively.

      The \code{pcompare} method for \link{IPosRanges} derivatives is
      guaranteed to return predefined codes only but methods for other
      objects (e.g. for \link[GenomicRanges]{GenomicRanges} objects) can
      return non-predefined codes. Like for the predefined codes, the sign
      of any non-predefined code must tell whether \code{x[i]} is less than,
      or greater than \code{y[i]}.
    }
    \item{\code{rangeComparisonCodeToLetter(x)}:}{
      Translate the codes returned by \code{pcompare}. The 13 predefined
      codes are translated as follow: -6 -> a; -5 -> b; -4 -> c; -3 -> d;
      -2 -> e; -1 -> f; 0 -> g; 1 -> h; 2 -> i; 3 -> j; 4 -> k; 5-> l; 6 -> m.
      Any non-predefined code is translated to X.
      The translated codes are returned in a factor with 14 levels:
      a, b, ..., l, m, X.
    }
    \item{\code{match(x, table, nomatch=NA_integer_, method=c("auto", "quick", "hash"))}:}{
      Returns an integer vector of the length of \code{x},
      containing the index of the first matching range in \code{table}
      (or \code{nomatch} if there is no matching range) for each range
      in \code{x}.
    }
    \item{\code{selfmatch(x, method=c("auto", "quick", "hash"))}:}{
      Equivalent to, but more efficient than,
      \code{match(x, x, method=method)}.
    }
    \item{\code{duplicated(x, fromLast=FALSE, method=c("auto", "quick", "hash"))}:}{
      Determines which elements of \code{x} are equal to elements
      with smaller subscripts, and returns a logical vector indicating
      which elements are duplicates. \code{duplicated(x)} is equivalent to,
      but more efficient than, \code{duplicated(as.data.frame(x))} on an
      \link{IPosRanges} derivative.
      See \code{\link[base]{duplicated}} in the \pkg{base} package for more
      details.
    }
    \item{\code{unique(x, fromLast=FALSE, method=c("auto", "quick", "hash"))}:}{
      Removes duplicate ranges from \code{x}. \code{unique(x)} is equivalent
      to, but more efficient than, \code{unique(as.data.frame(x))} on an
      \link{IPosRanges} derivative.
      See \code{\link[base]{unique}} in the \pkg{base} package for more
      details.
    }
    \item{\code{x \%in\% table}:}{
      A shortcut for finding the ranges in \code{x} that match any of
      the ranges in \code{table}. Returns a logical vector of length
      equal to the number of ranges in \code{x}.
    }
    \item{\code{findMatches(x, table, method=c("auto", "quick", "hash"))}:}{
      An enhanced version of \code{match} that returns all the matches
      in a \link{Hits} object.
    }
    \item{\code{countMatches(x, table, method=c("auto", "quick", "hash"))}:}{
      Returns an integer vector of the length of \code{x} containing the
      number of matches in \code{table} for each element in \code{x}.
    }
    \item{\code{order(...)}:}{
      Returns a permutation which rearranges its first argument (an
      \link{IPosRanges} derivative) into ascending order, breaking ties
      by further arguments (also \link{IPosRanges} derivatives).
    }
    \item{\code{sort(x)}:}{
      Sorts \code{x}.
      See \code{\link[base]{sort}} in the \pkg{base} package for more details.
    }
    \item{\code{rank(x, na.last=TRUE, ties.method=c("average", "first", "random", "max", "min"))}:}{
      Returns the sample ranks of the ranges in \code{x}.
      See \code{\link[base]{rank}} in the \pkg{base} package for more details.
    }
  }
}

\author{Hervé Pagès}

\seealso{
  \itemize{
    \item The \link{IPosRanges} class.

    \item \link[S4Vectors]{Vector-comparison} in the \pkg{S4Vectors}
          package for general information about comparing, ordering, and
          tabulating vector-like objects.

    \item \link[GenomicRanges]{GenomicRanges-comparison} in the
          \pkg{GenomicRanges} package for comparing and ordering genomic
          ranges.

    \item \code{\link{findOverlaps}} for finding overlapping ranges.

    \item \link{intra-range-methods} and \link{inter-range-methods}
          for \emph{intra range} and \emph{inter range} transformations.

    \item \link{setops-methods} for set operations on \link{IRanges}
          objects.
  }
}

\examples{
## ---------------------------------------------------------------------
## A. ELEMENT-WISE (AKA "PARALLEL") COMPARISON OF 2 IPosRanges
##    DERIVATIVES
## ---------------------------------------------------------------------
x0 <- IRanges(1:11, width=4)
x0
y0 <- IRanges(6, 9)
pcompare(x0, y0)
pcompare(IRanges(4:6, width=6), y0)
pcompare(IRanges(6:8, width=2), y0)
pcompare(x0, y0) < 0   # equivalent to 'x0 < y0'
pcompare(x0, y0) == 0  # equivalent to 'x0 == y0'
pcompare(x0, y0) > 0   # equivalent to 'x0 > y0'

rangeComparisonCodeToLetter(-10:10)
rangeComparisonCodeToLetter(pcompare(x0, y0))

## Handling of zero-width ranges (a.k.a. empty ranges):
x1 <- IRanges(11:17, width=0)
x1
pcompare(x1, x1[4])
pcompare(x1, IRanges(12, 15))

## Note that x1[2] and x1[6] are empty ranges on the edge of non-empty
## range IRanges(12, 15). Even though -1 and 3 could also be considered
## valid codes for describing these configurations, pcompare()
## considers x1[2] and x1[6] to be *adjacent* to IRanges(12, 15), and
## thus returns codes -5 and 5:
pcompare(x1[2], IRanges(12, 15))  # -5
pcompare(x1[6], IRanges(12, 15))  #  5

x2 <- IRanges(start=c(20L, 8L, 20L, 22L, 25L, 20L, 22L, 22L),
              width=c( 4L, 0L, 11L,  5L,  0L,  9L,  5L,  0L))
x2

which(width(x2) == 0)  # 3 empty ranges
x2[2] == x2[2]  # TRUE
x2[2] == x2[5]  # FALSE
x2 == x2[4]
x2 >= x2[3]

## ---------------------------------------------------------------------
## B. match(), selfmatch(), %in%, duplicated(), unique()
## ---------------------------------------------------------------------
table <- x2[c(2:4, 7:8)]
match(x2, table)

x2 \%in\% table

duplicated(x2)
unique(x2)

## ---------------------------------------------------------------------
## C. findMatches(), countMatches()
## ---------------------------------------------------------------------
findMatches(x2, table)
countMatches(x2, table)

x2_levels <- unique(x2)
countMatches(x2_levels, x2)

## ---------------------------------------------------------------------
## D. order() AND RELATED METHODS
## ---------------------------------------------------------------------
is.unsorted(x2)
order(x2)
sort(x2)
rank(x2, ties.method="first")
}

\keyword{methods}
