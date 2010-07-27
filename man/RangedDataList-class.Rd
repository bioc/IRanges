\name{RangedDataList-class}
\docType{class}
\alias{RangedDataList-class}

% Constructor
\alias{RangedDataList}

%% Combining, splitting
\alias{unlist,RangedDataList-method}
\alias{stack,RangedDataList-method}

\title{Lists of RangedData}
\description{
  A formal list of \code{\linkS4class{RangedData}}
  objects. Extends and inherits all its methods from
  \code{\linkS4class{Sequence}}. One use case is to group together
  all of the samples from an experiment generating data on ranges.
}

\section{Constructor}{
  \describe{
    \item{}{\code{RangedDataList(...)}: Concatenates the
      \code{RangedData} objects in \code{...} into a new \code{RangedDataList}.
    }
  }
}

\section{Combining and Splitting}{
  \describe{
    \item{}{\code{stack(x, indName = "sample")}: Uses \code{rbind} to
      combine the elements into a single \code{RangedData} object, with
      a factor, named \code{indName}, in the values indicating the
      source of each feature.
    }
  }
}

\author{Michael Lawrence}

\seealso{
  \code{\linkS4class{RangedData}}, the element type of this
  \code{\linkS4class{Sequence}}.
}
\examples{
  ranges <- IRanges(c(1,2,3),c(4,5,6))
  a <- RangedData(IRanges(c(1,2,3),c(4,5,6)), score = c(10L, 2L, NA))
  b <- RangedData(IRanges(c(1,2,4),c(4,7,5)), score = c(3L, 5L, 7L))
  RangedDataList(sample1 = a, sample2 = b)
}
\keyword{classes}
