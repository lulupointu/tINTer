# library("tidyverse")
library( 'rgl' )
library('magick')

P <- 0.6

f <- function(x, y){
    # P*(1 - 0.5*(x+y) + (1/P-0.5)*(x-y)^2)
    (x-y)^2
}

x <- rep(seq(0, 1, length=50), times=50)
y <- rep(seq(0, 1, length=50), each=50)
z <- f(x, y)


# Prints static 3D plot
# persp(x, y, z,
#         ticktype="detailed", 
#         theta=0, 
#         col='cyan',
# ) 

a = c(1, 0, 0)
b = c(1, 1, 0)
c = c(1, 1, 1)

print(sum(f(a, b)))
print(sum(f(b, c)))


# Static chart
plot3d( x, y, z, radius = 1)

# # We can indicate the axis and the rotation velocity
play3d( spin3d( axis = c(0, 0, 1), rpm = 20), duration = 1 )

# # Save like gif
# movie3d(
#   movie="3dAnimatedScatterplot", 
#   spin3d( axis = c(0, 0, 1), rpm = 4),
#   duration = 15, 
#   dir = "~/Desktop",
#   type = "gif", 
#   clean = TRUE
# )

# cone <- function(x, y){
# sqrt(x^2+y^2)
# }
# x <- y <- seq(-1, 1, length= 20)
# z <- outer(x, y, cone)
# persp(x, y, z)