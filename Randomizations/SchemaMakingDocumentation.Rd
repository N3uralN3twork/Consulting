\name{schema{QuinnConsulting}}
\alias{}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Create a Randomized Design Schema
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Given a variety of DoE inputs, creates a completely randomized, block design schema
}
\usage{
schema(Sites, NSubjects, BlockSize, RRatio)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Sites}{Either the number of sites or a list of site codes}
  \item{NSubjects}{The number of subjects per site}
  \item{BlockSize}{The number of subjects per block}
  \item{RRatio}{The randomization ratio for treatments/controls}
%%     ~~Describe \code{x} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
Returns a data.frame containing the design schema
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Matthias Quinn
}
\note{
Created for STA 635 Consuting and Programming
}

\section{Warning}{
Don't share this outside of the classroom
}
%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{

## The function is currently defined as
schema(Sites, NSubjects, BlockSize, RRatio) 
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
