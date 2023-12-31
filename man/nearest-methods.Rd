\name{nearest-methods}

\alias{nearest-methods}

\alias{class:IntegerRanges_OR_missing}
\alias{IntegerRanges_OR_missing-class}
\alias{IntegerRanges_OR_missing}

\alias{nearest}
\alias{precede}
\alias{follow}
\alias{distance}
\alias{distanceToNearest}
\alias{selectNearest}
\alias{nearest,IntegerRanges,IntegerRanges_OR_missing-method}
\alias{precede,IntegerRanges,IntegerRanges_OR_missing-method}
\alias{follow,IntegerRanges,IntegerRanges_OR_missing-method}
\alias{distance,IntegerRanges,IntegerRanges-method}
\alias{distance,Pairs,missing-method}
\alias{distanceToNearest,IntegerRanges,IntegerRanges_OR_missing-method}

\title{Finding the nearest range/position neighbor}

\description{
  The \code{nearest()}, \code{precede()}, \code{follow()}, \code{distance()}
  and \code{distanceToNearest()} methods for \link{IntegerRanges}
  derivatives (e.g. \link{IRanges} objects).
}

\usage{
\S4method{nearest}{IntegerRanges,IntegerRanges_OR_missing}(x, subject, select=c("arbitrary", "all"))

\S4method{precede}{IntegerRanges,IntegerRanges_OR_missing}(x, subject, select=c("first", "all"))

\S4method{follow}{IntegerRanges,IntegerRanges_OR_missing}(x, subject, select=c("last", "all"))

\S4method{distance}{IntegerRanges,IntegerRanges}(x, y)
\S4method{distance}{Pairs,missing}(x, y)

\S4method{distanceToNearest}{IntegerRanges,IntegerRanges_OR_missing}(x, subject, select=c("arbitrary", "all"))
}

\arguments{
  \item{x}{The query \link{IntegerRanges} derivative, or (for
    \code{distance()}) a \link[S4Vectors]{Pairs} object containing
    both the query (first) and subject (second).
  }
  \item{subject}{The subject \link{IntegerRanges} object, within which
    the nearest neighbors are found. Can be missing, in which case
    \code{x} is also the subject.
  }
  \item{select}{Logic for handling ties. By default, all the methods
    select a single interval (arbitrary for \code{nearest},the first
    by order in \code{subject} for \code{precede}, and the last for
    \code{follow}). To get all matchings, as a \link[S4Vectors]{Hits}
    object, use \code{"all"}.
  }
  \item{y}{For the \code{distance} method, a \link{IntegerRanges} derivative.
    Cannot be missing. If \code{x} and \code{y} are not the same
    length, the shortest will be recycled to match the length of the
    longest.
  }
  \item{hits}{The hits between \code{x} and \code{subject}}
  \item{...}{Additional arguments for methods}
}

