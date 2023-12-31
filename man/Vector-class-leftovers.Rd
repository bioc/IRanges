\name{Vector-class-leftovers}
\docType{class}

\alias{window<-,Vector-method}
\alias{window<-.Vector}
\alias{window<-,vector-method}
\alias{window<-.vector}
\alias{window<-,factor-method}
\alias{window<-.factor}

\alias{tapply,ANY,Vector-method}
\alias{tapply,Vector,ANY-method}
\alias{tapply,Vector,Vector-method}

\alias{with,Vector-method}
\alias{eval}
\alias{eval,expression,Vector-method}
\alias{eval,language,Vector-method}

\title{Vector objects (old man page)}

\description{
  IMPORTANT NOTE - 4/29/2014: This man page is being refactored. Most of
  the things that used to be documented here have been moved to the man
  page for \link[S4Vectors]{Vector} objects located in the \pkg{S4Vectors}
  package.
}

\section{Evaluation}{
  In the following code snippets, \code{x} is a Vector object.
  
  \describe{
    \item{\code{with(x, expr)}:}{ Evaluates \code{expr} within
      \code{as.env(x)} via \code{eval(x)}.
    }
    \item{\code{eval(expr, envir, enclos=parent.frame())}:}{ Evaluates
      \code{expr} within \code{envir}, where \code{envir} is coerced to
      an environment with \code{as.env(envir, enclos)}. The \code{expr}
      is first processed with \code{\link{bquote}}, such that any
      escaped symbols are directly resolved in the calling frame.
    }
  }
}

\section{Convenience wrappers for common subsetting operations}{
  In the code snippets below, \code{x} is a Vector object or regular R vector
  object. The R vector object methods for \code{window} are defined in this
  package and the remaining methods are defined in base R.

  \describe{
    \item{\code{window(x, start=NA, end=NA, width=NA) <- value}:}{
      Replace the subsequence window specified on the left (i.e. the
      subsequence in \code{x} specified by \code{start}, \code{end} and
      \code{width}) by \code{value}.
      \code{value} must either be of class \code{class(x)}, belong to a
      subclass of \code{class(x)}, or be coercible to \code{class(x)} or a
      subclass of \code{class(x)}.
      The elements of \code{value} are repeated to create a Vector with the
      same number of elements as the width of the subsequence window it is
      replacing.
    }
  }
}

\section{Looping}{
  In the code snippets below, \code{x} is a Vector object.

  \describe{
    \item{\code{tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)}:}{
      Like the standard \code{\link[base]{tapply}} function defined in the
      base package, the \code{tapply} method for Vector objects applies a
      function to each cell of a ragged array, that is to each (non-empty)
      group of values given by a unique combination of the levels of certain
      factors.
    }
  }
}

\section{Coercion}{
  \describe{
    \item{\code{as.list(x)}:}{ coerce a Vector to a list, where the \code{i}th
      element of the result corresponds to \code{x[i]}.
    }
  }
}

\seealso{
  The \link[S4Vectors]{Vector} class defined and documented in the
  \pkg{S4Vectors} package.
}

\keyword{methods}
\keyword{classes}
