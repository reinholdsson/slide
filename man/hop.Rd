% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hop.R
\name{hop}
\alias{hop}
\alias{hop_vec}
\alias{hop_dbl}
\alias{hop_int}
\alias{hop_lgl}
\alias{hop_chr}
\alias{hop_dfr}
\alias{hop_dfc}
\title{Hop}
\usage{
hop(.x, .starts, .stops, .f, ...)

hop_vec(.x, .starts, .stops, .f, ..., .ptype = list())

hop_dbl(.x, .starts, .stops, .f, ...)

hop_int(.x, .starts, .stops, .f, ...)

hop_lgl(.x, .starts, .stops, .f, ...)

hop_chr(.x, .starts, .stops, .f, ...)

hop_dfr(
  .x,
  .starts,
  .stops,
  .f,
  ...,
  .names_to = NULL,
  .name_repair = c("unique", "universal", "check_unique")
)

hop_dfc(
  .x,
  .starts,
  .stops,
  .f,
  ...,
  .size = NULL,
  .name_repair = c("unique", "universal", "check_unique", "minimal")
)
}
\arguments{
\item{.x}{\verb{[vector]}

The vector to iterate over and apply \code{.f} to.}

\item{.starts, .stops}{\verb{[integer]}

Vectors of boundary locations that make up the windows to bucket \code{.x} with.
Both \code{.starts} and \code{.stops} will be recycled to their common size, and
that common size will be the size of the result. Both vectors should be
integer locations along \code{.x}, but out-of-bounds values are allowed.}

\item{.f}{\verb{[function / formula]}

If a \strong{function}, it is used as is.

If a \strong{formula}, e.g. \code{~ .x + 2}, it is converted to a function. There
are three ways to refer to the arguments:
\itemize{
\item For a single argument function, use \code{.}
\item For a two argument function, use \code{.x} and \code{.y}
\item For more arguments, use \code{..1}, \code{..2}, \code{..3} etc
}

This syntax allows you to create very compact anonymous functions.}

\item{...}{Additional arguments passed on to the mapped function.}

\item{.ptype}{\verb{[vector(0)]}

The prototype corresponding to the type of the output. Defaults to
a \code{list()}.}

\item{.names_to}{Optionally, the name of a column where the names
of \code{...} arguments are copied. These names are useful to identify
which row comes from which input. If supplied and \code{...} is not named,
an integer column is used to identify the rows.}

\item{.name_repair}{One of \code{"unique"}, \code{"universal"}, or
\code{"check_unique"}. See \code{\link[vctrs:vec_as_names]{vec_as_names()}} for the meaning of these
options.

With \code{vec_rbind()}, the repair function is applied to all inputs
separately. This is because \code{vec_rbind()} needs to align their
columns before binding the rows, and thus needs all inputs to
have unique names. On the other hand, \code{vec_cbind()} applies the
repair function after all inputs have been concatenated together
in a final data frame. Hence \code{vec_cbind()} allows the more
permissive minimal names repair.}

\item{.size}{If, \code{NULL}, the default, will determine the number of
rows in \code{vec_cbind()} output by using the standard recycling rules.

Alternatively, specify the desired number of rows, and any inputs
of length 1 will be recycled appropriately.}
}
\value{
A vector fulfilling the following invariants:

\subsection{\code{hop()}}{
\itemize{
\item \code{vec_size(hop(.x, .starts, .stops)) == vec_size_common(.starts, .stops)}
\item \code{vec_ptype(hop(.x, .starts, .stops)) == list()}
}

}

\subsection{\code{hop_vec()} and \verb{hop_*()} variants}{
\itemize{
\item \code{vec_size(hop_vec(.x, .starts, .stops)) == vec_size_common(.starts, .stops)}
\item \code{vec_size(hop_vec(.x, .starts, .stops)[[1]]) == 1L}
\item \code{vec_ptype(hop_vec(.x, .starts, .stops, .ptype = ptype)) == ptype}
}

}
}
\description{
\code{hop()} is the lower level engine that powers \code{\link[=slide]{slide()}} (at least in theory).
It has slightly different invariants than \code{slide()}, and is useful
when you either need to hand craft boundary locations, or want to compute a
result with a size that is different from \code{.x}.
}
\details{
\code{hop()} is very close to being a faster version of:\preformatted{map2(
  .starts,
  .stops,
  function(start, stop) \{
    x_slice <- vec_slice(.x, start:stop)
    .f(x_slice, ...)
  \}
)
}

Because of this, \code{\link[=hop_index]{hop_index()}} is often the more useful function. \code{hop()}
mainly exists for API completeness.

The main difference is that the start and stop values make up ranges of
\emph{possible} locations along \code{.x}, and it is not enforced that these locations
actually exist along \code{.x}. As an example, with \code{hop()} you can do the
following, which would be an error with \code{vec_slice()} because \code{0L} is
out of bounds.\preformatted{hop(c("a", "b"), .starts = 0L, .stops = 1L, ~.x)
#> [[1]]
#> [1] "a"
}

\code{hop()} allows these out of bounds values to be fully compatible with
\code{slide()}. It is always possible to construct a \code{hop()} call from a \code{slide()}
call. For example, the following are equivalent:\preformatted{slide(1:2, ~.x, .before = 1)

hop(1:2, .starts = c(0, 1), .stops = c(1, 2), ~.x)

#> [[1]]
#> [1] 1
#>
#> [[2]]
#> [1] 1 2
}
}
\examples{
# `hop()` let's you manually specify locations to apply `.f` at.
hop(1:3, .starts = c(1, 3), .stops = 3, ~.x)

# `hop()`'s start/stop locations are allowed to be out of bounds relative
# to the size of `.x`.
hop(
  mtcars,
  .starts = c(-1, 3),
  .stops  = c(2, 6),
  ~.x
)

}
\seealso{
\code{\link[=hop2]{hop2()}}, \code{\link[=hop_index]{hop_index()}}, \code{\link[=slide]{slide()}}
}