\details{
  \itemize{
    \item{\code{nearest(x, subject, select=c("arbitrary", "all"))}:}{
      The conventional nearest neighbor finder. Returns an integer vector
      containing the index of the nearest neighbor range in \code{subject}
      for each range in \code{x}. If there is no nearest neighbor
      (if \code{subject} is empty), NA's are returned.

      Here is roughly how it proceeds, for a range \code{xi} in \code{x}:
      \enumerate{
        \item Find the ranges in \code{subject} that overlap \code{xi}. If a
          single range \code{si} in \code{subject} overlaps \code{xi},
          \code{si} is returned as the nearest neighbor of \code{xi}. If there
          are multiple overlaps, one of the overlapping ranges is chosen
          arbitrarily.
        \item If no ranges in \code{subject} overlap with \code{xi}, then
          the range in \code{subject} with the shortest distance from its end
          to the start \code{xi} or its start to the end of \code{xi} is
          returned.
      }
    }
    \item{\code{precede(x, subject, select=c("first", "all"))}:}{
      For each range in \code{x}, \code{precede} returns the index of the
      interval in \code{subject} that is directly preceded by the query
      range. Overlapping ranges are excluded. \code{NA} is returned when
      there are no qualifying ranges in \code{subject}.
    }
    \item{\code{follow(x, subject, select=c("last", "all"))}:}{
      The opposite of \code{precede}, this function returns the index
      of the range in \code{subject} that a query range in \code{x}
      directly follows. Overlapping ranges are excluded. \code{NA} is
      returned when there are no qualifying ranges in \code{subject}.
    }
    \item{\code{distance(x, y)}:}{
      Returns the distance for each range in \code{x} to the range in
      \code{y}.

      The \code{distance} method differs from others documented on this
      page in that it is symmetric; \code{y} cannot be missing. If \code{x}
      and \code{y} are not the same length, the shortest will be recycled to
      match the length of the longest. The \code{select} argument is not
      available for \code{distance} because comparisons are made in a
      pair-wise fashion. The return value is the length of the longest
      of \code{x} and \code{y}.

      The \code{distance} calculation changed in BioC 2.12 to accommodate
      zero-width ranges in a consistent and intuitive manner. The new distance
      can be explained by a \emph{block} model where a range is represented by
      a series of blocks of size 1. Blocks are adjacent to each other and there
      is no gap between them. A visual representation of \code{IRanges(4,7)}
      would be
      \preformatted{
        +-----+-----+-----+-----+
           4     5     6     7
      }

      The distance between two consecutive blocks is 0L (prior to
      Bioconductor 2.12 it was 1L). The new distance calculation now returns
      the size of the gap between two ranges.

      This change to distance affects the notion of overlaps in that
      we no longer say:

      x and y overlap   <=>   distance(x, y) == 0

      Instead we say

      x and y overlap    =>   distance(x, y) == 0

      or

      x and y overlap or are adjacent   <=>   distance(x, y) == 0
    }
    \item{\code{distanceToNearest(x, subject, select=c("arbitrary", "all"))}:}{
      Returns the distance for each range in \code{x} to its nearest
      neighbor in \code{subject}.
    }
    \item{\code{selectNearest(hits, x, subject)}:}{
      Selects the hits that have the minimum distance within those for
      each query range. Ties are possible and can be broken with
      \code{\link[S4Vectors]{breakTies}}.
    }
  }
}

\value{
  For \code{nearest()}, \code{precede()} and \code{follow()}, an integer
  vector of indices in \code{subject}, or a \link[S4Vectors]{Hits} object
  if \code{select="all"}.

  For \code{distance()}, an integer vector of distances between the ranges
  in \code{x} and \code{y}.

  For \code{distanceToNearest()}, a \link[S4Vectors]{Hits} object with
  a metadata column reporting the \code{distance} between the pair.
  Access the \code{distance} metadata column with the
  \code{\link[S4Vectors]{mcols}()} accessor.

  For \code{selectNearest()}, a \link[S4Vectors]{Hits} object, sorted by query.
}

\author{M. Lawrence}

\seealso{
  \itemize{
    \item \link[S4Vectors]{Hits} objects implemented in the \pkg{S4Vectors}
          package.

    \item \code{\link{findOverlaps}} for finding just the overlapping ranges.

    \item The \link{IntegerRanges} class.

    \item \link[GenomicRanges]{nearest-methods} in the \pkg{GenomicRanges}
          package for the \code{nearest()}, \code{precede()}, \code{follow()},
          \code{distance()}, and \code{distanceToNearest()} methods for
          \link[GenomicRanges]{GenomicRanges} objects.
  }
}

\examples{
## ------------------------------------------
## precede() and follow()
## ------------------------------------------
query <- IRanges(c(1, 3, 9), c(3, 7, 10))
subject <- IRanges(c(3, 2, 10), c(3, 13, 12))

precede(query, subject)     # c(3L, 3L, NA)
precede(IRanges(), subject) # integer()
precede(query, IRanges())   # rep(NA_integer_, 3)
precede(query)              # c(3L, 3L, NA)

follow(query, subject)      # c(NA, NA, 1L)
follow(IRanges(), subject)  # integer()
follow(query, IRanges())    # rep(NA_integer_, 3)
follow(query)               # c(NA, NA, 2L)

## ------------------------------------------
## nearest()
## ------------------------------------------
query <- IRanges(c(1, 3, 9), c(2, 7, 10))
subject <- IRanges(c(3, 5, 12), c(3, 6, 12))

nearest(query, subject) # c(1L, 1L, 3L)
nearest(query)          # c(2L, 1L, 2L)

## ------------------------------------------
## distance()
## ------------------------------------------
## adjacent
distance(IRanges(1,5), IRanges(6,10)) # 0L
## overlap
distance(IRanges(1,5), IRanges(3,7))  # 0L
## zero-width
sapply(-3:3, function(i) distance(shift(IRanges(4,3), i), IRanges(4,3)))
}

\keyword{utilities}
\keyword{methods}
